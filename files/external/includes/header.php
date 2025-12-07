<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title>DarkOrbit 10.0</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link type="text/css" rel="stylesheet" href="<?php echo DOMAIN; ?>css/materialize.min.css"  media="screen,projection"/>
    <link type="text/css" rel="stylesheet" href="<?php echo DOMAIN; ?>css/style.css"/>
    <?php if (Functions::IsLoggedIn() && ((isset($page[0]) && $page[0] === 'company_select') || (isset($page[0]) && $page[0] === 'clan' && isset($page[1]) && $page[1] === 'company'))) { ?>
    <link type="text/css" rel="stylesheet" href="<?php echo DOMAIN; ?>css/company-select.css"/>
    <?php } ?>
    <?php if (Functions::IsLoggedIn() && (isset($page[0]) && $page[0] === 'skill_tree')) { ?>
    <link type="text/css" rel="stylesheet" href="<?php echo DOMAIN; ?>css/skill-tree.css"/>
    <?php } ?>
    <?php if (Functions::IsLoggedIn() && (isset($page[0]) && $page[0] === 'ships')) { ?>
    <link type="text/css" rel="stylesheet" href="<?php echo DOMAIN; ?>css/ships.css"/>
    <?php } ?>
  </head>
  <body>
    <div id="app">

      <?php if (Functions::IsLoggedIn()) { ?>
      <nav>
        <div class="nav-wrapper grey darken-4">
          <div class="container nav-shell">
            <div class="nav-table">
              <a class="nav-cell nav-cell--hangar" href="<?php echo DOMAIN; ?>ships">Hangar</a>
              <a class="nav-cell nav-cell--brand" href="<?php echo DOMAIN; ?>">
                <div>Zero Tolerance PvP</div>
                <span>Pilot ID: <?php echo $player['userId']; ?></span>
              </a>
              <a class="nav-cell nav-cell--shop" href="<?php echo DOMAIN; ?>shop">Shop</a>

              <a class="nav-cell nav-cell--equipment" href="<?php echo DOMAIN; ?>equipment">Equipment</a>
              <div class="nav-cell nav-cell--empty" aria-hidden="true"></div>
              <div class="nav-cell nav-cell--empty" aria-hidden="true"></div>
              <a class="nav-cell nav-cell--auction" href="<?php echo DOMAIN; ?>auction">Auction</a>

              <a class="nav-cell nav-cell--pet" href="<?php echo DOMAIN; ?>pet-15">Pet</a>
              <a class="nav-cell nav-cell--start" href="<?php echo DOMAIN; ?>map-revolution" target="_blank">Start</a>
              <a class="nav-cell nav-cell--settings" href="<?php echo DOMAIN; ?>settings">Settings</a>

              <a class="nav-cell nav-cell--galaxy" href="<?php echo DOMAIN; ?>galaxy-gates">Galaxy Gates</a>
              <div class="nav-cell nav-cell--empty" aria-hidden="true"></div>
              <div class="nav-cell nav-cell--empty" aria-hidden="true"></div>
              <a class="nav-cell nav-cell--logout" href="/api/logout">Logout</a>
            </div>

            <div class="nav-stats-row">
              <div class="nav-stat">
                <div class="nav-stat__label">Uridium</div>
                <div class="nav-stat__value" id="uridium"><?php echo number_format($data->uridium, 0, ',', '.'); ?></div>
              </div>
              <div class="nav-stat">
                <div class="nav-stat__label">Credit</div>
                <div class="nav-stat__value" id="credits"><?php echo number_format($data->credits, 0, ',', '.'); ?></div>
              </div>
              <div class="nav-stat">
                <div class="nav-stat__label">Experience</div>
                <div class="nav-stat__value"><?php echo number_format($data->experience, 0, ',', '.'); ?></div>
              </div>
              <div class="nav-stat">
                <div class="nav-stat__label">Honor</div>
                <div class="nav-stat__value"><?php echo number_format($data->honor, 0, ',', '.'); ?></div>
              </div>
            </div>
          </div>
        </div>
      </nav>
      <?php } ?>
