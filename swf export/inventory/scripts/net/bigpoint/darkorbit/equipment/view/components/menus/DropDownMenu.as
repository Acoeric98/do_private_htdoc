package net.bigpoint.darkorbit.equipment.view.components.menus
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Quart;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.utils.Dictionary;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.model.AssetProxy;
   import net.bigpoint.darkorbit.equipment.model.UILayoutProxy;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInfoVO;
   import net.bigpoint.darkorbit.equipment.model.managers.ItemInfoManager;
   import net.bigpoint.darkorbit.equipment.view.components.buttons.ConfigButton;
   import net.bigpoint.darkorbit.equipment.view.components.buttons.DropDownButton;
   import net.bigpoint.darkorbit.equipment.view.components.items.InventoryLargeItemComponent;
   import net.bigpoint.darkorbit.equipment.view.components.scroller.ScrollBar;
   import net.bigpoint.darkorbit.equipment.view.managers.FocusManager;
   import net.bigpoint.darkorbit.equipment.view.managers.IFocusable;
   
   public class DropDownMenu extends Sprite implements IFocusable
   {
      
      private static const logger:ILogger = Log.getLogger("DropDownMenu");
      
      public static const EVENT_SELECTION_CHANGED:String = "eventSelectionChanged";
      
      public var numberOfButtons:int = 0;
      
      public var defaultButtonText:String;
      
      public var mainDropDownButton:DropDownButton;
      
      public var buttons:Dictionary = new Dictionary();
      
      public var menuBackground:Sprite = new Sprite();
      
      private var toggleMenuButton:ConfigButton = new ConfigButton(0);
      
      private var menuDisplay:Sprite = new Sprite();
      
      private var menuVisibility:Boolean = false;
      
      private var menuBgBitmapData:BitmapData;
      
      private var initFinished:Boolean = false;
      
      private var designMiniGraphic:InventoryLargeItemComponent = new InventoryLargeItemComponent();
      
      private var currentSelectedDropDownButton:DropDownButton;
      
      private var miniPopUp:Sprite;
      
      private var dropDownButtonCallback:Function;
      
      private var scrollBar:ScrollBar;
      
      private var scrollContainer:Sprite;
      
      public const DROPDOWN_BUTTON_HEIGHT:Number = 22;
      
      public var maxContentHeight:Number = 220;
      
      public function DropDownMenu()
      {
         super();
      }
      
      public function createDropDownFromDictionary(param1:Dictionary, param2:String = null, param3:Boolean = false) : void
      {
         if(this.initFinished)
         {
            return;
         }
         this.menuBgBitmapData = AssetProxy.getBitmapData("scrollComponents","dropDownBackground.png");
         this.checkAndSetDefaultButtonText(param2,param1,param3);
         this.createMainDropButton(param2);
         this.createScrollContainer();
         this.createMenu(param1,param3);
         this.createMenuDisplayMask();
         this.createScrollbar();
         this.initFinished = true;
      }
      
      private function checkAndSetDefaultButtonText(param1:String, param2:Dictionary, param3:Boolean) : void
      {
         var _loc4_:String = null;
         if(param1)
         {
            for(_loc4_ in param2)
            {
               if(param2[_loc4_] == param1)
               {
                  this.defaultButtonText = _loc4_;
                  if(param3)
                  {
                     this.defaultButtonText = BPLocale.getItem(this.defaultButtonText);
                  }
                  break;
               }
            }
         }
      }
      
      private function createMainDropButton(param1:String) : void
      {
         if(this.defaultButtonText == null)
         {
            this.mainDropDownButton = new DropDownButton("DEFAULT","filterDropDown");
         }
         else
         {
            this.mainDropDownButton = new DropDownButton(this.defaultButtonText,"filterDropDown");
         }
         this.mainDropDownButton.x = 0;
         this.mainDropDownButton.y = 0;
         this.mainDropDownButton.buttonKey = param1;
         this.mainDropDownButton.addListeners();
         this.mainDropDownButton.addClickListener();
         this.mainDropDownButton.addEventListener(MouseEvent.CLICK,this.toggleMenuVisibility);
         addChild(this.mainDropDownButton);
         this.currentSelectedDropDownButton = this.mainDropDownButton;
      }
      
      private function createScrollContainer() : void
      {
         this.scrollContainer = new Sprite();
         this.addChild(this.scrollContainer);
         this.scrollContainer.y = this.mainDropDownButton.y + this.mainDropDownButton.height;
         this.scrollContainer.addChild(this.menuBackground);
         var _loc1_:DropShadowFilter = new DropShadowFilter();
         _loc1_.angle = 45;
         _loc1_.alpha = 1;
         _loc1_.color = 1118481;
         _loc1_.blurX = 8;
         _loc1_.blurY = 8;
         _loc1_.quality = 3;
         _loc1_.distance = 9;
         this.scrollContainer.filters = [_loc1_];
      }
      
      private function createMenu(param1:Dictionary, param2:Boolean) : void
      {
         var _loc6_:String = null;
         var _loc7_:DropDownButton = null;
         var _loc8_:String = null;
         this.menuDisplay = new Sprite();
         this.menuDisplay.visible = false;
         var _loc3_:Array = this.sortButtonKeyList(param1);
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc6_ = _loc3_[_loc5_];
            if(param2)
            {
               _loc8_ = BPLocale.getItem(_loc6_);
               _loc7_ = new DropDownButton(_loc8_,"filterButton");
            }
            else
            {
               _loc7_ = new DropDownButton(_loc6_,"filterButton");
            }
            this.buttons[_loc6_] = _loc7_;
            this.menuDisplay.addChild(_loc7_);
            _loc7_.buttonKey = param1[_loc6_];
            _loc7_.filterKey = _loc6_;
            _loc7_.data = param1[_loc6_];
            _loc7_.addListeners();
            _loc7_.x = 22;
            _loc7_.y = (this.mainDropDownButton.y + this.mainDropDownButton.height) * _loc4_;
            ++this.numberOfButtons;
            _loc4_++;
            _loc5_++;
         }
         this.scrollContainer.addChild(this.menuDisplay);
         this.menuDisplay.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMoveEvent);
      }
      
      private function handleMouseMoveEvent(param1:MouseEvent) : void
      {
         FocusManager.getInstance().setFocus(this);
      }
      
      private function createMenuDisplayMask() : void
      {
         var _loc1_:Number = NaN;
         if(this.isScrollbarVisible())
         {
            _loc1_ = 176;
         }
         else
         {
            _loc1_ = 193;
         }
         var _loc2_:Number = this.calculateContentHeight() - 2;
         var _loc3_:Sprite = new Sprite();
         var _loc4_:Graphics = _loc3_.graphics;
         _loc4_.clear();
         _loc4_.beginFill(16711680);
         _loc4_.drawRect(0,1,_loc1_,_loc2_);
         _loc4_.endFill();
         this.scrollContainer.addChild(_loc3_);
         this.menuDisplay.mask = _loc3_;
      }
      
      private function createScrollbar() : void
      {
         var _loc1_:Number = NaN;
         if(this.isScrollbarVisible())
         {
            _loc1_ = this.calculateContentHeight();
            this.scrollBar = new ScrollBar(this.menuDisplay.y + 1,0,this.menuDisplay.x + 5,_loc1_ - 2,this.menuDisplay);
            this.scrollContainer.addChild(this.scrollBar);
            this.scrollBar.visible = false;
         }
      }
      
      private function sortButtonKeyList(param1:Dictionary) : Array
      {
         var _loc3_:String = null;
         var _loc2_:Array = [];
         for(_loc3_ in param1)
         {
            _loc2_.push(_loc3_);
         }
         _loc2_.sort(Array.CASEINSENSITIVE);
         return _loc2_;
      }
      
      public function addButtonCallbackFunction(param1:Function) : void
      {
         var _loc2_:String = null;
         var _loc3_:DropDownButton = null;
         this.dropDownButtonCallback = param1;
         for(_loc2_ in this.buttons)
         {
            _loc3_ = this.buttons[_loc2_];
            _loc3_.addEventListener(MouseEvent.CLICK,this.handleDropDownMouseButtonClicked);
            _loc3_.addEventListener(MouseEvent.CLICK,param1);
         }
      }
      
      public function addRollOverFunction() : void
      {
         var _loc1_:String = null;
         var _loc2_:DropDownButton = null;
         for(_loc1_ in this.buttons)
         {
            _loc2_ = this.buttons[_loc1_];
            _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.handleButtonRollover);
         }
      }
      
      public function handleButtonRollover(param1:MouseEvent) : void
      {
         var _loc2_:DropDownButton = DropDownButton(param1.currentTarget);
         var _loc3_:String = _loc2_.buttonKey;
         var _loc4_:Array = _loc3_.split("_");
         var _loc5_:String = _loc4_.pop();
         var _loc6_:ItemInfoManager = ItemInfoManager.getInstance();
         var _loc7_:ItemInfoVO = _loc6_.getItemInfo(_loc3_);
         if(_loc7_.factionDepended == "1")
         {
            _loc5_ += "-" + _loc7_.factionID;
         }
         this.designMiniGraphic.changeLargeGraphic(_loc5_);
         var _loc8_:Number = _loc2_.y + this.mainDropDownButton.height + _loc2_.height / 2;
         _loc8_ = _loc8_ - this.getScrollbarPosition();
         TweenMax.to(this.miniPopUp,0.2,{
            "y":_loc8_,
            "alpha":1
         });
      }
      
      private function getScrollbarPosition() : Number
      {
         var _loc1_:Number = 0;
         if(this.scrollBar)
         {
            _loc1_ = this.scrollBar.movement;
         }
         return _loc1_;
      }
      
      private function handleDropDownMouseButtonClicked(param1:MouseEvent) : void
      {
         this.changeCurrentlyDisplayedFilterName(DropDownButton(param1.currentTarget));
         this.toggleMenuVisibility();
      }
      
      public function createPopUpDisplay() : void
      {
         this.miniPopUp = AssetProxy.getMovieClip("scrollComponents","designSelectionPopup");
         this.miniPopUp.alpha = 0;
         this.miniPopUp.x = this.mainDropDownButton.x + this.mainDropDownButton.width;
         this.miniPopUp.addChild(this.designMiniGraphic);
         this.designMiniGraphic.x = UILayoutProxy.DESIGN_GRAPHIC_INSIDE_MENU_POPUP_X;
         this.designMiniGraphic.y = UILayoutProxy.DESIGN_GRAPHIC_INSIDE_MENU_POPUP_Y;
      }
      
      private function changeCurrentlyDisplayedFilterName(param1:DropDownButton) : void
      {
         this.currentSelectedDropDownButton = param1;
         this.mainDropDownButton.buttonGraphic.btnText.text = this.currentSelectedDropDownButton.buttonText.toUpperCase();
      }
      
      public function getCurrentSelectedDropDownButton() : DropDownButton
      {
         return this.currentSelectedDropDownButton;
      }
      
      public function setSelectionBy(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc3_:DropDownButton = null;
         for(_loc2_ in this.buttons)
         {
            if(_loc2_ == param1)
            {
               _loc3_ = this.buttons[_loc2_];
               this.changeCurrentlyDisplayedFilterName(_loc3_);
               this.toggleMenuVisibility();
               dispatchEvent(new Event(EVENT_SELECTION_CHANGED));
            }
         }
      }
      
      public function changeCurrentlySelectedItem(param1:String) : void
      {
         this.mainDropDownButton.buttonGraphic.btnText.text = param1;
      }
      
      private function toggleMenuVisibility(param1:MouseEvent = null) : void
      {
         FocusManager.getInstance().setFocus(this);
         switch(this.menuVisibility)
         {
            case true:
               this.hideMenu();
               break;
            case false:
               this.showMenu();
         }
      }
      
      private function showMenu() : void
      {
         this.menuVisibility = true;
         this.menuDisplay.visible = true;
         if(this.scrollBar)
         {
            this.scrollBar.visible = true;
         }
         if(this.miniPopUp != null)
         {
            addChild(this.miniPopUp);
         }
         var _loc1_:Number = this.calculateContentHeight();
         this.menuBackground.graphics.beginBitmapFill(this.menuBgBitmapData);
         this.menuBackground.graphics.lineStyle(1,8421504);
         this.menuBackground.graphics.drawRect(0,0,this.menuBgBitmapData.width,_loc1_);
         this.menuBackground.graphics.endFill();
         this.menuBackground.x = 21;
         TweenMax.to(this.menuBackground,0.15,{
            "height":_loc1_,
            "ease":Quart.easeOut
         });
      }
      
      private function hideMenu() : void
      {
         this.menuVisibility = false;
         this.menuDisplay.visible = false;
         if(this.scrollBar)
         {
            this.scrollBar.visible = false;
         }
         if(this.miniPopUp != null)
         {
            if(contains(this.miniPopUp))
            {
               removeChild(this.miniPopUp);
            }
         }
         TweenMax.to(this.menuBackground,0.15,{
            "height":0,
            "ease":Quart.easeOut,
            "onComplete":this.removeMenuBackground
         });
      }
      
      protected function calculateContentHeight() : Number
      {
         var _loc1_:Number = this.calculateBackgroundHeight();
         return this.maxContentHeight > _loc1_ ? _loc1_ : this.maxContentHeight;
      }
      
      protected function isScrollbarVisible() : Boolean
      {
         var _loc1_:Number = this.calculateBackgroundHeight();
         return this.maxContentHeight > _loc1_ ? false : true;
      }
      
      private function calculateBackgroundHeight() : Number
      {
         return this.DROPDOWN_BUTTON_HEIGHT * this.numberOfButtons;
      }
      
      public function closeMenuOnly() : void
      {
         if(this.menuVisibility)
         {
            this.menuDisplay.visible = false;
            if(this.scrollBar)
            {
               this.scrollBar.visible = false;
            }
            if(this.miniPopUp != null)
            {
               if(contains(this.miniPopUp))
               {
                  removeChild(this.miniPopUp);
               }
            }
            TweenMax.to(this.menuBackground,0.15,{
               "height":0,
               "ease":Quart.easeOut,
               "onComplete":this.removeMenuBackground
            });
            this.menuVisibility = false;
         }
      }
      
      private function removeMenuBackground() : void
      {
         this.menuBackground.graphics.clear();
      }
      
      public function activate() : void
      {
         this.mouseEnabled = true;
         this.mouseChildren = true;
      }
      
      public function deactivate() : void
      {
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      public function focusing() : void
      {
         if(this.scrollBar)
         {
            this.scrollBar.isMouseWheelActivcated = true;
         }
      }
      
      public function unfocusing() : void
      {
         if(this.scrollBar)
         {
            this.scrollBar.isMouseWheelActivcated = false;
         }
         this.closeMenuOnly();
      }
   }
}

