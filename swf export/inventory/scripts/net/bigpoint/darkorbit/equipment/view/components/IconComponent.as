package net.bigpoint.darkorbit.equipment.view.components
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class IconComponent extends Sprite
   {
      
      public var id:int;
      
      private var icon:Bitmap;
      
      public function IconComponent(param1:int)
      {
         super();
         this.id = param1;
         this.buttonMode = true;
         this.useHandCursor = true;
      }
      
      public function addIcon(param1:Bitmap) : void
      {
         this.icon = param1;
         this.addChild(this.icon);
      }
      
      public function setSelected() : void
      {
         this.icon.scaleX = this.icon.scaleY = 1.2;
      }
      
      public function setDeselected() : void
      {
         this.icon.scaleX = this.icon.scaleY = 1;
      }
   }
}

