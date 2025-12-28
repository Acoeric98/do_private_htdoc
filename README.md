# DarkOrbit CMS

## Megjegyzés a Flashről

A beépített játék chat üres képernyője nem Flash-player problémából fakad. Az equipment modul ugyanúgy Flash alapú és rendben betölt, ezért a hiba forrása máshol keresendő. NEM A FLASH A PROBLÉMA.

## Projektstruktúra gyorsfa

```
.
├─ index.php → files/redirect.php
├─ files/
│  ├─ config.php                # Alapbeállítások (DB, socket, domain, session)
│  ├─ redirect.php              # Belépési pont, Functions::LoadPage hívása
│  ├─ api.php                   # POST alapú API, Functions::* végpontokkal
│  ├─ classes/                  # Magosztályok
│  │  ├─ Database.php           # MySQL kapcsolat (mysqli)
│  │  ├─ Functions.php          # Üzleti logika + oldalbetöltés
│  │  ├─ Socket.php             # Játék szerver-socket kapcsolat
│  │  └─ SMTP.php               # PHPMailer wrapper e-mailhez
│  ├─ external/                 # Felhasználói oldalak modulonként
│  │  ├─ includes/              # header.php, footer.php, közös adatbetöltés
│  │  ├─ cronjobs/              # Időzített feladatok (pushing.php, ranking.php)
│  │  ├─ *.php                  # Oldalak: home.php, shop.php, clan.php stb.
│  │  └─ map_revolution.php     # Játék kliens betöltése
│  └─ packages/PHPMailer/       # Külső függőség e-mailhez
├─ dashboard/                   # Statikus dashboard nézetek (többnyelvű)
├─ js/                          # Kliensoldali JavaScript (pl. darkorbit)
├─ spacemap/                    # Térképhez tartozó SWF/XML/sablon/asset
├─ swf_global/, flashinput/, gamechat/ # Flash/AS3 erőforrások
├─ css/, img/, do_img/          # Stílusok és képek
├─ server.sql                   # Adatbázis-séma dump
└─ xampp/                       # Fejlesztői környezethez kapcsolódó fájlok
```

## Hol érdemes fejleszteni

- **Oldalbetöltés és routing:** Az `index.php` → `files/redirect.php` páros a `Functions::LoadPage` metódust hívja. Ez a függvény választja ki a `files/external/*.php` oldalakat, és automatikusan becsatolja a `includes/header.php`/`footer.php` fájlokat.
- **API műveletek:** A `files/api.php` POST paraméter alapján hívja a megfelelő `Functions::*` metódusokat. Új API végpontnál itt adj végződést, a logikát pedig a `files/classes/Functions.php`-ba tedd.
- **Alapbeállítások:** A `files/config.php` kezeli a domain, adatbázis, socket és session beállításokat, valamint itt töltődnek be a core osztályok.
- **Adatbázis:** A `server.sql` tartalmazza a séma alapját. Új táblák vagy mezők bevezetésekor ezt érdemes frissíteni.
- **Ütemezett feladatok:** A `files/external/cronjobs/` könyvtárban lévő skriptek (`pushing.php`, `ranking.php`) kapják az időzített futtatásokat.
- **Játék kliens és assetek:** A játékhoz kapcsolódó SWF/XML és grafikus erőforrások a `spacemap/`, `swf_global/`, `flashinput/` és `gamechat/` mappákban találhatók.
