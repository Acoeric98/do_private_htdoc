<?php
$rootPath = realpath(__DIR__ . '/../../');
$portalPath = $rootPath ? $rootPath . '/maps.txt' : null;
$cbsPath = $rootPath ? $rootPath . '/cbs.txt' : null;

function read_file_safely(?string $path): string {
  if (!$path || !file_exists($path)) {
    return '';
  }

  $contents = file_get_contents($path);
  return is_string($contents) ? $contents : '';
}

$portalText = read_file_safely($portalPath);
$cbsText = read_file_safely($cbsPath);

$portalUrl = DOMAIN . 'maps.txt';
$cbsUrl = DOMAIN . 'cbs.txt';

$samplePortals = <<<TXT
FROM\tpos\tTO\tpos
3-1\t20/20\t3-2\t185/115
3-2\t185/115\t3-1\t20/20
3-2\t185/20\t3-3\t185/115
3-2\t20/20\t3-4\t185/115
3-3\t20/115\t3-4\t185/20
3-4\t100/15\t4-3\t190/60
3-4\t20/20\t1-4\t20/115
1-4\t190/60\t4-1\t15/60
1-4\t20/20\t1-2\t185/115
1-2\t20/20\t1-1\t185/115
2-2\t185/20\t2-1\t20/115
2-2\t185/115\t2-4\t20/20
2-4\t100/120\t4-2\t100/15
4-2\t105/67\t4-4\t219/119
4-4\t192/135\t4-1\t105/67
4-4\t219/145\t4-3\t105/67
TXT;

$sampleCbs = <<<TXT
MAP\tPOS
3-4\t45/90
3-3\t105/25
3-5\t110/90
3-6\t95/80
3-7\t105/45
1-3\t106/24
1-4\t44/90
1-5\t170/25
1-6\t100/60
1-7\t100/72
2-3\t105/25
2-4\t160/85
2-5\t105/90
2-6\t85/65
2-7\t105/55
4-2\t115/60
4-1\t100/55
4-3\t88/60
4-4\t90/55
4-5\t120/55
TXT;
?>

<div id="main" class="map-page">
  <div class="map-header">
    <div class="panel">
      <button id="relayoutBtn" type="button">Re-layout</button>
      <button id="resetViewBtn" type="button">Nézet visszaállítása</button>
      <span class="stat" id="stat">csomópontok: 0 • élek: 0</span>
    </div>
    <div class="hint">
      Automatikusan beolvas a <b>maps.txt</b> és <b>cbs.txt</b> fájlokból (szerver gyökérmappa).<br/>
      Rendezett nézet: minden csoport (1-*,2-*,3-*,4-*,5-*) a második szám szerint (fentről lefelé) kerül sorba.
      Színek: 1-* piros, 2-* kék, 3-* zöld, PVP (4-1..4-5) narancs.
      Kattints egy hexára a szomszédok kiemeléséhez és a portálpozíciók megnyitásához.
      A CBS opcionális (külön fájl): narancs <b>CBS</b> jelölők jelennek meg a térképen.
      Kezelés: húzás = panoráma • görgő = nagyítás • Bezárás: <span class="kbd">Esc</span>
    </div>
  </div>

  <div id="wrap">
    <svg id="svg" aria-label="Galaxy viewer">
      <g id="view"></g>
    </svg>
  </div>

  <div class="legend">
    <b>Jelmagyarázat</b><br/>
    <span class="sw" style="background:rgba(255,75,75,.95)"></span>1-* VRU
    <span class="sw" style="background:rgba(47,140,255,.95);margin-left:12px;"></span>2-* MMO
    <span class="sw" style="background:rgba(46,234,122,.95);margin-left:12px;"></span>3-* EIC
    <span class="sw" style="background:rgba(255,176,74,.95);margin-left:12px;"></span>PVP 4-*<br/>
    Piros pont = portál (FROM pozíció). Narancs, CBS felirattal = CBS marker (ha a CBS fájl elérhető).<br/>
    Térképméretek: 4-4 és 4-5: 418×260; a többi: 210×130.
  </div>
</div>

