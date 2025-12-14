<?php
if (!Functions::IsLoggedIn()) {
  header('Location: /');
  die();
}

$mysqli->begin_transaction();

try {
  foreach ($mysqli->query('SELECT * FROM server_bans WHERE userId = '.$player['userId'].' AND ended = 0 AND typeId = 0')->fetch_all(MYSQLI_ASSOC) as $value) {
    if (new DateTime(date('d.m.Y H:i:s')) >= new DateTime($value['end_date'])) {
      $mysqli->query('UPDATE server_bans SET ended = 1 WHERE id = '.$value['id']);
    }
  }

  $mysqli->commit();
} catch (Exception $e) {
  $mysqli->rollback();
}

$chatBan = $mysqli->query('SELECT * FROM server_bans WHERE userId = '.$player['userId'].' AND ended = 0 AND typeId = 0')->fetch_assoc();
?>
<div id="main">
  <div class="container">
    <div class="row">
      <div class="col s12">
        <div class="card white-text grey darken-4 chat-card">
          <div class="card-content">
            <span class="card-title">Ingame chat</span>
            <p>Reach the in-game chat here without launching the full map.</p>
          </div>

          <?php if ($chatBan) { ?>
            <div class="card-content chat-card__warning">
              <h6>You are currently banned from chat.</h6>
              <p>Reason: <?php echo $chatBan['reason']; ?></p>
              <p>End date: <?php echo (new DateTime(date('d.m.Y H:i:s')))->diff(new DateTime($chatBan['end_date']))->days >= 9998 ? 'Permanent' : date('d.m.Y H:i', strtotime($chatBan['end_date'])); ?></p>
            </div>
          <?php } else { ?>
            <div class="card-content">
              <div id="chat-wrapper" class="chat-card__embed">
                <div id="chat-swf"></div>
              </div>
              <div id="chat-fallback" class="chat-card__fallback" style="display: none;">
                <p>The chat client could not be loaded. Please ensure Flash support is available in your browser.</p>
              </div>
            </div>
          <?php } ?>
        </div>
      </div>
    </div>
  </div>
</div>

<?php if (!$chatBan) { ?>
  <script type="text/javascript" src="<?php echo DOMAIN; ?>js/darkorbit/jquery.flashembed.js"></script>
  <script type="text/javascript">
    (function() {
      function showFallback($) {
        $('#chat-wrapper').hide();
        $('#chat-fallback').show();
      }

      function initChat() {
        if (typeof window.jQuery === 'undefined') {
          return window.setTimeout(initChat, 50);
        }

        var $ = window.jQuery;

        if (typeof flashembed === 'undefined') {
          showFallback($);
          return;
        }

        flashembed('chat-swf', {
          onFail: function() { showFallback($); },
          src: '<?php echo DOMAIN; ?>gamechat/as3/chat.swf',
          version: [11, 0],
          width: '100%',
          height: '500',
          wmode: 'direct',
          bgcolor: '#000000',
          id: 'chatClient',
          allowfullscreen: 'true',
          allowFullScreenInteractive: 'true'
        }, {
          lang: 'en',
          userID: '<?php echo $player['userId']; ?>',
          sessionID: '<?php echo $player['sessionId']; ?>',
          basePath: 'gamechat/as3',
          pid: '563',
          configXML: '<?php echo DOMAIN; ?>gamechat/as3/cfg/base_563.xml',
          configExtXML: '<?php echo DOMAIN; ?>gamechat/as3/cfg/extended_563_0.xml',
          langXML: '<?php echo DOMAIN; ?>gamechat/as3/lang/en/resource.xml'
        });
      }

      initChat();
    })();
  </script>
<?php } ?>
