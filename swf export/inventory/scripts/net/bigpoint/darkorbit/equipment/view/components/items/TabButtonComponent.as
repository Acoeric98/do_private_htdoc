package net.bigpoint.darkorbit.equipment.view.components.items
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import net.bigpoint.darkorbit.equipment.view.Styles;
   import net.bigpoint.darkorbit.equipment.view.components.buttons.AbstractButton;
   
   public class TabButtonComponent extends AbstractButton
   {
      
      public static const ID_SHIP:int = 0;
      
      public static const ID_DRONES:int = 1;
      
      public static const ID_PET:int = 2;
      
      public var clip:MovieClip;
      
      public var id:int;
      
      public var tabName:String;
      
      public var contentHeight:Number;
      
      public var open:Boolean = false;
      
      public function TabButtonComponent(param1:MovieClip, param2:int)
      {
         super();
         this.clip = param1;
         this.id = param2;
         this.mouseChildren = false;
         var _loc3_:TextField = param1.btnTitle;
         _loc3_.selectable = false;
         _loc3_.mouseEnabled = false;
         _loc3_.embedFonts = Styles.baseEmbed;
         addChild(this.clip);
      }
      
      public function setTabActive() : void
      {
         this.clip.gotoAndStop(2);
         this.clip.btnTitle.textColor = 16500992;
      }
      
      public function setTabInactive() : void
      {
         this.clip.gotoAndStop(1);
         this.clip.btnTitle.textColor = 16777215;
      }
      
      public function deactive() : void
      {
         this.clip.gotoAndStop(1);
         this.clip.btnTitle.textColor = 7829367;
      }
   }
}