<div id="modal" class="modal" role="dialog" aria-modal="true">
  <div class="modal-inner">
    <div class="modal-head">
      <b id="modalTitle">Map</b>
      <button id="closeModal" class="close">X</button>
    </div>
    <div class="modal-body">
      <div class="card">
        <div class="card-title">
          <span>Térkép nézet</span>
          <span>
            <span id="mapSizeTag" class="pill">210×130</span>
            <span id="cbsTag" class="pill">CBS: 0</span>
            <span id="portalCountTag" class="pill">Portálok: 0</span>
          </span>
        </div>
        <div class="mapwrap" id="mapWrap"></div>
      </div>

      <div class="card">
        <div class="card-title">
          <span>Portál lista (FROM → TO)</span>
          <span class="pill">a térképre kattintva nyílik</span>
        </div>
        <div class="list" id="portalList"></div>
      </div>
    </div>
  </div>
</div>

<script>
(() => {
  const SERVER_PORTAL_TEXT = <?php echo json_encode($portalText); ?>;
  const SERVER_CBS_TEXT = <?php echo json_encode($cbsText); ?>;
  const PORTAL_URL = <?php echo json_encode($portalUrl); ?>;
  const CBS_URL = <?php echo json_encode($cbsUrl); ?>;
  const SAMPLE_PORTALS = <?php echo json_encode($samplePortals); ?>;
  const SAMPLE_CBS = <?php echo json_encode($sampleCbs); ?>;

  // ===== Config =====
  const DEFAULT_MAP = { w: 210, h: 130 };
  const SPECIAL_SIZES = {
    "4-4": { w: 418, h: 260 },
    "4-5": { w: 418, h: 260 },
  };
  const PVP_ORANGE = new Set(["4-1","4-2","4-3","4-4","4-5"]);
  const getMapSize = (name) => SPECIAL_SIZES[name] || DEFAULT_MAP;

  // Galaxy placement columns (left->right)
  const COL_X = { 3: 0.18, 4: 0.50, 2: 0.82, 1: 0.30, 5: 0.52, 0: 0.50 };

  // ===== Elements =====
  const svg = document.getElementById("svg");
  const view = document.getElementById("view");
  const stat = document.getElementById("stat");

  const relayoutBtn = document.getElementById("relayoutBtn");
  const resetViewBtn = document.getElementById("resetViewBtn");

  const modal = document.getElementById("modal");
  const closeModalBtn = document.getElementById("closeModal");
  const modalTitle = document.getElementById("modalTitle");
  const mapWrap = document.getElementById("mapWrap");
  const portalList = document.getElementById("portalList");
  const mapSizeTag = document.getElementById("mapSizeTag");
  const portalCountTag = document.getElementById("portalCountTag");
  const cbsTag = document.getElementById("cbsTag");

  // ===== Helpers =====
  const NS = "http://www.w3.org/2000/svg";
  function clear(el){ while (el.firstChild) el.removeChild(el.firstChild); }
  function clamp(n, a, b){ return Math.max(a, Math.min(b, n)); }

  function normalizeLine(line) {
    return line.trim().replace(/\u00A0/g, " ");
  }

  function parsePos(posStr) {
    if (!posStr) return null;
    const m = String(posStr).trim().match(/^(\d+)\s*\/\s*(\d+)$/);
    if (!m) return null;
    const x = Number(m[1]), y = Number(m[2]);
    if (!Number.isFinite(x) || !Number.isFinite(y)) return null;
    return { x, y };
  }

  function groupOf(id) {
    const m = id.match(/^(\d+)\-/);
    return m ? Number(m[1]) : 0;
  }
  function secondOf(id) {
    const m = id.match(/^\d+\-(\d+)$/);
    return m ? Number(m[1]) : 0;
  }
  function colorClass(id) {
    const g = groupOf(id);
    if (PVP_ORANGE.has(id)) return "g4";
    if (g === 1) return "g1";
    if (g === 2) return "g2";
    if (g === 3) return "g3";
    if (g === 4) return "g4";
    if (g === 5) return "g5";
    return "g2";
  }

  function hexPoints(cx, cy, r) {
    const pts = [];
    for (let i = 0; i < 6; i++) {
      const a = (Math.PI / 180) * (60 * i); // flat-top
      pts.push([cx + r * Math.cos(a), cy + r * Math.sin(a)]);
    }
    return pts.map(p => p[0].toFixed(2) + "," + p[1].toFixed(2)).join(" ");
  }

  // ===== Parse portal rows (FROM pos TO pos) =====
  function parsePortalRows(text) {
    const lines = text.split(/\r?\n/).map(normalizeLine).filter(Boolean);
    const headerish = lines[0] && lines[0].toLowerCase().includes("from") && lines[0].toLowerCase().includes("to");
    const dataLines = headerish ? lines.slice(1) : lines;

    const rows = [];
    for (const line of dataLines) {
      let parts = line.split("\t").map(s => s.trim()).filter(Boolean);
      if (parts.length < 4) parts = line.split(/\s+/).map(s => s.trim()).filter(Boolean);
      if (parts.length < 4) continue;

      rows.push({
        from: parts[0],
        fromPosRaw: parts[1],
        to: parts[2],
        toPosRaw: parts[3],
      });
    }
    return rows;
  }

  // ===== Parse CBS file (MAP POS) =====
  // Supports format with header: MAP POS
  function parseCbs(text) {
    const lines = text.split(/\r?\n/).map(normalizeLine).filter(Boolean);

    // drop header if present
    let start = 0;
    if (lines[0] && lines[0].toLowerCase().includes("map") && lines[0].toLowerCase().includes("pos")) {
      start = 1;
    }

    const out = new Map();
    for (const line of lines.slice(start)) {
      let parts = line.split("\t").map(s => s.trim()).filter(Boolean);
      if (parts.length < 2) parts = line.split(/\s+/).map(s => s.trim()).filter(Boolean);
      if (parts.length < 2) continue;

      const map = parts[0];
      const pos = parsePos(parts[1]);
      if (!map || !pos) continue;

      if (!out.has(map)) out.set(map, []);
      out.get(map).push(pos);
    }
    return out;
  }

  // ===== Graph build =====
  function buildGraph(rows) {
    const nodes = new Map();
    const edgeSet = new Set();

    function ensure(name) {
      if (!name || name === "LOW") return null;
      if (!nodes.has(name)) {
        const isBig = (name === "4-4" || name === "4-5");
        nodes.set(name, { id: name, x: 0, y: 0, vx: 0, vy: 0, r: isBig ? 34 : 26, tx: 0, ty: 0 });
      }
      return nodes.get(name);
    }

    for (const r of rows) {
      const a = ensure(r.from);
      const b = ensure(r.to);
      if (!a || !b) continue;
      const key = a.id < b.id ? `${a.id}__${b.id}` : `${b.id}__${a.id}`;
      edgeSet.add(key);
    }

    const edges = Array.from(edgeSet).map(k => {
      const [s, t] = k.split("__");
      return { source: s, target: t };
    });

    const adj = new Map();
    for (const n of nodes.values()) adj.set(n.id, new Set());
    for (const e of edges) {
      const srcAdj = adj.get(e.source);
      const tgtAdj = adj.get(e.target);
      if (srcAdj) srcAdj.add(e.target);
      if (tgtAdj) tgtAdj.add(e.source);
    }

    return { nodes: Array.from(nodes.values()), edges, adj };
  }

  // ===== Ordered targets =====
  function assignOrderedTargets(nodes) {
    const w = svg.clientWidth;
    const h = svg.clientHeight;

    const byG = new Map();
    for (const n of nodes) {
      const g = groupOf(n.id);
      if (!byG.has(g)) byG.set(g, []);
      byG.get(g).push(n);
    }
    for (const [g, list] of byG) {
      list.sort((a,b) => secondOf(a.id) - secondOf(b.id) || a.id.localeCompare(b.id));
    }

    const spans = {
      3: { y0: h*0.12, y1: h*0.48 },
      2: { y0: h*0.20, y1: h*0.50 },
      1: { y0: h*0.62, y1: h*0.92 },
      4: { y0: h*0.26, y1: h*0.78 },
      5: { y0: h*0.12, y1: h*0.42 },
      0: { y0: h*0.30, y1: h*0.70 },
    };

    for (const [g, list] of byG) {
      const colVal = (COL_X[g] !== undefined && COL_X[g] !== null) ? COL_X[g] : COL_X[0];
      const span = (spans[g] !== undefined && spans[g] !== null) ? spans[g] : spans[0];
      const colX = colVal * w;
      const count = Math.max(1, list.length);

      for (let i = 0; i < list.length; i++) {
        const t = (count === 1) ? 0.5 : (i / (count - 1));
        let ty = span.y0 + (span.y1 - span.y0) * t;

        if (list[i].id === "4-4") ty = h*0.72;
        if (list[i].id === "4-5") ty = h*0.30;

        list[i].tx = colX;
        list[i].ty = ty;
      }
    }

    for (const n of nodes) {
      n.x = n.tx + (Math.random()-0.5)*30;
      n.y = n.ty + (Math.random()-0.5)*30;
      n.vx = 0; n.vy = 0;
    }
  }

  function runForce(graph, steps = 650) {
    const nodes = graph.nodes;
    const edges = graph.edges;

    const REPULSE = 5200;
    const SPRING = 0.010;
    const SPRING_LEN = 160;
    const DAMP = 0.86;
    const ANCHOR = 0.020;

    const byId = new Map(nodes.map(n => [n.id, n]));

    for (let iter = 0; iter < steps; iter++) {
      for (let i = 0; i < nodes.length; i++) {
        for (let j = i+1; j < nodes.length; j++) {
          const a = nodes[i], b = nodes[j];
          let dx = a.x - b.x;
          let dy = a.y - b.y;
          let d2 = dx*dx + dy*dy + 0.01;

          const minD = (a.r + b.r) * 1.20;
          if (d2 < minD*minD) d2 = minD*minD;

          const f = REPULSE / d2;
          const invD = 1 / Math.sqrt(d2);
          const fx = dx * invD * f;
          const fy = dy * invD * f;

          a.vx += fx; a.vy += fy;
          b.vx -= fx; b.vy -= fy;
        }
      }

      for (const e of edges) {
        const a = byId.get(e.source);
        const b = byId.get(e.target);
        if (!a || !b) continue;

        const dx = b.x - a.x;
        const dy = b.y - a.y;
        const dist = Math.sqrt(dx*dx + dy*dy) + 0.01;
        const diff = dist - SPRING_LEN;

        const f = diff * SPRING;
        const fx = (dx / dist) * f;
        const fy = (dy / dist) * f;

        a.vx += fx; a.vy += fy;
        b.vx -= fx; b.vy -= fy;
      }

      for (const n of nodes) {
        n.vx += (n.tx - n.x) * ANCHOR;
        n.vy += (n.ty - n.y) * ANCHOR;

        n.vx *= DAMP;
        n.vy *= DAMP;

        n.x += n.vx * 0.03;
        n.y += n.vy * 0.03;
      }
    }
  }

  // ===== State =====
  let currentPortalRows = [];
  let currentGraph = null;
  let selectedId = null;
  let cbsByMap = new Map(); // optional

  // ===== Render galaxy =====
  function drawGalaxy(graph) {
    clear(view);

    const byId = new Map(graph.nodes.map(n => [n.id, n]));
    const gEdges = document.createElementNS(NS, "g");
    const gNodes = document.createElementNS(NS, "g");
    view.appendChild(gEdges);
    view.appendChild(gNodes);

    const edgeEls = [];
    for (const e of graph.edges) {
      const a = byId.get(e.source);
      const b = byId.get(e.target);
      if (!a || !b) continue;

      const line = document.createElementNS(NS, "line");
      line.setAttribute("x1", a.x);
      line.setAttribute("y1", a.y);
      line.setAttribute("x2", b.x);
      line.setAttribute("y2", b.y);
      line.setAttribute("class", "edge");
      gEdges.appendChild(line);
      edgeEls.push({ el: line, s: e.source, t: e.target });
    }

    const nodeEls = [];
    for (const n of graph.nodes) {
      const group = document.createElementNS(NS, "g");
      group.style.cursor = "pointer";

      const poly = document.createElementNS(NS, "polygon");
      const baseClass = colorClass(n.id);
      poly.setAttribute("points", hexPoints(n.x, n.y, n.r));
      poly.setAttribute("class", `hex ${baseClass}`);
      group.appendChild(poly);

      const text = document.createElementNS(NS, "text");
      text.textContent = n.id;
      text.setAttribute("x", n.x);
      text.setAttribute("y", n.y + 1);
      text.setAttribute("class", "label");
      group.appendChild(text);

      group.addEventListener("click", (ev) => {
        ev.stopPropagation();
        selectNode(n.id, graph, nodeEls, edgeEls);
        openMapModal(n.id);
      });

      gNodes.appendChild(group);
      nodeEls.push({ id: n.id, poly, text, baseClass });
    }

    // background click to clear highlight
    svg.addEventListener("click", () => {
      selectedId = null;
      applyHighlight(graph, nodeEls, edgeEls);
    }, { once: true });

    applyHighlight(graph, nodeEls, edgeEls);
  }

  function selectNode(id, graph, nodeEls, edgeEls) {
    selectedId = (selectedId === id) ? null : id;
    applyHighlight(graph, nodeEls, edgeEls);
  }

  function applyHighlight(graph, nodeEls, edgeEls) {
    if (!selectedId) {
      for (const ne of nodeEls) {
        ne.poly.setAttribute("class", `hex ${ne.baseClass}`);
        ne.text.setAttribute("class", "label");
      }
      for (const ee of edgeEls) ee.el.setAttribute("class", "edge");
      return;
    }

    const neighbors = new Set(graph.adj.get(selectedId) || []);
    neighbors.add(selectedId);

    for (const ne of nodeEls) {
      const hot = neighbors.has(ne.id);
      ne.poly.setAttribute("class", hot ? `hex hot ${ne.baseClass}` : `hex dim ${ne.baseClass}`);
      ne.text.setAttribute("class", hot ? "label" : "label dim");
    }
    for (const ee of edgeEls) {
      const hot = (ee.s === selectedId && neighbors.has(ee.t)) || (ee.t === selectedId && neighbors.has(ee.s));
      ee.el.setAttribute("class", hot ? "edge hot" : "edge dim");
    }
  }

  // ===== Pan/Zoom =====
  let viewX = 0, viewY = 0, viewS = 1;
  function setTransform() { view.setAttribute("transform", `translate(${viewX},${viewY}) scale(${viewS})`); }
  function resetView() { viewX = 0; viewY = 0; viewS = 1; setTransform(); }

  let dragging = false;
  let last = null;

  svg.addEventListener("mousedown", (e) => {
    dragging = true;
    last = { x: e.clientX, y: e.clientY };
  });
  window.addEventListener("mouseup", () => { dragging = false; last = null; });
  window.addEventListener("mousemove", (e) => {
    if (!dragging || !last) return;
    const dx = e.clientX - last.x;
    const dy = e.clientY - last.y;
    last = { x: e.clientX, y: e.clientY };
    viewX += dx;
    viewY += dy;
    setTransform();
  });

  svg.addEventListener("wheel", (e) => {
    e.preventDefault();
    const delta = -e.deltaY;
    const factor = delta > 0 ? 1.08 : 1/1.08;

    const rect = svg.getBoundingClientRect();
    const mx = e.clientX - rect.left;
    const my = e.clientY - rect.top;

    const prevS = viewS;
    viewS = Math.max(0.25, Math.min(3.5, viewS * factor));
    const k = viewS / prevS;

    viewX = mx - (mx - viewX) * k;
    viewY = my - (my - viewY) * k;

    setTransform();
  }, { passive:false });

  // ===== Modal map view =====
  function openMapModal(mapName) {
    const size = getMapSize(mapName);
    modalTitle.textContent = `Térkép ${mapName} • portál + CBS pozíciók`;
    mapSizeTag.textContent = `${size.w}×${size.h}`;

    const portals = currentPortalRows
      .filter(r => r.from === mapName)
      .map(r => ({
        from: r.from,
        pos: parsePos(r.fromPosRaw),
        posRaw: r.fromPosRaw,
        to: r.to,
        toPosRaw: r.toPosRaw
      }))
      .filter(p => p.pos);

    const cbsList = cbsByMap.get(mapName) || [];
    cbsTag.textContent = `CBS: ${cbsList.length}`;
    portalCountTag.textContent = `Portálok: ${portals.length}`;

    clear(mapWrap);
    const mapSvg = document.createElementNS(NS, "svg");
    mapSvg.classList.add("mapsvg");
    mapSvg.setAttribute("viewBox", `0 0 ${size.w} ${size.h}`);
    mapSvg.setAttribute("preserveAspectRatio", "xMidYMid meet");

    const step = (size.w >= 400 || size.h >= 260) ? 20 : 10;
    for (let x = step; x < size.w; x += step) {
      const l = document.createElementNS(NS, "line");
      l.setAttribute("x1", x); l.setAttribute("y1", 0);
      l.setAttribute("x2", x); l.setAttribute("y2", size.h);
      l.setAttribute("class", "gridline");
      mapSvg.appendChild(l);
    }
    for (let y = step; y < size.h; y += step) {
      const l = document.createElementNS(NS, "line");
      l.setAttribute("x1", 0); l.setAttribute("y1", y);
      l.setAttribute("x2", size.w); l.setAttribute("y2", y);
      l.setAttribute("class", "gridline");
      mapSvg.appendChild(l);
    }

    const frame = document.createElementNS(NS, "rect");
    frame.setAttribute("x", "0");
    frame.setAttribute("y", "0");
    frame.setAttribute("width", String(size.w));
    frame.setAttribute("height", String(size.h));
    frame.setAttribute("class", "mapframe");
    mapSvg.appendChild(frame);

    for (const p of portals) {
      const x = clamp(p.pos.x, 0, size.w);
      const y = clamp(p.pos.y, 0, size.h);

      const dot = document.createElementNS(NS, "circle");
      dot.setAttribute("cx", String(x));
      dot.setAttribute("cy", String(y));
      dot.setAttribute("r", String(Math.max(3.8, Math.min(size.w, size.h) * 0.012)));
      dot.setAttribute("class", "portalDot");
      mapSvg.appendChild(dot);

      const label = document.createElementNS(NS, "text");
      label.setAttribute("x", String(x + 7));
      label.setAttribute("y", String(y + 4));
      label.setAttribute("class", "portalLabel");
      label.textContent = (p.to || "?").trim() || "?";
      mapSvg.appendChild(label);
    }

    for (const c of cbsList) {
      const x = clamp(c.x, 0, size.w);
      const y = clamp(c.y, 0, size.h);

      const dot = document.createElementNS(NS, "circle");
      dot.setAttribute("cx", String(x));
      dot.setAttribute("cy", String(y));
      dot.setAttribute("r", String(Math.max(4.2, Math.min(size.w, size.h) * 0.014)));
      dot.setAttribute("class", "cbsDot");
      mapSvg.appendChild(dot);

      const label = document.createElementNS(NS, "text");
      label.setAttribute("x", String(x + 7));
      label.setAttribute("y", String(y - 6));
      label.setAttribute("class", "cbsLabel");
      label.textContent = "CBS";
      mapSvg.appendChild(label);
    }

    mapWrap.appendChild(mapSvg);

    portalList.innerHTML = "";
    if (portals.length === 0) {
      portalList.innerHTML = `<div class="item"><b>Nincs portál</b><div style="margin-top:6px;">Ehhez a térképhez nem találtunk érvényes FROM pozíciókat.</div></div>`;
    } else {
      for (const p of portals) {
        const div = document.createElement("div");
        div.className = "item";
        div.innerHTML = `
          <b>${p.from}</b> <span class="pill">${p.posRaw}</span>
          <div style="margin-top:6px;color:rgba(233,251,255,.86)">
            → <b>${p.to}</b> <span class="pill">${p.toPosRaw || "?"}</span>
          </div>
        `;
        portalList.appendChild(div);
      }
    }

    modal.classList.add("open");
  }

  function closeMapModal() {
    modal.classList.remove("open");
    clear(mapWrap);
    portalList.innerHTML = "";
  }

  closeModalBtn.addEventListener("click", closeMapModal);
  modal.addEventListener("click", (e) => { if (e.target === modal) closeMapModal(); });

  window.addEventListener("keydown", (e) => {
    if (e.key === "Escape") {
      if (modal.classList.contains("open")) closeMapModal();
      selectedId = null;
    }
  });

  // ===== Load functions =====
  function rebuildGalaxy() {
    const graph = buildGraph(currentPortalRows);
    assignOrderedTargets(graph.nodes);
    runForce(graph, 650);
    currentGraph = graph;

    stat.textContent = `csomópontok: ${graph.nodes.length} • élek: ${graph.edges.length}`;
    drawGalaxy(graph);
    resetView();
  }

  function loadPortalText(text) {
    currentPortalRows = parsePortalRows(text);
    rebuildGalaxy();
  }

  function loadCbsText(text) {
    cbsByMap = parseCbs(text);
  }

  async function fetchText(url, fallback) {
    if (!url) return fallback;
    try {
      const res = await fetch(url, { cache: "no-cache" });
      if (!res.ok) return fallback;
      const t = await res.text();
      return t && t.trim() ? t : fallback;
    } catch (err) {
      console.warn("Fetch failed", url, err);
      return fallback;
    }
  }

  async function loadFromServer() {
    const portalText = await fetchText(PORTAL_URL, SERVER_PORTAL_TEXT || SAMPLE_PORTALS);
    const cbsText = await fetchText(CBS_URL, SERVER_CBS_TEXT || SAMPLE_CBS);
    loadPortalText(portalText);
    if (cbsText && cbsText.trim()) {
      loadCbsText(cbsText);
    } else {
      cbsByMap = new Map();
    }
  }

  relayoutBtn.addEventListener("click", () => {
    if (!currentGraph) return;
    assignOrderedTargets(currentGraph.nodes);
    runForce(currentGraph, 650);
    drawGalaxy(currentGraph);
  });

  resetViewBtn.addEventListener("click", resetView);

  loadFromServer();
})();
</script>
