      <div id="main">
        <div class="container">
          <div class="row">
            <div class="col s12">
              <?php
                $equipment = $mysqli->query('SELECT items FROM player_equipment WHERE userId = '.$player['userId'].'')->fetch_assoc();
                $items = $equipment ? json_decode($equipment['items']) : null;

                if (!$items) {
                  $items = new stdClass();
                }

                $ownedShips = [];
                if ($items && isset($items->ships) && is_array($items->ships)) {
                  $ownedShips = array_map('intval', $items->ships);
                }

                $shipIdsForSale = [1, 2, 3, 4, 5, 6, 7, 9, 49, 69, 70, 156];
                $shipsForSale = [];

                $shipIdList = implode(',', $shipIdsForSale);
                $result = $mysqli->query('SELECT shipID, lootID, name FROM server_ships WHERE shipID IN ('.$shipIdList.')');

                if ($result) {
                  while ($row = $result->fetch_assoc()) {
                    $row['shipID'] = (int)$row['shipID'];
                    $shipsForSale[] = $row;
                  }
                }

                usort($shipsForSale, function($a, $b) use ($shipIdsForSale) {
                  $positionA = array_search($a['shipID'], $shipIdsForSale);
                  $positionB = array_search($b['shipID'], $shipIdsForSale);
                  return $positionA - $positionB;
                });

                $price = 10000;
              ?>

              <div class="card white-text grey darken-4 padding-15">
                <div class="ships-hero">
                  <div>
                    <p class="eyebrow">Új hajók a flottádhoz</p>
                    <h4 class="no-margin">SHIPS &amp; BOOSTERS</h4>
                    <p class="ships-subtitle">Vásárolj új hajókat 10.000 Uridiumért. Csak azok jelennek meg, amelyek még nincsenek a tulajdonodban.</p>
                  </div>
                  <div class="ships-price-tag">
                    <span class="ships-price">10.000</span>
                    <span class="ships-price__currency">Uridium</span>
                  </div>
                </div>

                <div class="row ships-offers">
                  <?php
                    foreach ($shipsForSale as $ship) {
                      if (in_array($ship['shipID'], $ownedShips)) {
                        continue;
                      }

                      $lootId = str_replace('_', '/', $ship['lootID']);
                  ?>
                  <div id="ship-card-<?php echo $ship['shipID']; ?>" class="col s12 m6 l4 ship-card">
                    <div class="card grey darken-3">
                      <div class="card-content ship-card__content">
                        <div class="ship-card__image">
                          <div class="ship-card__glow"></div>
                          <img src="<?php echo DOMAIN; ?>do_img/global/items/<?php echo $lootId; ?>_top.png" alt="<?php echo $ship['name']; ?>">
                        </div>
                        <span class="card-title"><?php echo $ship['name']; ?></span>
                        <p class="ship-card__price"><?php echo number_format($price, 0, '.', '.'); ?> Uridium</p>
                      </div>
                      <div class="card-action">
                        <button class="btn grey darken-2 waves-effect waves-light buy-ship" data-ship-id="<?php echo $ship['shipID']; ?>">Megvásárlás</button>
                      </div>
                    </div>
                  </div>
                  <?php } ?>

                  <?php if (count(array_diff($shipIdsForSale, $ownedShips)) === 0) { ?>
                    <div class="col s12">
                      <div id="no-ship-info" class="card grey darken-3 center padding-15">
                        <span class="card-title">Minden hajót beszereztél</span>
                        <p>Jelenleg nincs megvásárolható hajó. Hamarosan érkeznek a boosterek!</p>
                      </div>
                    </div>
                  <?php } else { ?>
                    <div id="no-ship-info" class="col s12" style="display: none;">
                      <div class="card grey darken-3 center padding-15">
                        <span class="card-title">Minden hajót beszereztél</span>
                        <p>Jelenleg nincs megvásárolható hajó. Hamarosan érkeznek a boosterek!</p>
                      </div>
                    </div>
                  <?php } ?>
                </div>

                <div class="ships-footer grey darken-3">
                  <p class="ships-footer__title">Boosterek hamarosan</p>
                  <p class="ships-footer__subtitle">A booster kínálat feltöltés alatt, addig is válogass a hajók közül!</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
