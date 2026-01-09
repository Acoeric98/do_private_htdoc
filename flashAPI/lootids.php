<?php
require_once('../files/config.php');

header('Content-Type: application/json; charset=utf-8');

if (!Functions::IsLoggedIn()) {
  http_response_code(401);
  echo json_encode([
    'error' => 'not_logged_in'
  ]);
  exit;
}

$mysqli = Database::GetInstance();

$lootIds = [];
$result = $mysqli->query('SELECT lootID FROM server_ships WHERE respawnable = 0 AND (lootID LIKE "ship_%" OR lootID = "pet")');
if ($result) {
  $rows = $result->fetch_all(MYSQLI_ASSOC);
  foreach ($rows as $row) {
    if (isset($row['lootID'])) {
      $lootIds[] = $row['lootID'];
    }
  }
}

echo json_encode([
  'count' => count($lootIds),
  'lootIds' => $lootIds,
  'generatedAt' => date('c')
]);
