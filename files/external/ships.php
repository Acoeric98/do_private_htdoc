      <div id="main">
        <div class="container">
          <div class="row">
            <div class="col s12">
              <div class="card white-text grey darken-4 padding-15">
                <div class="ships">
                  <?php
                  $equipment = $mysqli->query('SELECT * FROM player_equipment WHERE userId = '.$player['userId'].'')->fetch_assoc();
                  $ships = json_decode($equipment['items'])->ships;
                  array_push($ships, 8);
                  array_push($ships, 10);
                  $companyCode = Functions::GetFactionCode($player['factionId']);

                  foreach ($ships as $shipId) {
                    $ship = $mysqli->query('SELECT * FROM server_ships WHERE shipID = '.$shipId.'')->fetch_assoc();
                    $currentShip = $mysqli->query('SELECT * FROM server_ships WHERE shipID = '.$player['shipId'].'')->fetch_assoc();
                    $lootId = $currentShip['baseShipId'] != $shipId ? $ship['lootID'] : ($player['shipId'] == 153 ? 'ship_goliath_design_razer' : $currentShip['lootID']);
                    $lootId = Functions::ApplyCompanyShipVariant($lootId, $player['factionId']);
                    $lootId = str_replace('_', '/', $lootId);
                  ?>
                  <div id="<?php echo $ship['lootID']; ?>" class="ship<?php echo $currentShip['baseShipId'] == $shipId ? ' active' : ''; ?><?php echo $companyCode ? ' ship--'.$companyCode : ''; ?>">
                    <div class="ship__image" aria-hidden="true">
                      <span class="ship__image-glow"></span>
                      <img src="<?php echo DOMAIN; ?>do_img/global/items/<?php echo $lootId; ?>_top.png" alt="<?php echo $ship['name']; ?>">
                    </div>
                    <div class="ship__meta">
                      <span class="ship__name"><?php echo $ship['name']; ?></span>
                      <?php if ($companyCode) { ?>
                        <span class="ship__company">Company: <?php echo strtoupper($companyCode); ?></span>
                      <?php } ?>
                    </div>
                  </div>
                  <?php } ?>
                </div>

              </div>
           </div>
          </div>
        </div>
      </div>
