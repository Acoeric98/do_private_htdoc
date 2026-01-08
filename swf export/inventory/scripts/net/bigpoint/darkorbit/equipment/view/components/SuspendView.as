package net.bigpoint.darkorbit.equipment.view.components
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.model.AssetProxy;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.view.Styles;
   import net.bigpoint.darkorbit.equipment.view.components.items.MultiSelectionComponent;
   
   public class SuspendView extends Sprite
   {
      
      public static const COMMUNICATING_WITH_SERVER:String = "COMMUNICATING_WITH_SERVER";
      
      public static const CLIENT_INITIALISING:String = "CLIENT_INITIALISING";
      
      public static const GENERIC_ERROR:String = "ERROR";
      
      public static const NO_MESSAGE:String = "NO_MESSAGE";
      
      public static const ORANGE:uint = 16434692;
      
      public static const RED:uint = 16711680;
      
      private var covering:Sprite = new Sprite();
      
      private var message:MovieClip;
      
      private var multiSelector:MultiSelectionComponent;
      
      private var overlayMessage:MovieClip;
      
      private var loadingAnimation:MovieClip;
      
      private var errorGraphic:MovieClip;
      
      private var errorText:TextField;
      
      private var loadingLabel:TextField;
      
      public function SuspendView()
      {
         super();
         this.covering.graphics.beginFill(0,1);
         this.covering.graphics.drawRect(0,0,Settings.WINDOW_WIDTH,Settings.WINDOW_HEIGHT);
         this.covering.graphics.endFill();
         this.covering.alpha = 0.75;
         this.message = AssetProxy.getMovieClip("loadGfx","pleaseWait");
         this.message.x = 120;
         this.message.y = 65;
         this.loadingAnimation = AssetProxy.getMovieClip("loadGfx","loadingAnim");
         this.errorGraphic = AssetProxy.getMovieClip("loadGfx","errorGraphic");
         this.loadingLabel = new TextField();
         this.loadingLabel.defaultTextFormat = Styles.plainStdFmt;
         this.loadingLabel.embedFonts = Styles.plainStdEmbed;
         this.loadingLabel.width = 220;
         this.loadingLabel.height = 108;
         this.loadingLabel.y = 24;
         this.loadingLabel.antiAliasType = AntiAliasType.ADVANCED;
         this.overlayMessage = new MovieClip();
         this.loadingLabel.selectable = false;
         this.positionObjectCentrally(this.loadingAnimation);
         this.positionObjectCentrally(this.errorGraphic);
         this.errorGraphic.y = 110;
         this.loadingAnimation.y = 110;
         this.errorText = new TextField();
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.size = 12;
         _loc1_.font = Styles.baseEmbed ? "Verdana" : null;
         _loc1_.color = 16777215;
         _loc1_.align = TextFormatAlign.LEFT;
         this.errorText.defaultTextFormat = _loc1_;
         this.multiSelector = MultiSelectionComponent.getInstance();
      }
      
      private function changeOverlayText(param1:String, param2:uint) : void
      {
         this.loadingLabel.text = param1.toUpperCase();
         this.loadingLabel.textColor = param2;
         this.overlayMessage.addChild(this.loadingLabel);
         this.positionObjectCentrally(this.overlayMessage);
      }
      
      private function positionObjectCentrally(param1:DisplayObject) : void
      {
         param1.x = Settings.WINDOW_WIDTH * 0.5 - param1.width * 0.5;
         param1.y = Settings.WINDOW_HEIGHT * 0.5 - param1.height * 0.5;
      }
      
      public function toggleSuspend(param1:Boolean, param2:String, param3:String = null) : void
      {
         switch(param1)
         {
            case true:
               if(this.multiSelector)
               {
                  this.multiSelector.removeListeners();
               }
               addChild(this.covering);
               this.selectSuspendMessage(param2);
               addChild(this.message);
               addChild(this.overlayMessage);
               if(param3 != null)
               {
                  addChild(this.errorText);
                  this.errorText.text = "Error: " + param3;
                  this.errorText.selectable = true;
                  this.errorText.autoSize = TextFieldAutoSize.LEFT;
               }
               break;
            case false:
               this.multiSelector.addListeners();
               this.multiSelector.removeSelectedStatusFromAllItems();
               if(this.contains(this.covering))
               {
                  removeChild(this.covering);
               }
               if(this.contains(this.message))
               {
                  removeChild(this.message);
               }
               if(this.contains(this.overlayMessage))
               {
                  removeChild(this.overlayMessage);
               }
               if(this.contains(this.loadingAnimation))
               {
                  removeChild(this.loadingAnimation);
               }
               if(this.contains(this.errorGraphic))
               {
                  removeChild(this.errorGraphic);
               }
         }
      }
      
      private function selectSuspendMessage(param1:String) : void
      {
         switch(param1)
         {
            case COMMUNICATING_WITH_SERVER:
               this.message.gotoAndStop(4);
               this.covering.alpha = 0.75;
               addChild(this.loadingAnimation);
               this.changeOverlayText(BPLocale.getItem("overlay_message_loading"),ORANGE);
               this.overlayMessage.y = this.overlayMessage.y;
               break;
            case CLIENT_INITIALISING:
               this.message.gotoAndStop(4);
               this.covering.alpha = 1;
               addChild(this.loadingAnimation);
               this.changeOverlayText(BPLocale.getItem("overlay_message_loading"),ORANGE);
               this.overlayMessage.y = this.overlayMessage.y;
               break;
            case GENERIC_ERROR:
               this.message.gotoAndStop(4);
               this.covering.alpha = 0.75;
               addChild(this.errorGraphic);
               this.changeOverlayText(BPLocale.getItem("overlay_message_error"),RED);
               this.overlayMessage.y += 15;
               break;
            case NO_MESSAGE:
               this.message.gotoAndStop(4);
               this.covering.alpha = 0.75;
               this.changeOverlayText("",RED);
         }
      }
   }
}

