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
      <ul id="dropdown1" class="dropdown-content">
        <li><a href="<?php echo DOMAIN; ?>ships">Ships</a></li>
        <li><a href="<?php echo DOMAIN; ?>equipment">Equipment</a></li>
        <li><a href="<?php echo DOMAIN; ?>skill-tree">Skill Tree</a></li>
      </ul>
      <ul id="dropdown2" class="dropdown-content">

        <?php if ($player['clanId'] <= 0) { ?>
        <li><a href="<?php echo DOMAIN; ?>clan/join">Join</a></li>
        <li><a href="<?php echo DOMAIN; ?>clan/found">Found</a></li>

        <?php } else { ?>
        <li><a href="<?php echo DOMAIN; ?>clan/informations">Informations</a></li>
        <li><a href="<?php echo DOMAIN; ?>clan/members">Members</a></li>
        <li><a href="<?php echo DOMAIN; ?>clan/diplomacy">Diplomacy</a></li>
        <?php }?>

        <li><a href="<?php echo DOMAIN; ?>clan/company">Company</a></li>
      </ul>
      <nav>
        <div class="nav-wrapper grey darken-4">
          <div class="container nav-balanced">
            <div class="nav-row nav-primary">
              <ul class="nav-links nav-left nav-inline hide-on-med-and-down">
                <li><a class="dropdown-trigger" href="#!" data-target="dropdown1">Hangar<i class="material-icons right">arrow_drop_down</i></a></li>
                <li><a class="dropdown-trigger" href="#!" data-target="dropdown2">Clan<i class="material-icons right">arrow_drop_down</i></a></li>
                <li><a href="<?php echo DOMAIN; ?>pet-15">P.E.T 15</a></li>
              </ul>

              <div class="nav-center brand-inline">
                <a href="<?php echo DOMAIN; ?>" class="brand-stacked">Zero-Tolerance PvP</a>
                <a class="btn nav-start grey darken-3 waves-effect waves-light" href="<?php echo DOMAIN; ?>map-revolution" target="_blank">Start</a>
              </div>
            </div>

            <ul class="nav-links nav-right nav-inline nav-secondary hide-on-med-and-down">
              <li><a href="<?php echo DOMAIN; ?>galaxy-gates">Galaxy Gates</a></li>
              <li><a href="<?php echo DOMAIN; ?>shop">Shop</a></li>
              <li><a href="<?php echo DOMAIN; ?>settings">Settings</a></li>
              <li><a href="/api/logout">Logout</a></li>
            </ul>
          </div>
        </div>
      </nav>
      <?php } ?>
