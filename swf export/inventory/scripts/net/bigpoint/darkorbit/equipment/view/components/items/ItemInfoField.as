package net.bigpoint.darkorbit.equipment.view.components.items
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import net.bigpoint.darkorbit.equipment.view.Styles;
   
   public class ItemInfoField extends Sprite
   {
      
      public var mainText:TextField;
      
      public function ItemInfoField()
      {
         super();
         this.mainText = new TextField();
         if(Styles.baseEmbed)
         {
            this.mainText.defaultTextFormat = Styles.itemInfoFormat;
         }
         else
         {
            this.mainText.defaultTextFormat = Styles.itemInfoFormatDeviceFont;
         }
         this.mainText.height = 70;
         this.mainText.width = 100;
         this.mainText.selectable = false;
         this.mainText.x = 0;
         this.mainText.y = 0;
         this.mainText.textColor = 16777215;
         this.mainText.wordWrap = true;
         addChild(this.mainText);
      }
      
      public function addTextToMainField(param1:String) : void
      {
         this.mainText.text = param1;
         this.mainText.setTextFormat(Styles.itemInfoFormat);
      }
   }
}

