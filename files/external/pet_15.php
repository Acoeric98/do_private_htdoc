<?php
    $equipment = $mysqli->query('SELECT items FROM player_equipment WHERE userId = '.$player['userId'].'')->fetch_assoc();
    $items = $equipment ? json_decode($equipment['items']) : null;

    $petOwned = $items && isset($items->pet) ? (bool)$items->pet : false;
    $petName = htmlspecialchars($player['petName']);
    $accountData = json_decode($player['data']);

    $petDesign = ($items && isset($items->petDesign) && !empty($items->petDesign)) ? $items->petDesign : 'pet10-4';
    $petModules = $items && isset($items->petModules) && is_array($items->petModules) ? $items->petModules : [];

    $petVisuals = [
        'pet10-4' => 'do_img/global/pet/pet10-4_top.png',
        'pet10-10' => 'do_img/global/pet/pet10-10_top.png',
        'pet10-11' => 'do_img/global/pet/pet10-11_top.png',
        'pet10-14' => 'do_img/global/pet/pet10-14_top.png'
    ];

    $moduleLibrary = [
        'g-al1' => ['name' => 'Auto-looter', 'icon' => 'do_img/global/pet_protocol_g-al1_100x100.png'],
        'g-ar1' => ['name' => 'Auto-resource', 'icon' => 'do_img/global/pet_protocol_g-ar1_100x100.png'],
        'g-el1' => ['name' => 'Enemy locator', 'icon' => 'do_img/global/pet_protocol_g-el1_100x100.png'],
        'g-rl1' => ['name' => 'Resource locator', 'icon' => 'do_img/global/pet_protocol_g-rl1_100x100.png'],
        'g-tra1' => ['name' => 'Cargo trader', 'icon' => 'do_img/global/pet_protocol_g-tra1_100x100.png'],
        'g-rep1' => ['name' => 'P.E.T. repairer', 'icon' => 'do_img/global/pet_protocol_g-rep1_100x100.png'],
        'g-kk1' => ['name' => 'Kamikaze detonator', 'icon' => 'do_img/global/pet_protocol_g-kk1_100x100.png'],
        'g-hp1' => ['name' => 'Hull upgrade', 'icon' => 'do_img/global/pet_upgrade_g-hp1_100x100.png'],
        'g-pd1' => ['name' => 'Damage protocol', 'icon' => 'do_img/global/pet_protocol_g-pd1_100x100.png']
    ];
