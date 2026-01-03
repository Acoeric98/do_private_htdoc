<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Zero Tolerance PVP</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link type="text/css" rel="stylesheet" href="<?php echo DOMAIN; ?>css/materialize.min.css"  media="screen,projection"/>
    <link type="text/css" rel="stylesheet" href="<?php echo DOMAIN; ?>css/style.css"/>
    <?php if (isset($page[0]) && $page[0] === 'interactive_map') { ?>
    <link type="text/css" rel="stylesheet" href="<?php echo DOMAIN; ?>css/interactive-map.css"/>
    <?php } ?>
    <?php if (Functions::IsLoggedIn() && ((isset($page[0]) && $page[0] === 'company_select') || (isset($page[0]) && $page[0] === 'company_change') || (isset($page[0]) && $page[0] === 'clan' && isset($page[1]) && $page[1] === 'company'))) { ?>
    <link type="text/css" rel="stylesheet" href="<?php echo DOMAIN; ?>css/company-select.css"/>
    <?php } ?>
    <?php if (Functions::IsLoggedIn() && (isset($page[0]) && $page[0] === 'skill_tree')) { ?>
    <link type="text/css" rel="stylesheet" href="<?php echo DOMAIN; ?>css/skill-tree.css"/>
    <?php } ?>
    <?php if (Functions::IsLoggedIn() && (isset($page[0]) && ($page[0] === 'ships' || $page[0] === 'ships-boosters'))) { ?>
    <link type="text/css" rel="stylesheet" href="<?php echo DOMAIN; ?>css/ships.css"/>
    <?php } ?>
  </head>
  <body>
    <div id="app">

      <?php if (Functions::IsLoggedIn()) { ?>
      <nav>
        <div class="nav-wrapper grey darken-4">
          <div class="container nav-shell">
            <div class="nav-grid">
              <a class="nav-grid__item nav-grid__item--hangar" href="<?php echo DOMAIN; ?>ships">Hangar</a>
              <div class="nav-grid__item nav-grid__item--brand">
                <div>Zero Tolerance PvP</div>
                <span>Pilot ID: <?php echo $player['userId']; ?></span>
              </div>
              <a class="nav-grid__item nav-grid__item--shop" href="<?php echo DOMAIN; ?>shop">Shop</a>

              <a class="nav-grid__item nav-grid__item--equipment" href="<?php echo DOMAIN; ?>equipment">Equipment</a>
              <a class="nav-grid__item nav-grid__item--ships-boosters" href="<?php echo DOMAIN; ?>ships-boosters">Ships &amp; Boosters</a>
              <a class="nav-grid__item nav-grid__item--auction" href="<?php echo DOMAIN; ?>auction">Auction</a>

              <a class="nav-grid__item nav-grid__item--pet" href="<?php echo DOMAIN; ?>pet-15">Pet</a>
              <a class="nav-grid__item nav-grid__item--skill-tree" href="<?php echo DOMAIN; ?>skill_tree">Skill Tree</a>
              <a class="nav-grid__item nav-grid__item--start" href="<?php echo DOMAIN; ?>map-revolution" target="_blank">Start</a>
              <a class="nav-grid__item nav-grid__item--map" href="<?php echo DOMAIN; ?>interactive_map">Térkép</a>
              <a class="nav-grid__item nav-grid__item--home" href="<?php echo DOMAIN; ?>home">Főoldal</a>
              <a class="nav-grid__item nav-grid__item--settings" href="<?php echo DOMAIN; ?>settings">Settings</a>
              <a class="nav-grid__item nav-grid__item--clan" href="<?php echo DOMAIN; ?>clan-hub">Clan</a>
              <a class="nav-grid__item nav-grid__item--company-change" href="<?php echo DOMAIN; ?>company-change">Megbízóváltás</a>

              <div class="nav-grid__empty nav-grid__empty--auction-gap" aria-hidden="true"></div>

              <a class="nav-grid__item nav-grid__item--galaxy" href="<?php echo DOMAIN; ?>galaxy-gates">Galaxy Gates</a>
              <div class="nav-grid__empty nav-grid__empty--logout-gap" aria-hidden="true"></div>
              <div class="nav-grid__empty nav-grid__empty--logout-gap" aria-hidden="true"></div>
              <a class="nav-grid__item nav-grid__item--logout" href="/api/logout">Logout</a>

              <div class="nav-grid__item nav-grid__item--uridium">
                <div class="nav-grid__stat-label">Uridium</div>
                <div class="nav-grid__stat-value" id="uridium"><?php echo number_format($data->uridium, 0, ',', '.'); ?></div>
              </div>
              <div class="nav-grid__item nav-grid__item--credit">
                <div class="nav-grid__stat-label">Credit</div>
                <div class="nav-grid__stat-value" id="credits"><?php echo number_format($data->credits, 0, ',', '.'); ?></div>
              </div>
              <div class="nav-grid__item nav-grid__item--experience">
                <div class="nav-grid__stat-label">Experience</div>
                <div class="nav-grid__stat-value"><?php echo number_format($data->experience, 0, ',', '.'); ?></div>
              </div>
              <div class="nav-grid__item nav-grid__item--honor">
                <div class="nav-grid__stat-label">Honor</div>
                <div class="nav-grid__stat-value"><?php echo number_format($data->honor, 0, ',', '.'); ?></div>
              </div>
            </div>
          </div>
        </div>
      </nav>
      <?php } ?>
