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
MAP\tPOS\tOWNER
3-4\t45/90\tSzabad
3-3\t105/25\t[EIC]
3-5\t110/90\t[VRU]
3-6\t95/80\t[VRU]
3-7\t105/45\t[VRU]
1-3\t106/24\t[MMO]
1-4\t44/90\tSzabad
1-5\t170/25\t[MMO]
1-6\t100/60\t[MMO]
1-7\t100/72\tSzabad
2-3\t105/25\t[EIC]
2-4\t160/85\tSzabad
2-5\t105/90\t[EIC]
2-6\t85/65\t[EIC]
2-7\t105/55\t[EIC]
4-2\t115/60\tSzabad
4-1\t100/55\tSzabad
4-3\t88/60\tSzabad
4-4\t90/55\tSzabad
4-5\t120/55\tSzabad
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
      A CBS opcionális (külön fájl): narancs <b>CBS</b> jelölők jelennek meg a térképen. Formátum: <code>MAP POS [TULAJ]</code>, ha nincs tulaj megadva, "Szabad" jelenik meg.
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
(function () {
  var SERVER_PORTAL_TEXT = <?php echo json_encode($portalText); ?>;
  var SERVER_CBS_TEXT = <?php echo json_encode($cbsText); ?>;
  var PORTAL_URL = <?php echo json_encode($portalUrl); ?>;
  var CBS_URL = <?php echo json_encode($cbsUrl); ?>;
  var SAMPLE_PORTALS = <?php echo json_encode($samplePortals); ?>;
  var SAMPLE_CBS = <?php echo json_encode($sampleCbs); ?>;

  // ===== Config =====
  var DEFAULT_MAP = { w: 210, h: 130 };
  var SPECIAL_SIZES = {
    "4-4": { w: 418, h: 260 },
    "4-5": { w: 418, h: 260 }
  };
  var PVP_ORANGE = { "4-1": true, "4-2": true, "4-3": true, "4-4": true, "4-5": true };
  function getMapSize(name) { return SPECIAL_SIZES[name] || DEFAULT_MAP; }

  // Galaxy placement columns (left->right)
  var COL_X = { 3: 0.18, 4: 0.50, 2: 0.82, 1: 0.30, 5: 0.52, 0: 0.50 };

  // ===== Elements =====
  var svg = document.getElementById("svg");
  var view = document.getElementById("view");
  var stat = document.getElementById("stat");

  var relayoutBtn = document.getElementById("relayoutBtn");
  var resetViewBtn = document.getElementById("resetViewBtn");

  var modal = document.getElementById("modal");
  var closeModalBtn = document.getElementById("closeModal");
  var modalTitle = document.getElementById("modalTitle");
  var mapWrap = document.getElementById("mapWrap");
  var portalList = document.getElementById("portalList");
  var mapSizeTag = document.getElementById("mapSizeTag");
  var portalCountTag = document.getElementById("portalCountTag");
  var cbsTag = document.getElementById("cbsTag");

  // ===== Helpers =====
  var NS = "http://www.w3.org/2000/svg";
  function clear(el) { while (el.firstChild) { el.removeChild(el.firstChild); } }
  function clamp(n, a, b) { return Math.max(a, Math.min(b, n)); }

  function normalizeLine(line) {
    return line.replace(/^\s+|\s+$/g, "").replace(/\u00A0/g, " ");
  }

  function parsePos(posStr) {
    if (!posStr) return null;
    var m = String(posStr).replace(/^\s+|\s+$/g, "").match(/^(\d+)\s*\/\s*(\d+)$/);
    if (!m) return null;
    var x = Number(m[1]), y = Number(m[2]);
    if (!isFinite(x) || !isFinite(y)) return null;
    return { x: x, y: y };
  }

  function groupOf(id) {
    var m = id.match(/^(\d+)\-/);
    return m ? Number(m[1]) : 0;
  }
  function secondOf(id) {
    var m = id.match(/^\d+\-(\d+)$/);
    return m ? Number(m[1]) : 0;
  }
  function colorClass(id) {
    var g = groupOf(id);
    if (PVP_ORANGE[id]) return "g4";
    if (g === 1) return "g1";
    if (g === 2) return "g2";
    if (g === 3) return "g3";
    if (g === 4) return "g4";
    if (g === 5) return "g5";
    return "g2";
  }

  function hexPoints(cx, cy, r) {
    var pts = [];
    for (var i = 0; i < 6; i++) {
      var a = (Math.PI / 180) * (60 * i); // flat-top
      pts.push([cx + r * Math.cos(a), cy + r * Math.sin(a)]);
    }
    var pieces = [];
    for (var j = 0; j < pts.length; j++) {
      pieces.push(pts[j][0].toFixed(2) + "," + pts[j][1].toFixed(2));
    }
    return pieces.join(" ");
  }

  // ===== Parse portal rows (FROM pos TO pos) =====
  function parsePortalRows(text) {
    var lines = text.split(/\r?\n/);
    var cleaned = [];
    for (var i = 0; i < lines.length; i++) {
      var ln = normalizeLine(lines[i]);
      if (ln) cleaned.push(ln);
    }
    var headerish = cleaned[0] && cleaned[0].toLowerCase().indexOf("from") !== -1 && cleaned[0].toLowerCase().indexOf("to") !== -1;
    var dataLines = headerish ? cleaned.slice(1) : cleaned;

    var rows = [];
    for (var k = 0; k < dataLines.length; k++) {
      var line = dataLines[k];
      var parts = line.split("\t");
      for (var p = parts.length - 1; p >= 0; p--) { parts[p] = parts[p].replace(/^\s+|\s+$/g, ""); }
      parts = parts.filter(function (s) { return !!s; });
      if (parts.length < 4) {
        parts = line.split(/\s+/);
        for (p = parts.length - 1; p >= 0; p--) { parts[p] = parts[p].replace(/^\s+|\s+$/g, ""); }
        parts = parts.filter(function (s) { return !!s; });
      }
      if (parts.length < 4) continue;

      rows.push({
        from: parts[0],
        fromPosRaw: parts[1],
        to: parts[2],
        toPosRaw: parts[3]
      });
    }
    return rows;
  }

  // ===== Parse CBS file (MAP POS [OWNER]) =====
  // Supports format with header: MAP POS [OWNER]
  function parseCbs(text) {
    var lines = text.split(/\r?\n/);
    var cleaned = [];
    for (var i = 0; i < lines.length; i++) {
      var ln = normalizeLine(lines[i]);
      if (ln) cleaned.push(ln);
    }

    var start = 0;
    if (cleaned[0] && cleaned[0].toLowerCase().indexOf("map") !== -1 && cleaned[0].toLowerCase().indexOf("pos") !== -1) {
      start = 1;
    }

    var out = {};
    for (var idx = start; idx < cleaned.length; idx++) {
      var line = cleaned[idx];
      var parts = line.split("\t");
      for (var p = parts.length - 1; p >= 0; p--) { parts[p] = parts[p].replace(/^\s+|\s+$/g, ""); }
      parts = parts.filter(function (s) { return !!s; });
      if (parts.length < 2) {
        parts = line.split(/\s+/);
        for (p = parts.length - 1; p >= 0; p--) { parts[p] = parts[p].replace(/^\s+|\s+$/g, ""); }
        parts = parts.filter(function (s) { return !!s; });
      }
      if (parts.length < 2) continue;

      var map = parts[0];
      var pos = parsePos(parts[1]);
      var ownerParts = parts.slice(2);
      var ownerText = ownerParts.length ? ownerParts.join(" ") : "";
      var owner = (ownerText && ownerText.replace(/^\s+|\s+$/g, "")) || "Szabad";
      if (!map || !pos) continue;

      if (!out[map]) out[map] = [];
      out[map].push({ x: pos.x, y: pos.y, owner: owner });
    }
    return out;
  }

  // ===== Graph build =====
  function buildGraph(rows) {
    var nodesById = {};
    var nodes = [];
    var edgeSet = {};
    var edges = [];

    function ensure(name) {
      if (!name || name === "LOW") return null;
      if (!nodesById[name]) {
        var isBig = (name === "4-4" || name === "4-5");
        nodesById[name] = { id: name, x: 0, y: 0, vx: 0, vy: 0, r: isBig ? 34 : 26, tx: 0, ty: 0 };
        nodes.push(nodesById[name]);
      }
      return nodesById[name];
    }

    for (var i = 0; i < rows.length; i++) {
      var r = rows[i];
      var a = ensure(r.from);
      var b = ensure(r.to);
      if (!a || !b) continue;
      var key = a.id < b.id ? a.id + "__" + b.id : b.id + "__" + a.id;
      if (!edgeSet[key]) {
        edgeSet[key] = true;
        edges.push({ source: a.id, target: b.id });
      }
    }

    var adj = {};
    for (var id in nodesById) {
      if (nodesById.hasOwnProperty(id)) adj[id] = [];
    }
    for (var e = 0; e < edges.length; e++) {
      var src = edges[e].source;
      var tgt = edges[e].target;
      if (adj[src].indexOf(tgt) === -1) adj[src].push(tgt);
      if (adj[tgt].indexOf(src) === -1) adj[tgt].push(src);
    }

    return { nodes: nodes, edges: edges, adj: adj };
  }

  // ===== Ordered targets =====
  function assignOrderedTargets(nodes) {
    var w = svg.clientWidth;
    var h = svg.clientHeight;

    var byG = {};
    for (var i = 0; i < nodes.length; i++) {
      var node = nodes[i];
      var g = groupOf(node.id);
      if (!byG[g]) byG[g] = [];
      byG[g].push(node);
    }
    for (var gKey in byG) {
      if (!byG.hasOwnProperty(gKey)) continue;
      byG[gKey].sort(function (a, b) {
        var diff = secondOf(a.id) - secondOf(b.id);
        if (diff !== 0) return diff;
        return a.id.localeCompare(b.id);
      });
    }

    var spans = {
      3: { y0: h * 0.12, y1: h * 0.48 },
      2: { y0: h * 0.20, y1: h * 0.50 },
      1: { y0: h * 0.62, y1: h * 0.92 },
      4: { y0: h * 0.26, y1: h * 0.78 },
      5: { y0: h * 0.12, y1: h * 0.42 },
      0: { y0: h * 0.30, y1: h * 0.70 }
    };

    for (gKey in byG) {
      if (!byG.hasOwnProperty(gKey)) continue;
      var list = byG[gKey];
      var colVal = (COL_X[gKey] !== undefined && COL_X[gKey] !== null) ? COL_X[gKey] : COL_X[0];
      var span = (spans[gKey] !== undefined && spans[gKey] !== null) ? spans[gKey] : spans[0];
      var colX = colVal * w;
      var count = Math.max(1, list.length);

      for (i = 0; i < list.length; i++) {
        var t = (count === 1) ? 0.5 : (i / (count - 1));
        var ty = span.y0 + (span.y1 - span.y0) * t;

        if (list[i].id === "4-4") ty = h * 0.72;
        if (list[i].id === "4-5") ty = h * 0.30;

        list[i].tx = colX;
        list[i].ty = ty;
      }
    }

    for (i = 0; i < nodes.length; i++) {
      nodes[i].x = nodes[i].tx + (Math.random() - 0.5) * 30;
      nodes[i].y = nodes[i].ty + (Math.random() - 0.5) * 30;
      nodes[i].vx = 0;
      nodes[i].vy = 0;
    }
  }

  function runForce(graph, steps) {
    var nodes = graph.nodes;
    var edges = graph.edges;
    var totalSteps = (typeof steps === "number") ? steps : 650;

    var REPULSE = 5200;
    var SPRING = 0.010;
    var SPRING_LEN = 160;
    var DAMP = 0.86;
    var ANCHOR = 0.020;

    var byId = {};
    for (var i = 0; i < nodes.length; i++) {
      byId[nodes[i].id] = nodes[i];
    }

    for (var iter = 0; iter < totalSteps; iter++) {
      for (var aIdx = 0; aIdx < nodes.length; aIdx++) {
        for (var bIdx = aIdx + 1; bIdx < nodes.length; bIdx++) {
          var a = nodes[aIdx], b = nodes[bIdx];
          var dx = a.x - b.x;
          var dy = a.y - b.y;
          var d2 = dx * dx + dy * dy + 0.01;

          var minD = (a.r + b.r) * 1.20;
          if (d2 < minD * minD) d2 = minD * minD;

          var f = REPULSE / d2;
          var invD = 1 / Math.sqrt(d2);
          var fx = dx * invD * f;
          var fy = dy * invD * f;

          a.vx += fx; a.vy += fy;
          b.vx -= fx; b.vy -= fy;
        }
      }

      for (var eIdx = 0; eIdx < edges.length; eIdx++) {
        var edge = edges[eIdx];
        var aNode = byId[edge.source];
        var bNode = byId[edge.target];
        if (!aNode || !bNode) continue;

        var dx2 = bNode.x - aNode.x;
        var dy2 = bNode.y - aNode.y;
        var dist = Math.sqrt(dx2 * dx2 + dy2 * dy2) + 0.01;
        var diff = dist - SPRING_LEN;

        var f2 = diff * SPRING;
        var fx2 = (dx2 / dist) * f2;
        var fy2 = (dy2 / dist) * f2;

        aNode.vx += fx2; aNode.vy += fy2;
        bNode.vx -= fx2; bNode.vy -= fy2;
      }

      for (var nIdx = 0; nIdx < nodes.length; nIdx++) {
        var n = nodes[nIdx];
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
  var currentPortalRows = [];
  var currentGraph = null;
  var selectedId = null;
  var cbsByMap = {}; // optional

  // ===== Render galaxy =====
  function drawGalaxy(graph) {
    clear(view);

    var byId = {};
    for (var i = 0; i < graph.nodes.length; i++) {
      byId[graph.nodes[i].id] = graph.nodes[i];
    }

    var gEdges = document.createElementNS(NS, "g");
    var gNodes = document.createElementNS(NS, "g");
    view.appendChild(gEdges);
    view.appendChild(gNodes);

    var edgeEls = [];
    for (i = 0; i < graph.edges.length; i++) {
      var e = graph.edges[i];
      var a = byId[e.source];
      var b = byId[e.target];
      if (!a || !b) continue;

      var line = document.createElementNS(NS, "line");
      line.setAttribute("x1", a.x);
      line.setAttribute("y1", a.y);
      line.setAttribute("x2", b.x);
      line.setAttribute("y2", b.y);
      line.setAttribute("class", "edge");
      gEdges.appendChild(line);
      edgeEls.push({ el: line, s: e.source, t: e.target });
    }

    var nodeEls = [];
    for (i = 0; i < graph.nodes.length; i++) {
      var n = graph.nodes[i];
      var group = document.createElementNS(NS, "g");
      group.style.cursor = "pointer";

      var poly = document.createElementNS(NS, "polygon");
      var baseClass = colorClass(n.id);
      poly.setAttribute("points", hexPoints(n.x, n.y, n.r));
      poly.setAttribute("class", "hex " + baseClass);
      group.appendChild(poly);

      var text = document.createElementNS(NS, "text");
      text.textContent = n.id;
      text.setAttribute("x", n.x);
      text.setAttribute("y", n.y + 1);
      text.setAttribute("class", "label");
      group.appendChild(text);

      (function (id) {
        group.addEventListener("click", function (ev) {
          ev.stopPropagation();
          selectNode(id, graph, nodeEls, edgeEls);
          openMapModal(id);
        });
      })(n.id);

      gNodes.appendChild(group);
      nodeEls.push({ id: n.id, poly: poly, text: text, baseClass: baseClass });
    }

    // background click to clear highlight
    var bgHandler = function () {
      selectedId = null;
      applyHighlight(graph, nodeEls, edgeEls);
      svg.removeEventListener("click", bgHandler);
    };
    svg.addEventListener("click", bgHandler);

    applyHighlight(graph, nodeEls, edgeEls);
  }

  function selectNode(id, graph, nodeEls, edgeEls) {
    selectedId = (selectedId === id) ? null : id;
    applyHighlight(graph, nodeEls, edgeEls);
  }

  function applyHighlight(graph, nodeEls, edgeEls) {
    var i;
    if (!selectedId) {
      for (i = 0; i < nodeEls.length; i++) {
        var ne = nodeEls[i];
        ne.poly.setAttribute("class", "hex " + ne.baseClass);
        ne.text.setAttribute("class", "label");
      }
      for (i = 0; i < edgeEls.length; i++) { edgeEls[i].el.setAttribute("class", "edge"); }
      return;
    }

    var neighbors = {};
    var adjList = graph.adj[selectedId] || [];
    neighbors[selectedId] = true;
    for (i = 0; i < adjList.length; i++) { neighbors[adjList[i]] = true; }

    for (i = 0; i < nodeEls.length; i++) {
      var nodeEl = nodeEls[i];
      var hot = !!neighbors[nodeEl.id];
      nodeEl.poly.setAttribute("class", hot ? "hex hot " + nodeEl.baseClass : "hex dim " + nodeEl.baseClass);
      nodeEl.text.setAttribute("class", hot ? "label" : "label dim");
    }
    for (i = 0; i < edgeEls.length; i++) {
      var ee = edgeEls[i];
      var hotEdge = (ee.s === selectedId && neighbors[ee.t]) || (ee.t === selectedId && neighbors[ee.s]);
      ee.el.setAttribute("class", hotEdge ? "edge hot" : "edge dim");
    }
  }

  // ===== Pan/Zoom =====
  var viewX = 0, viewY = 0, viewS = 1;
  function setTransform() { view.setAttribute("transform", "translate(" + viewX + "," + viewY + ") scale(" + viewS + ")"); }
  function resetView() { viewX = 0; viewY = 0; viewS = 1; setTransform(); }

  var dragging = false;
  var last = null;

  svg.addEventListener("mousedown", function (e) {
    dragging = true;
    last = { x: e.clientX, y: e.clientY };
  });
  window.addEventListener("mouseup", function () { dragging = false; last = null; });
  window.addEventListener("mousemove", function (e) {
    if (!dragging || !last) return;
    var dx = e.clientX - last.x;
    var dy = e.clientY - last.y;
    last = { x: e.clientX, y: e.clientY };
    viewX += dx;
    viewY += dy;
    setTransform();
  });

  svg.addEventListener("wheel", function (e) {
    e.preventDefault();
    var delta = -e.deltaY;
    var factor = delta > 0 ? 1.08 : 1 / 1.08;

    var rect = svg.getBoundingClientRect();
    var mx = e.clientX - rect.left;
    var my = e.clientY - rect.top;

    var prevS = viewS;
    viewS = Math.max(0.25, Math.min(3.5, viewS * factor));
    var k = viewS / prevS;

    viewX = mx - (mx - viewX) * k;
    viewY = my - (my - viewY) * k;

    setTransform();
  }, false);

  // ===== Modal map view =====
  function openMapModal(mapName) {
    var size = getMapSize(mapName);
    modalTitle.textContent = "Térkép " + mapName + " • portál + CBS pozíciók";
    mapSizeTag.textContent = size.w + "×" + size.h;

    var portalsRaw = [];
    for (var i = 0; i < currentPortalRows.length; i++) {
      var row = currentPortalRows[i];
      if (row.from === mapName) {
        portalsRaw.push({
          from: row.from,
          pos: parsePos(row.fromPosRaw),
          posRaw: row.fromPosRaw,
          to: row.to,
          toPosRaw: row.toPosRaw
        });
      }
    }

    var portals = [];
    for (var pIdx = 0; pIdx < portalsRaw.length; pIdx++) {
      if (portalsRaw[pIdx].pos) portals.push(portalsRaw[pIdx]);
    }

    var cbsList = cbsByMap[mapName] || [];
    cbsTag.textContent = "CBS: " + cbsList.length;
    portalCountTag.textContent = "Portálok: " + portals.length;

    clear(mapWrap);
    var mapSvg = document.createElementNS(NS, "svg");
    if (mapSvg.classList && mapSvg.classList.add) mapSvg.classList.add("mapsvg");
    mapSvg.setAttribute("viewBox", "0 0 " + size.w + " " + size.h);
    mapSvg.setAttribute("preserveAspectRatio", "xMidYMid meet");

    var step = (size.w >= 400 || size.h >= 260) ? 20 : 10;
    for (var x = step; x < size.w; x += step) {
      var l = document.createElementNS(NS, "line");
      l.setAttribute("x1", x); l.setAttribute("y1", 0);
      l.setAttribute("x2", x); l.setAttribute("y2", size.h);
      l.setAttribute("class", "gridline");
      mapSvg.appendChild(l);
    }
    for (var y = step; y < size.h; y += step) {
      var l2 = document.createElementNS(NS, "line");
      l2.setAttribute("x1", 0); l2.setAttribute("y1", y);
      l2.setAttribute("x2", size.w); l2.setAttribute("y2", y);
      l2.setAttribute("class", "gridline");
      mapSvg.appendChild(l2);
    }

    var frame = document.createElementNS(NS, "rect");
    frame.setAttribute("x", "0");
    frame.setAttribute("y", "0");
    frame.setAttribute("width", String(size.w));
    frame.setAttribute("height", String(size.h));
    frame.setAttribute("class", "mapframe");
    mapSvg.appendChild(frame);

    for (var p = 0; p < portals.length; p++) {
      var portal = portals[p];
      var px = clamp(portal.pos.x, 0, size.w);
      var py = clamp(portal.pos.y, 0, size.h);

      var dot = document.createElementNS(NS, "circle");
      dot.setAttribute("cx", String(px));
      dot.setAttribute("cy", String(py));
      dot.setAttribute("r", String(Math.max(3.8, Math.min(size.w, size.h) * 0.012)));
      dot.setAttribute("class", "portalDot");
      mapSvg.appendChild(dot);

      var label = document.createElementNS(NS, "text");
      label.setAttribute("x", String(px + 7));
      label.setAttribute("y", String(py + 4));
      label.setAttribute("class", "portalLabel");
      var dest = portal.to ? String(portal.to).replace(/^\s+|\s+$/g, "") : "?";
      label.textContent = dest || "?";
      mapSvg.appendChild(label);
    }

    for (var c = 0; c < cbsList.length; c++) {
      var cbs = cbsList[c];
      var cx = clamp(cbs.x, 0, size.w);
      var cy = clamp(cbs.y, 0, size.h);

      var cDot = document.createElementNS(NS, "circle");
      cDot.setAttribute("cx", String(cx));
      cDot.setAttribute("cy", String(cy));
      cDot.setAttribute("r", String(Math.max(4.2, Math.min(size.w, size.h) * 0.014)));
      cDot.setAttribute("class", "cbsDot");
      mapSvg.appendChild(cDot);

      var cLabel = document.createElementNS(NS, "text");
      cLabel.setAttribute("x", String(cx + 7));
      cLabel.setAttribute("y", String(cy - 6));
      cLabel.setAttribute("class", "cbsLabel");
      cLabel.textContent = "CBS";
      mapSvg.appendChild(cLabel);

      var cOwner = document.createElementNS(NS, "text");
      cOwner.setAttribute("x", String(cx + 7));
      cOwner.setAttribute("y", String(cy + 9));
      cOwner.setAttribute("class", "cbsOwnerLabel");
      cOwner.textContent = cbs.owner || "Szabad";
      mapSvg.appendChild(cOwner);
    }

    mapWrap.appendChild(mapSvg);

    portalList.innerHTML = "";
    if (portals.length === 0) {
      var empty = document.createElement("div");
      empty.className = "item";
      empty.innerHTML = "<b>Nincs portál</b><div style=\"margin-top:6px;\">Ehhez a térképhez nem találtunk érvényes FROM pozíciókat.</div>";
      portalList.appendChild(empty);
    } else {
      for (p = 0; p < portals.length; p++) {
        var entry = portals[p];
        var div = document.createElement("div");
        div.className = "item";
        div.innerHTML =
          "<b>" + entry.from + "</b> <span class=\"pill\">" + entry.posRaw + "</span>" +
          "<div style=\"margin-top:6px;color:rgba(233,251,255,.86)\">" +
          "→ <b>" + entry.to + "</b> <span class=\"pill\">" + (entry.toPosRaw || "?") + "</span>" +
          "</div>";
        portalList.appendChild(div);
      }
    }

    if (modal.classList && modal.classList.add) {
      modal.classList.add("open");
    } else {
      modal.className += " open";
    }
  }

  function closeMapModal() {
    if (modal.classList && modal.classList.remove) {
      modal.classList.remove("open");
    } else {
      modal.className = modal.className.replace(/\s*open\b/, "");
    }
    clear(mapWrap);
    portalList.innerHTML = "";
  }

  closeModalBtn.addEventListener("click", closeMapModal);
  modal.addEventListener("click", function (e) { if (e.target === modal) closeMapModal(); });

  window.addEventListener("keydown", function (e) {
    var key = e.key || e.keyCode;
    if (key === "Escape" || key === "Esc" || key === 27) {
      if (modal.classList && modal.classList.contains && modal.classList.contains("open")) closeMapModal();
      selectedId = null;
    }
  });

  // ===== Load functions =====
  function rebuildGalaxy() {
    var graph = buildGraph(currentPortalRows);
    assignOrderedTargets(graph.nodes);
    runForce(graph, 650);
    currentGraph = graph;

    stat.textContent = "csomópontok: " + graph.nodes.length + " • élek: " + graph.edges.length;
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

  function fetchText(url, fallback, done) {
    if (!url) { done(fallback); return; }
    var xhr = new XMLHttpRequest();
    xhr.open("GET", url, true);
    try { xhr.setRequestHeader("Cache-Control", "no-cache"); } catch (e) { /* ignore */ }
    xhr.onreadystatechange = function () {
      if (xhr.readyState !== 4) return;
      if (xhr.status >= 200 && xhr.status < 300) {
        var t = xhr.responseText;
        if (t && t.replace(/\s/g, "").length) {
          done(t);
        } else {
          done(fallback);
        }
      } else {
        done(fallback);
      }
    };
    xhr.onerror = function () { done(fallback); };
    try { xhr.send(); } catch (err) { done(fallback); }
  }

  function loadFromServer() {
    var portalFallback = SERVER_PORTAL_TEXT || SAMPLE_PORTALS;
    var cbsFallback = SERVER_CBS_TEXT || SAMPLE_CBS;
    fetchText(PORTAL_URL, portalFallback, function (portalText) {
      loadPortalText(portalText);
      fetchText(CBS_URL, cbsFallback, function (cbsText) {
        if (cbsText && cbsText.replace(/\s/g, "").length) {
          loadCbsText(cbsText);
        } else {
          cbsByMap = {};
        }
      });
    });
  }

  relayoutBtn.addEventListener("click", function () {
    if (!currentGraph) return;
    assignOrderedTargets(currentGraph.nodes);
    runForce(currentGraph, 650);
    drawGalaxy(currentGraph);
  });

  resetViewBtn.addEventListener("click", resetView);

  loadFromServer();
})();
</script>
