import xml.etree.ElementTree as ET
import requests
import time
import argparse
import hashlib
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor, as_completed
from threading import Lock
from tqdm import tqdm

# =========================
# CONFIG
# =========================
BASE_URL = "https://de5.darkorbit.com/spacemap"
XML_FILES = ["resources.xml", "resources_3d.xml"]

OUTPUT_DIR = Path("spacemap")
FAILED_LOG = Path("failed_downloads.txt")
RECOVER_LOG = Path("failed_recover.txt")
CHECK_LOG = Path("failed_check.txt")
MD5_LOG = Path("failed_md5.txt")

WORKERS = 8
TIMEOUT = 30
RETRIES = 4
RETRY_DELAY = 2
CHUNK_SIZE = 8192

# =========================
# HTTP SESSION
# =========================
session = requests.Session()
session.headers.update({
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120",
    "Accept": "*/*",
    "Connection": "keep-alive",
    "Referer": "https://de5.darkorbit.com/"
})

log_lock = Lock()

# =========================
# XML PARSER
# =========================
def parse_xml(xml_path):
    tree = ET.parse(xml_path)
    root = tree.getroot()

    locations = {
        loc.attrib["id"]: loc.attrib["path"]
        for loc in root.findall("location")
    }

    jobs = []
    for f in root.findall("file"):
        loc_id = f.attrib.get("location")
        name = f.attrib.get("name")
        ftype = f.attrib.get("type")
        md5 = f.attrib.get("hash")

        if loc_id not in locations:
            continue

        rel = locations[loc_id]
        url = f"{BASE_URL}/{rel}{name}.{ftype}"
        local = OUTPUT_DIR / rel / f"{name}.{ftype}"

        jobs.append((url, local, md5, f))

    return jobs, tree

# =========================
# FAILED LOG PARSER
# =========================
def parse_failed_log(path):
    jobs = []
    if not path.exists():
        return jobs

    for line in path.read_text(encoding="utf-8").splitlines():
        if "|" not in line:
            continue
        _, url = line.split("|", 1)
        url = url.strip()
        rel = url.replace(BASE_URL + "/", "")
        jobs.append((url, OUTPUT_DIR / rel, None, None))

    return jobs

# =========================
# DOWNLOAD
# =========================
def download(job):
    url, path, _, _ = job

    if path.exists():
        return "SKIP", url

    path.parent.mkdir(parents=True, exist_ok=True)

    for attempt in range(1, RETRIES + 1):
        try:
            r = session.get(url, stream=True, timeout=TIMEOUT)
            if r.status_code == 200:
                with open(path, "wb") as f:
                    for chunk in r.iter_content(CHUNK_SIZE):
                        if chunk:
                            f.write(chunk)
                return "OK", url

            if r.status_code in (429, 503):
                time.sleep(RETRY_DELAY * attempt)
                continue

            return f"HTTP {r.status_code}", url

        except Exception:
            time.sleep(RETRY_DELAY * attempt)

    return "FAILED", url

# =========================
# MD5
# =========================
def md5sum(path):
    h = hashlib.md5()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            h.update(chunk)
    return h.hexdigest()

# =========================
# CHECK MISSING
# =========================
def check_missing():
    CHECK_LOG.write_text("")
    missing = 0

    all_jobs = []
    for xml in XML_FILES:
        jobs, _ = parse_xml(xml)
        all_jobs.extend(jobs)

    for url, local, _, _ in tqdm(all_jobs, desc="CHECK missing"):
        if not local.exists():
            missing += 1
            with CHECK_LOG.open("a", encoding="utf-8") as f:
                f.write(f"MISSING | {url}\n")

    print(f"\n❌ Missing files: {missing}")
    print(f"📄 Log: {CHECK_LOG.resolve()}")

# =========================
# MD5 CHECK
# =========================
def check_md5():
    MD5_LOG.write_text("")
    bad = 0
    total = 0

    all_jobs = []
    for xml in XML_FILES:
        jobs, _ = parse_xml(xml)
        all_jobs.extend(jobs)

    for _, local, expected, _ in tqdm(all_jobs, desc="MD5 check"):
        if not expected or not local.exists():
            continue

        total += 1
        actual = md5sum(local)

        if actual.lower() != expected.lower():
            bad += 1
            with MD5_LOG.open("a", encoding="utf-8") as f:
                f.write(f"MD5_MISMATCH | {local} | {actual} != {expected}\n")

    print(f"\nMD5 checked : {total}")
    print(f"MD5 mismatch: {bad}")
    print(f"📄 Log: {MD5_LOG.resolve()}")

# =========================
# MD5 FIX (XML UPDATE)
# =========================
def fix_md5():
    for xml in XML_FILES:
        jobs, tree = parse_xml(xml)
        root = tree.getroot()
        fixed = 0

        for _, local, _, file_node in tqdm(jobs, desc=f"MD5 fix {xml}"):
            if not local.exists() or file_node is None:
                continue

            new_md5 = md5sum(local)
            file_node.set("hash", new_md5)
            fixed += 1

        tree.write(xml, encoding="utf-8", xml_declaration=True)
        print(f"✔ {xml}: updated {fixed} hashes")

# =========================
# MAIN
# =========================
def main():
    parser = argparse.ArgumentParser(
        description="DarkOrbit spacemap asset downloader"
    )

    parser.add_argument("--download", action="store_true", help="Download all assets")
    parser.add_argument("--missing", action="store_true", help="Retry failed downloads")
    parser.add_argument("--check", action="store_true", help="Check missing files")
    parser.add_argument("--md5", action="store_true", help="Verify MD5 hashes")
    parser.add_argument("--md5_fix", action="store_true", help="Rewrite XML hashes from local files")

    args = parser.parse_args()

    if not any(vars(args).values()):
        parser.print_help()
        return

    OUTPUT_DIR.mkdir(exist_ok=True)

    if args.check:
        check_missing()
        return

    if args.md5:
        check_md5()
        return

    if args.md5_fix:
        fix_md5()
        return

    if args.missing:
        jobs = parse_failed_log(FAILED_LOG)
        RECOVER_LOG.write_text("")
        log_path = RECOVER_LOG
        mode = "RECOVERY"
    elif args.download:
        jobs = []
        for xml in XML_FILES:
            j, _ = parse_xml(xml)
            jobs.extend(j)
        FAILED_LOG.write_text("")
        log_path = FAILED_LOG
        mode = "FULL"
    else:
        return

    print(f"\nMODE    : {mode}")
    print(f"JOBS    : {len(jobs)}")
    print(f"THREADS : {WORKERS}\n")

    ok = skip = fail = 0

    with ThreadPoolExecutor(max_workers=WORKERS) as pool:
        futures = [pool.submit(download, j) for j in jobs]

        for f in tqdm(as_completed(futures), total=len(futures), desc="DOWNLOAD"):
            status, url = f.result()
            if status == "OK":
                ok += 1
            elif status == "SKIP":
                skip += 1
            else:
                fail += 1
                with log_lock:
                    with log_path.open("a", encoding="utf-8") as lf:
                        lf.write(f"{status} | {url}\n")

    print("\n============================")
    print("SUMMARY")
    print("============================")
    print(f"OK   : {ok}")
    print(f"SKIP : {skip}")
    print(f"FAIL : {fail}")
    print(f"LOG  : {log_path.resolve()}")

if __name__ == "__main__":
    main()