?>

      <div id="main">
        <div class="container">
          <div class="row">
            <div class="col s12">
              <div class="beta-banner">
                <p class="beta-banner__eyebrow">BÉTA ÜZEMMÓD</p>
                <p class="beta-banner__title">A P.E.T konfigurátor még béta, nem működik, viszont az uridiumot levonja.</p>
                <p class="beta-banner__hint">Minden slot feloldása 5.000 Uridiumba kerül, használat előtt ellenőrizd az egyenleget!</p>
              </div>

              <div class="card white-text grey darken-4 padding-15">
                <div class="pet-hero">
                  <div>
                    <p class="eyebrow">Taktikai segéded</p>
                    <h4 class="no-margin">P.E.T 15</h4>
                    <p class="pet-subtitle">Ellenőrizd a P.E.T állapotát, moduljait és vásárolj új egységet, ha még nincs.</p>
                  </div>
                  <div class="pet-visual">
                    <div class="pet-visual__glow"></div>
                    <img src="<?php echo DOMAIN.(isset($petVisuals[$petDesign]) ? $petVisuals[$petDesign] : $petVisuals['pet10-4']); ?>" alt="P.E.T kinézet">
                  </div>
                </div>

                <div class="card grey darken-3 pet-card pet-config-card">
                  <div class="card-content">
                    <div class="pet-config__header">
                      <div>
                        <p class="eyebrow">Konfiguráció</p>
                        <span class="card-title">P.E.T modul kiosztás (Béta)</span>
                        <p class="pet-subtitle">Állítsd össze a P.E.T felszerelését. A mezők kattinthatók, legördülő menükből választhatsz.</p>
                      </div>
                      <div class="pet-config__cost">
                        <p class="pet-config__cost-label">Feloldási díj</p>
                        <p class="pet-config__cost-value">5.000 <span>Uridium</span></p>
                      </div>
                    </div>

                    <div class="pet-config__grid">
                      <div class="pet-slot">
                        <div class="pet-slot__header">
                          <span class="material-icons">bolt</span>
                          <div>
                            <p class="pet-slot__title">Lézer</p>
                            <p class="pet-slot__hint">Kattints és válassz típust</p>
                          </div>
                          <span class="pet-slot__lock">5000</span>
                        </div>
                        <select class="browser-default pet-slot__select">
                          <option>B02</option>
                          <option>LF4</option>
                        </select>
                      </div>

                      <div class="pet-slot">
                        <div class="pet-slot__header">
                          <span class="material-icons">tune</span>
                          <div>
                            <p class="pet-slot__title">Generátor</p>
                            <p class="pet-slot__hint">Válaszd ki a beszerelni kívánt generátort</p>
                          </div>
                          <span class="pet-slot__lock">5000</span>
                        </div>
                        <select class="browser-default pet-slot__select">
                          <option>B02</option>
                          <option>LF4</option>
                        </select>
                      </div>

                      <div class="pet-slot">
                        <div class="pet-slot__header">
                          <span class="material-icons">precision_manufacturing</span>
                          <div>
                            <p class="pet-slot__title">Berendezés</p>
                            <p class="pet-slot__hint">Állítsd be a működési módot</p>
                          </div>
                          <span class="pet-slot__lock">5000</span>
                        </div>
                        <select class="browser-default pet-slot__select">
                          <option>Kamikaze</option>
                          <option>Védelmi mód</option>
                          <option>Gyűjtő</option>
                        </select>
                      </div>

                      <div class="pet-slot">
                        <div class="pet-slot__header">
                          <span class="material-icons">radar</span>
                          <div>
                            <p class="pet-slot__title">Protokollok</p>
                            <p class="pet-slot__hint">Válassz a legördülő listából</p>
                          </div>
                          <span class="pet-slot__lock">5000</span>
                        </div>
                        <select class="browser-default pet-slot__select">
                          <option>Lézersebzés radar protokoll</option>
                          <option>Radar protokoll</option>
                          <option>Kamikaze</option>
                        </select>
                      </div>
                    </div>
                  </div>
                </div>

                <?php if ($petOwned) { ?>
                  <div class="row pet-grid">
                    <div class="col s12 m6">
                      <div class="card grey darken-3 pet-card">
                        <div class="card-content">
                          <span class="card-title">P.E.T adatok</span>
                          <p class="pet-label">Név</p>
                          <p class="pet-value" id="pet-name-display"><?php echo $petName; ?></p>
                          <p class="pet-label">Állapot</p>
                          <p class="pet-value status-active">Aktív</p>
                          <p class="pet-label">Energia</p>
                          <div class="pet-bar">
                            <div class="pet-bar__fill" style="width: 86%"></div>
                          </div>
                          <p class="pet-label">Üzemanyag</p>
                          <div class="pet-bar pet-bar--secondary">
                            <div class="pet-bar__fill" style="width: 64%"></div>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div class="col s12 m6">
                      <div class="card grey darken-3 pet-card">
                        <div class="card-content">
                          <span class="card-title">Felszerelt modulok</span>

                          <?php if (count($petModules) === 0) { ?>
                            <p class="pet-empty">Jelenleg nincs felszerelt P.E.T modul. Szerezz be új protokollokat vagy felszereléseket!</p>
                          <?php } else { ?>
                            <div class="pet-modules">
                              <?php foreach ($petModules as $moduleCode) {
                                  $moduleCode = strtolower($moduleCode);
                                  $moduleData = isset($moduleLibrary[$moduleCode]) ? $moduleLibrary[$moduleCode] : null;
                              ?>
                                <div class="pet-module">
                                  <div class="pet-module__icon">
                                    <?php if ($moduleData && isset($moduleData['icon'])) { ?>
                                      <img src="<?php echo DOMAIN.$moduleData['icon']; ?>" alt="<?php echo $moduleCode; ?>">
                                    <?php } else { ?>
                                      <span class="material-icons">widgets</span>
                                    <?php } ?>
                                  </div>
                                  <div class="pet-module__info">
                                    <p class="pet-module__title"><?php echo $moduleData ? $moduleData['name'] : strtoupper($moduleCode); ?></p>
                                    <p class="pet-module__code"><?php echo strtoupper($moduleCode); ?></p>
                                  </div>
                                </div>
                              <?php } ?>
                            </div>
                          <?php } ?>
                        </div>
                      </div>
                    </div>
                  </div>

                  <div class="row">
                    <div class="col s12 m6 offset-m3">
                      <div class="card grey darken-3 pet-card">
                        <div class="card-content left-align">
                          <span class="card-title">P.E.T név módosítása</span>
                          <p class="pet-subtitle">Változtasd meg a P.E.T nevét 3.000 Uridiumért.</p>
                          <form id="rename-pet" class="pet-form" method="post">
                            <div class="input-field">
                              <input type="text" name="petName" id="pet-rename" maxlength="20" value="<?php echo $petName; ?>">
                              <label for="pet-rename"<?php echo $petName ? ' class="active"' : ''; ?>>Új P.E.T név</label>
                              <span class="helper-text">3-20 karakter, betűkkel, számokkal, szóközzel, ponttal, kötőjellel vagy aláhúzással.</span>
                            </div>
                            <p>Költség: <strong>3.000 Uridium</strong></p>
                            <button class="btn grey darken-1 waves-effect waves-light" type="submit">Név megváltoztatása</button>
                          </form>
                        </div>
                      </div>
                    </div>
                  </div>
                <?php } else { ?>
                  <div class="row">
                    <div class="col s12 m6 offset-m3">
                      <div class="card grey darken-3 pet-card">
                        <div class="card-content left-align">
                          <span class="card-title">P.E.T vásárlás</span>
                          <p class="pet-subtitle">Még nincs P.E.T egységed. Szerezz be egyet 50.000 Uridiumért!</p>
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
