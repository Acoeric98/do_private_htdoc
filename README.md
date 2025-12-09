# DarkOrbit CMS

Ez a repó a DarkOrbit témájú privát szerver webes felületét tartalmazza. A gyökérben lévő PHP alkalmazás kezeli a játékos-fiókokat, a karbantartási állapotot és a statikus erőforrásokat (CSS/JS/Flash), valamint tartalmazza a szükséges SQL sémát és cron feladatokat.

## Követelmények
- PHP 7.3 vagy újabb a beépített szerverrel vagy Apache/Nginx konfigurációval.
- MySQL/MariaDB a `server` adatbázissal (lásd `server.sql`).
- A dokumentumgyökér a repó gyökerére mutasson, hogy az `index.php` és a `files/` könyvtár elérhető legyen.

## Főbb mappák
- `files/config.php`: környezeti beállítások (adatbázis, domain, karbantartási mód) és a szükséges osztályok betöltése.
- `files/classes/`: alapvető PHP osztályok (pl. `Functions.php`, `Database.php`, `Socket.php`, `SMTP.php`).
- `files/external/`: külső segédletek, cron feladatok és include-ok a játékszerverhez.
- `files/api.php`: API belépési pont a játék kliensének.
- `server.sql`: teljes adatbázis-séma és kezdeti adatok.
- `css/`, `js/`, `img/`, `do_img/`, `spacemap/`, `flashAPI/`, `flashinput/`, `swf_global/`: a felület statikus erőforrásai (stílusok, kliensek, ikonok, SWF-ek).

## Telepítés
1. Hozz létre egy MySQL/MariaDB adatbázist `server` néven, majd importáld a `server.sql` fájlt.
2. Másold vagy klónozd a forrásokat a webszerver gyökerébe.
3. Szerkeszd a `files/config.php` fájlt: állítsd be a `MYSQL_*` konstansokat (host, felhasználó, jelszó, port) és a `DOMAIN` értéket, ha nem automatikusan áll be.
4. Engedélyezd a PHP munkamenetek írását a `files/sessions` könyvtárba (a fájl automatikusan létrejön, ha írható a könyvtár).
5. Fejlesztői környezetben indítsd a beépített PHP szervert: `php -S 0.0.0.0:8000 -t .`. Ezután a játékweb felület a `http://localhost:8000/` címen érhető el.
6. Használd a `MAINTENANCE` konstansot (lásd `files/config.php`) a karbantartási mód kapcsolásához.
7. Ha cron feladatokat futtatnál, nézd át a `files/external/cronjobs/` mappát, és időzítsd a szükséges scriptje(ke)t.

## Fejlesztési tippek
- Az alapértelmezett PHP hibanapló a `files/error_logs/php_error.log` fájlba íródik; fejlesztéskor célszerű figyelni ezt a naplót.
- Tartsd a biztonsági adatok (jelszavak, tanúsítványok) kezelését lokális környezeti változókkal vagy privát konfigurációval, ne commitold a titkokat.
- Új kód hozzáadásakor kövesd a meglévő kódstílust (4 szóközös behúzás, PSR-hez közeli elrendezés) és tartsd a fájlokat a megfelelő mappastruktúrában.
- A játék TCP socket szervere csatlakozáskor azonnal olvasni kezd, és csak akkor tartja nyitva a kapcsolatot, ha a kliens rögtön érvényes JSON-t küld `Action` és `Parameters` mezőkkel. Ha az `EndReceive` 0 bájtot ad vissza (vagy a poll szerint nincs adat), a szerver naplózza, hogy a távoli végpont bezárta a kapcsolatot, majd leállítja a socketet. Ha a kapcsolatot üres hasznos adatokkal is nyitva szeretnéd tartani, a játékszerverben (pl. `Net/SocketServer.cs` `ReadCallback` metódusában) módosítani kell, hogy a nulla hosszúságú olvasást ne kezelje kemény bezárásként.

## Hibakeresés
- **Folyamatos `Poll check failed for 127.0.0.1:xxxx` logok**: ez azt jelzi, hogy a socket szerver ugyan elfogadta a kapcsolatot, de a kliens nem küld érvényes JSON-t a kapcsolat elején, így a poll/olvasás 0 bájtot ad vissza, majd a szerver lecsatlakoztatja az adott végpontot. Ellenőrizd, hogy a játék kliens beállításai (host, port) helyesek, illetve hogy a kliens tényleg küld `Action` és `Parameters` mezőket tartalmazó csomagot azonnal a csatlakozás után. Ha szándékosan tétlen kapcsolatot tartanál fenn, módosítani kell a szerver oldali `Net/SocketServer.cs` logikát, hogy a poll hibákat ne kezelje azonnali bontásként.
