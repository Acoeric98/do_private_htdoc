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
                $boosterPrice = 10000;
                $boosterDuration = 36000;
                $availableBoosters = Functions::GetAvailableBoosters();
              ?>

              <div class="card white-text grey darken-4 padding-15">
                <div class="ships-hero">
                  <div>
                    <p class="eyebrow">Új hajók és boosterek</p>
                    <h4 class="no-margin">SHIPS &amp; BOOSTERS</h4>
                    <p class="ships-subtitle">Vásárolj új hajókat vagy boostereket 10.000 Uridiumért. A boosterek 10 órán át (<?php echo number_format($boosterDuration); ?> mp) aktívak.</p>
                  </div>
                  <div class="ships-price-tag">
                    <span class="ships-price">10.000</span>
                    <span class="ships-price__currency">Uridium</span>
                  </div>
                </div>

                <ul class="tabs grey darken-3 tabs-fixed-width">
                  <li class="tab"><a class="active" href="#ships-tab">Hajók</a></li>
                  <li class="tab"><a href="#boosters-tab">Boosterek</a></li>
                </ul>

                <div id="ships-tab" class="tab-content">
                  <div class="row ships-offers">
                    <?php
                      foreach ($shipsForSale as $ship) {
                        if (in_array($ship['shipID'], $ownedShips)) {
                          continue;
                        }

                        $lootId = str_replace('_', '/', $ship['lootID']);
                        $lootId = Functions::ApplyCompanyShipVariant($lootId, $player['factionId']);
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
                          <p>Jelenleg nincs megvásárolható hajó.</p>
                        </div>
                      </div>
                    <?php } else { ?>
                      <div id="no-ship-info" class="col s12" style="display: none;">
                        <div class="card grey darken-3 center padding-15">
                          <span class="card-title">Minden hajót beszereztél</span>
                          <p>Jelenleg nincs megvásárolható hajó.</p>
                        </div>
                      </div>
                    <?php } ?>
                  </div>
                </div>

                <div id="boosters-tab" class="tab-content" style="display: none;">
                  <div class="row ships-offers">
                    <?php foreach ($availableBoosters as $boosterType => $boosterData) { ?>
                      <div class="col s12 m6 l4 booster-card">
                        <div class="card grey darken-3">
                          <div class="card-content ship-card__content booster-card__content">
                            <?php
                              $boosterImage = strtolower(str_replace('_', '-', $boosterData['name']));
                              $boosterImagePath = DOMAIN.'do_img/global/booster/booster_'.$boosterImage.'_100x100.png';
                            ?>
                            <div class="ship-card__image booster-card__image">
                              <div class="ship-card__glow"></div>
                              <img src="<?php echo $boosterImagePath; ?>" alt="<?php echo str_replace('_', '-', $boosterData['name']); ?>">
                            </div>
                            <span class="card-title"><?php echo str_replace('_', '-', $boosterData['name']); ?></span>
                            <p class="ship-card__price"><?php echo number_format($boosterPrice, 0, '.', '.'); ?> Uridium</p>
                            <p class="grey-text text-lighten-1">Időtartam: 10 óra (<?php echo number_format($boosterDuration); ?> mp)</p>
                          </div>
                          <div class="card-action">
                            <button class="btn grey darken-2 waves-effect waves-light buy-booster" data-booster-type="<?php echo $boosterType; ?>">Booster vásárlása</button>
                          </div>
                        </div>
                      </div>
                    <?php } ?>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
