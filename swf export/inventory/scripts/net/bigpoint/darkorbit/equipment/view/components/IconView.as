package net.bigpoint.darkorbit.equipment.view.components
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class IconView extends Sprite
   {
      
      public static const BORDER:int = 10;
      
      public static const COMPONENT_WIDTH:int = 796;
      
      public static const COMPONENT_HEIGHT:int = 100;
      
      public static const ICON_CLICKED:String = "ICON_CLICKED";
      
      public var selectedIcon:int = -1;
      
      private var iconComponents:Array;
      
      public function IconView()
      {
         super();
      }
      
      public function initComponent() : void
      {
         this.graphics.beginFill(13421772,1);
         this.graphics.drawRect(0,0,COMPONENT_WIDTH,COMPONENT_HEIGHT);
         this.graphics.endFill();
      }
      
      public function addIcons(param1:Array) : void
      {
         var _loc2_:IconComponent = null;
         var _loc3_:Bitmap = null;
         this.iconComponents = [];
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc2_ = new IconComponent(_loc4_);
            _loc3_ = param1[_loc4_] as Bitmap;
            _loc2_.addIcon(_loc3_);
            this.iconComponents.push(_loc2_);
            _loc4_++;
         }
         this.positionIcons();
      }
      
      private function positionIcons() : void
      {
         var _loc1_:IconComponent = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.iconComponents.length)
         {
            _loc1_ = this.iconComponents[_loc2_] as IconComponent;
            _loc1_.x = (_loc1_.width + BORDER) * _loc2_ + BORDER;
            _loc1_.y = (COMPONENT_HEIGHT - _loc1_.height) * 0.5;
            this.addChild(_loc1_);
            _loc2_++;
         }
         this.addListeners();
      }
      
      private function addListeners() : void
      {
         var _loc1_:IconComponent = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.iconComponents.length)
         {
            _loc1_ = this.iconComponents[_loc2_] as IconComponent;
            _loc1_.addEventListener(MouseEvent.CLICK,this.handleIconClicked);
            _loc2_++;
         }
      }
      
      private function removeListeners() : void
      {
         var _loc1_:IconComponent = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.iconComponents.length)
         {
            _loc1_ = this.iconComponents[_loc2_] as IconComponent;
            _loc1_.removeEventListener(MouseEvent.CLICK,this.handleIconClicked);
            _loc2_++;
         }
      }
      
      private function getIconComponent(param1:int) : IconComponent
      {
         return this.iconComponents[param1] as IconComponent;
      }
      
      private function handleIconClicked(param1:MouseEvent) : void
      {
         var _loc2_:IconComponent = this.getIconComponent(this.selectedIcon);
         if(_loc2_ != null)
         {
            _loc2_.setDeselected();
         }
         _loc2_ = IconComponent(param1.target);
         this.selectedIcon = _loc2_.id;
         _loc2_.setSelected();
         dispatchEvent(new Event(ICON_CLICKED));
      }
   }
}

