<?php
$isInClan = isset($player['clanId']) && $player['clanId'] > 0;
$clanMemberCount = 0;

if ($isInClan && isset($clan)) {
  $clanMemberCount = intval($mysqli->query('SELECT COUNT(userId) as cnt FROM player_accounts WHERE clanId = '.$clan['id'])->fetch_assoc()['cnt']);
}
?>

      <div id="main">
        <div class="container">
          <div class="row">
            <div class="col s12">
              <div class="card white-text grey darken-4 padding-15">
                <h5>KLÁN KÖZPONT</h5>
                <p class="grey-text text-lighten-2">Itt éred el a klánoddal kapcsolatos menüpontokat, így nem kell az almappák között keresgélni.</p>

                <?php if ($isInClan && isset($clan)) { ?>
                <div class="card-panel grey darken-3 white-text">
                  <div class="row" style="margin-bottom: 0;">
                    <div class="col s12 m6">
                      <p class="no-margin"><strong>Klán:</strong> [<?php echo $clan['tag']; ?>] <?php echo $clan['name']; ?></p>
                      <p class="no-margin"><strong>Rang:</strong> <?php echo $clan['rank']; ?></p>
                      <p class="no-margin"><strong>Tagok száma:</strong> <?php echo $clanMemberCount; ?></p>
                    </div>
                    <div class="col s12 m6">
                      <p class="no-margin"><strong>Vezető:</strong> <?php echo $mysqli->query('SELECT pilotName FROM player_accounts WHERE userId = '.$clan['leaderId'])->fetch_assoc()['pilotName']; ?></p>
                      <p class="no-margin"><strong>Toborzás:</strong> <?php echo ($clan['recruiting'] ? 'Nyitott' : 'Zárt'); ?></p>
                      <p class="no-margin"><strong>Cég:</strong> <?php echo ($clan['factionId'] == 0 ? 'Összes' : ($clan['factionId'] == 1 ? 'MMO' : ($clan['factionId'] == 2 ? 'EIC' : 'VRU'))); ?></p>
                    </div>
                  </div>
                </div>
                <?php } else { ?>
                <div class="card-panel grey darken-3 white-text">
                  <p class="no-margin"><strong>Nem vagy klánban.</strong> Csatlakozz egy klánhoz vagy alapíts újat az alábbi gombokkal.</p>
                </div>
                <?php } ?>

                <div class="row" style="margin-bottom: 0;">
                  <div class="col s12 m6 l4" style="margin-bottom: 12px;">
                    <a class="btn grey darken-3 waves-effect waves-light col s12" href="<?php echo DOMAIN; ?>clan/join">Klán keresése</a>
                  </div>
                  <?php if (!$isInClan) { ?>
                  <div class="col s12 m6 l4" style="margin-bottom: 12px;">
                    <a class="btn grey darken-2 waves-effect waves-light col s12" href="<?php echo DOMAIN; ?>clan/found">Új klán alapítása</a>
                  </div>
                  <?php } ?>
                  <?php if ($isInClan && isset($clan)) { ?>
                  <div class="col s12 m6 l4" style="margin-bottom: 12px;">
                    <a class="btn grey darken-2 waves-effect waves-light col s12" href="<?php echo DOMAIN; ?>clan/informations">Klán adatok</a>
                  </div>
                  <div class="col s12 m6 l4" style="margin-bottom: 12px;">
                    <a class="btn grey darken-2 waves-effect waves-light col s12" href="<?php echo DOMAIN; ?>clan/members">Tagok és jelentkezők</a>
                  </div>
                  <div class="col s12 m6 l4" style="margin-bottom: 12px;">
                    <a class="btn grey darken-2 waves-effect waves-light col s12" href="<?php echo DOMAIN; ?>clan/diplomacy">Diplomácia</a>
                  </div>
                  <div class="col s12 m6 l4" style="margin-bottom: 12px;">
                    <a class="btn grey darken-2 waves-effect waves-light col s12" href="<?php echo DOMAIN; ?>clan/clan-details/<?php echo $clan['id']; ?>">Publikus klánprofil</a>
                  </div>
                  <?php } ?>
                </div>
              </div>
           </div>
          </div>
        </div>
      </div>
