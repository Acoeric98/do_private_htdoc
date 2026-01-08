package net.bigpoint.darkorbit.equipment.view.components
{
   import flash.display.Sprite;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import net.bigpoint.darkorbit.equipment.model.deprecated.AvatarVO;
   import net.bigpoint.darkorbit.equipment.view.Styles;
   
   public class DetailView extends Sprite
   {
      
      public static const COMPONENT_WIDTH:int = 796;
      
      public static const COMPONENT_HEIGHT:int = 100;
      
      public static const BORDER:int = 10;
      
      private var detailText:TextField;
      
      public function DetailView()
      {
         super();
      }
      
      public function initComponent() : void
      {
         this.graphics.beginFill(3355443,1);
         this.graphics.drawRect(0,0,COMPONENT_WIDTH,COMPONENT_HEIGHT);
         this.graphics.endFill();
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.color = 16777215;
         _loc1_.font = Styles.baseEmbed ? "Verdana" : null;
         _loc1_.size = 15;
         this.detailText = new TextField();
         this.detailText.width = COMPONENT_WIDTH - 2 * BORDER;
         this.detailText.height = COMPONENT_HEIGHT - 2 * BORDER;
         this.detailText.multiline = true;
         this.detailText.autoSize = TextFieldAutoSize.LEFT;
         this.detailText.antiAliasType = AntiAliasType.ADVANCED;
         this.detailText.x = this.detailText.y = BORDER;
         this.detailText.defaultTextFormat = _loc1_;
         this.addChild(this.detailText);
      }
      
      public function highlightDetail(param1:AvatarVO) : void
      {
         this.detailText.text = param1.title.toUpperCase() + "\n" + param1.description;
      }
   }
}

