<?php
$skillData = Functions::GetSkillTreeData($player['userId']);
?>
      <div id="main" class="profile">
        <div class="container">
          <div class="row">
            <div class="col s12">
              <div class="card white-text grey darken-4">
                <div class="padding-15">
                  <h5>PROFIL</h5>
                  <ul class="tabs grey darken-3 tabs-fixed-width tab-demo z-depth-1">
                    <li class="tab"><a class="active" href="#profile-skilltree">Skill Tree</a></li>
                    <li class="tab"><a href="#profile-titles">Címek</a></li>
                    <li class="tab"><a href="#profile-pilot">Pilóta profil</a></li>
                    <li class="tab"><a href="#profile-ranking">Összesített rangsor</a></li>
                  </ul>

                  <div id="profile-skilltree">
                    <div class="card white-text grey darken-4 padding-15">
                      <h6>Skill Tree</h6>
<?php if ($skillData !== null) { ?>
                      <p>LOG-DISKS: <span id="logdisks"><?php echo $skillData['skillTree']->logdisks; ?></span> / REQUIRED: <span id="requiredLogdisks"><?php echo $skillData['requiredLogdisks']; ?></span> > <button id="exchangeLogdisks" class="btn-small grey darken-3 waves-effect waves-light" <?php echo (($skillData['skillTree']->logdisks < $skillData['requiredLogdisks']) || ((array_sum((array)$skillData['skillPoints']) + $skillData['skillTree']->researchPoints) >= array_sum(array_column($skillData['skills'], 'maxLevel'))) ? 'disabled' : '');?>>EXCHANGE</button> >> Research Points: <span id="researchPoints"><?php echo $skillData['skillTree']->researchPoints; ?></span></p>
                      <div class="scrollBackground">
                      <?php foreach ($skillData['skills'] as $key => $value) { ?>
                        <div class="skillContainer">
                          <div id="<?php echo $key; ?>" class="skill tooltipped" data-position="left" data-tooltip="<?php echo Functions::GetSkillTooltip($value['name'], $value['currentLevel'], $value['maxLevel']); ?>">
                              <div class="<?php echo ($value['currentLevel'] == $value['maxLevel'] ? 'skill_effect_max' : (isset($value['baseSkill']) && $skillData['skills'][$value['baseSkill']]['currentLevel'] != $skillData['skills'][$value['baseSkill']]['maxLevel'] ? 'skill_effect_inactive' : 'skill_effect')); ?> <?php echo ($skillData['skillTree']->researchPoints <= 0 ? 'noCursor' : ''); ?> customTooltip type_skillTree loadType_normal id_skill_18a_info inner_skillTreeHorScrollable  outer_profilePage top_120 left_300">
                                  <div class="skillPoints <?php echo ($value['currentLevel'] == $value['maxLevel'] ? 'skilltree_font_ismax' : 'skilltree_font_fail_skillPoints'); ?>">
                                      <span class="currentLevel"><?php echo $value['currentLevel']; ?></span>/<span class="maxLevel"><?php echo $value['maxLevel']; ?></span>
                                  </div>
                              </div>
                          </div>
                        </div>
                      <?php } ?>
                      </div>
                      <p>Research Points used: <span id="usedResearchPoints"><?php echo array_sum((array)$skillData['skillPoints']); ?></span>/<?php echo array_sum(array_column($skillData['skills'], 'maxLevel')); ?> <button <?php if (array_sum((array)$skillData['skillPoints']) <= 0) { ?>style="display: none;"<?php } ?> class="btn-small grey darken-3 waves-effect waves-light modal-trigger" href="#modal">RESET SKILLS (<?php echo number_format(Functions::GetResetSkillCost($skillData['skillTree']->resetCount), 0, '.', '.'); ?> Uridium)</button></p>
<?php } else { ?>
                      <p class="red-text text-lighten-2">A skill fa adatai jelenleg nem elérhetők.</p>
<?php } ?>
                    </div>
                  </div>

                  <div id="profile-titles">
                    <div class="card white-text grey darken-4 padding-15">
                      <h6>Címek</h6>
                      <p>Dummy tartalom: itt lesznek listázva a megszerzett és aktív címek, külön szűrőkkel és statisztikákkal.</p>
                    </div>
                  </div>

                  <div id="profile-pilot">
                    <div class="card white-text grey darken-4 padding-15">
                      <h6>Pilóta profil</h6>
                      <p>Dummy tartalom: a pilóta részletes profilja (felszerelés, hajók, felszereltség) később kerül kitöltésre.</p>
                    </div>
                  </div>

                  <div id="profile-ranking">
                    <div class="card white-text grey darken-4 padding-15">
                      <h6>Összesített rangsor</h6>
                      <p>Dummy tartalom: itt fog megjelenni az összesített ranglista (pilóták, klánok, frakciók) szűrhető táblázatokkal.</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div id="modal" class="modal grey darken-4 white-text">
        <div class="modal-content">
          <p>Do you really want to reset your skills?</p>
        </div>
        <div class="modal-footer grey darken-4">
          <a class="modal-close waves-effect waves-light btn grey darken-2">Close</a>
          <a id="resetSkills" class="modal-close waves-effect waves-light btn grey darken-3">OK</a>
        </div>
      </div>
