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
    <?php if (Functions::IsLoggedIn() && (isset($page[0]) && ($page[0] === 'skill_tree' || $page[0] === 'profile'))) { ?>
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
            <table class="nav-table" role="presentation">
              <thead>
                <tr>
                  <th><a href="<?php echo DOMAIN; ?>ships">HANGAR</a></th>
                  <th class="nav-table__brand" colspan="2">
                    <div class="nav-table__brand-title">ZERO TOLERANCE PVP</div>
                    <div class="nav-table__brand-id">Pilot ID: <?php echo $player['userId']; ?></div>
                  </th>
                  <th><a href="<?php echo DOMAIN; ?>shop">SHOP</a></th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td><a href="<?php echo DOMAIN; ?>equipment">EQUIPMENT</a></td>
                  <td><a href="<?php echo DOMAIN; ?>company-change">MEGBÍZÓ VÁLTÁS</a></td>
                  <td><a href="<?php echo DOMAIN; ?>ships-boosters">SHIP &amp; BOOSTER</a></td>
                  <td><a href="<?php echo DOMAIN; ?>auction">AUCTION</a></td>
                </tr>
                <tr>
                  <td><a href="<?php echo DOMAIN; ?>pet-15">PET</a></td>
                  <td class="nav-table__start" colspan="2" rowspan="2"><a href="<?php echo DOMAIN; ?>map-revolution" target="_blank" rel="noreferrer">START</a></td>
                  <td><a href="<?php echo DOMAIN; ?>clan-hub">CLAN</a></td>
                </tr>
                <tr>
                  <td><a href="<?php echo DOMAIN; ?>profile">PROFIL</a></td>
                  <td><a href="<?php echo DOMAIN; ?>settings">SETTINGS</a></td>
                </tr>
                <tr>
                  <td><a href="<?php echo DOMAIN; ?>galaxy-gates">GALAXY GATE</a></td>
                  <td><a href="<?php echo DOMAIN; ?>home">FŐOLDAL</a></td>
                  <td><a href="<?php echo DOMAIN; ?>interactive_map">MAP</a></td>
                  <td><a href="/api/logout">LOGOUT</a></td>
                </tr>
                <tr>
                  <td>
                    <span class="nav-table__stat-label">URIDIUM</span>
                    <span class="nav-table__stat-value" id="uridium"><?php echo number_format($data->uridium, 0, ',', '.'); ?></span>
                  </td>
                  <td>
                    <span class="nav-table__stat-label">CREDIT</span>
                    <span class="nav-table__stat-value" id="credits"><?php echo number_format($data->credits, 0, ',', '.'); ?></span>
                  </td>
                  <td>
                    <span class="nav-table__stat-label">EXPERIENCE</span>
                    <span class="nav-table__stat-value"><?php echo number_format($data->experience, 0, ',', '.'); ?></span>
                  </td>
                  <td>
                    <span class="nav-table__stat-label">HONOR</span>
                    <span class="nav-table__stat-value"><?php echo number_format($data->honor, 0, ',', '.'); ?></span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </nav>
      <?php } ?>
