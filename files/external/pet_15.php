<?php
    $equipment = $mysqli->query('SELECT items FROM player_equipment WHERE userId = '.$player['userId'].'')->fetch_assoc();
    $items = $equipment ? json_decode($equipment['items']) : null;

    $petOwned = $items && isset($items->pet) ? (bool)$items->pet : false;
    $petName = htmlspecialchars($player['petName']);
    $accountData = json_decode($player['data']);
?>

      <div id="main">
        <div class="container">
          <div class="row">
            <div class="col s12">
              <div class="card white-text grey darken-4 padding-15 center-align">
                <h4>P.E.T 15</h4>

                <?php if ($petOwned) { ?>
                  <p class="flow-text">Már rendelkezel egy P.E.T-tel.</p>

                  <div class="row">
                    <div class="col s12 m6 offset-m3">
                      <div class="card grey darken-3">
                        <div class="card-content">
                          <span class="card-title">P.E.T adatok</span>
                          <p><strong>Név:</strong> <?php echo $petName; ?></p>
                          <p><strong>Állapot:</strong> Aktív</p>
                        </div>
                      </div>
                    </div>
                  </div>
                <?php } else { ?>
                  <p class="flow-text">Még nincs P.E.T egységed. Szerezz be egyet 50.000 Uridiumért!</p>

                  <div class="row">
                    <div class="col s12 m6 offset-m3">
                      <div class="card grey darken-3">
                        <div class="card-content left-align">
                          <span class="card-title">P.E.T vásárlás</span>
                          <p>Aktuális Uridium egyenleged: <strong><?php echo number_format($accountData->uridium, 0, '.', '.'); ?></strong></p>
                          <form id="buy-pet" class="pet-form" method="post">
                            <div class="input-field">
                              <input type="text" name="petName" id="pet-name" maxlength="20" value="<?php echo $petName; ?>">
                              <label for="pet-name"<?php echo $petName ? ' class="active"' : ''; ?>>P.E.T név</label>
                              <span class="helper-text">3-20 karakter, betűkkel, számokkal, szóközzel, ponttal, kötőjellel vagy aláhúzással.</span>
                            </div>
                            <p>Költség: <strong>50.000 Uridium</strong></p>
                            <button class="btn grey darken-1 waves-effect waves-light" type="submit">P.E.T megvásárlása</button>
                          </form>
                        </div>
                      </div>
                    </div>
                  </div>
                <?php } ?>
              </div>
           </div>
          </div>
        </div>
      </div>
