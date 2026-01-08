package net.bigpoint.darkorbit.equipment.view.components
{
   import flash.display.Sprite;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class IconURLView extends Sprite
   {
      
      private static const COMPONENT_WIDTH:int = 796;
      
      private static const COMPONENT_HEIGHT:int = 100;
      
      private static const BORDER:int = 10;
      
      private var urlText:TextField;
      
      public function IconURLView()
      {
         super();
      }
      
      public function initComponent() : void
      {
         this.graphics.beginFill(13421772,1);
         this.graphics.drawRect(0,0,COMPONENT_WIDTH,COMPONENT_HEIGHT);
         this.graphics.endFill();
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.color = 0;
         _loc1_.font = "Verdana";
         _loc1_.size = 18;
         this.urlText = new TextField();
         this.urlText.width = COMPONENT_WIDTH - 2 * BORDER;
         this.urlText.height = COMPONENT_HEIGHT - 2 * BORDER;
         this.urlText.multiline = true;
         this.urlText.autoSize = TextFieldAutoSize.LEFT;
         this.urlText.antiAliasType = AntiAliasType.ADVANCED;
         this.urlText.x = this.urlText.y = BORDER;
         this.urlText.defaultTextFormat = _loc1_;
         this.addChild(this.urlText);
      }
      
      public function highlightURL(param1:String) : void
      {
         this.urlText.text = "icon URL : " + param1;
      }
   }
}

