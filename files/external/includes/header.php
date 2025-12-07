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
              <ul class="nav-column nav-column--left">
                <li><a href="<?php echo DOMAIN; ?>ships">Hangar</a></li>
                <li><a href="<?php echo DOMAIN; ?>equipment">Equipment</a></li>
                <li><a href="<?php echo DOMAIN; ?>galaxy-gates">Galaxy Gates</a></li>
                <li><a href="<?php echo DOMAIN; ?>pet-15">P.E.T 15</a></li>
              </ul>

              <div class="nav-column nav-column--center">
                <a href="<?php echo DOMAIN; ?>" class="brand-stacked">Zero-Tolerance PvP</a>
                <div class="nav-meta">
                  <span class="nav-meta__item">Pilot ID: <?php echo $player['userId']; ?></span>
                </div>
                <a class="btn nav-start grey darken-3 waves-effect waves-light" href="<?php echo DOMAIN; ?>map-revolution" target="_blank">Start</a>
              </div>

              <ul class="nav-column nav-column--right">
                <li><a href="<?php echo DOMAIN; ?>shop">Shop</a></li>
                <li><a href="<?php echo DOMAIN; ?>auction">Auction</a></li>
                <li><a href="<?php echo DOMAIN; ?>settings">Settings</a></li>
                <li><a href="/api/logout">Logout</a></li>
              </ul>
            </div>

            <div class="nav-stats">
              <div class="nav-stat">
                <span class="nav-stat__label">Uridium</span>
                <span class="nav-stat__value" id="uridium"><?php echo number_format($data->uridium, 0, ',', '.'); ?></span>
              </div>
              <div class="nav-stat">
                <span class="nav-stat__label">Credit</span>
                <span class="nav-stat__value" id="credits"><?php echo number_format($data->credits, 0, ',', '.'); ?></span>
              </div>
              <div class="nav-stat nav-stat--wide">
                <span class="nav-stat__label">Honor + Experience</span>
                <span class="nav-stat__value"><?php echo number_format($data->honor, 0, ',', '.'); ?> / <?php echo number_format($data->experience, 0, ',', '.'); ?></span>
              </div>
            </div>
          </div>
        </div>
      </nav>
      <?php } ?>
