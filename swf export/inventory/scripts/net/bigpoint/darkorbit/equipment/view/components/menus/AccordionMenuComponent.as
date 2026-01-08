package net.bigpoint.darkorbit.equipment.view.components.menus
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Quart;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.events.MenuEvent;
   import net.bigpoint.darkorbit.equipment.model.AssetProxy;
   import net.bigpoint.darkorbit.equipment.view.components.AccordionView;
   import net.bigpoint.darkorbit.equipment.view.components.buttons.ExpandCollapseButton;
   import net.bigpoint.darkorbit.equipment.view.components.items.AccordionButtonComponent;
   import net.bigpoint.darkorbit.equipment.view.components.scroller.ScrollBar;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.TooltipControl;
   import net.bigpoint.darkorbit.equipment.view.managers.FocusManager;
   import net.bigpoint.darkorbit.equipment.view.managers.IFocusable;
   import net.bigpoint.utils.PredefinedFilters;
   
   public class AccordionMenuComponent extends Sprite implements IFocusable
   {
      
      public var menuList:Array;
      
      private var menuAssets:Array;
      
      public var menuButtonComponents:Dictionary = new Dictionary();
      
      private var buttonSubContainer:Sprite = new Sprite();
      
      public var selectedMenu:int = -1;
      
      public var menuName:String;
      
      public var expandCollapseButton:ExpandCollapseButton;
      
      public var associatedView:Sprite;
      
      private var associatedScroller:ScrollBar;
      
      private var shadowClip:Sprite;
      
      public const TWEEN_SPEED:Number = 0.3;
      
      private var offSetY:Number;
      
      private var offSetX:Number;
      
      private var sectionName:String;
      
      private var allExpanded:Boolean = false;
      
      private var fullAccordionMask:Sprite;
      
      private var menuSectionToMaskOthers:AccordionButtonComponent;
      
      private var toolTipControl:TooltipControl = TooltipControl.getInstance();
      
      public function AccordionMenuComponent(param1:String, param2:Array, param3:Sprite, param4:String, param5:Number = 0, param6:Number = 0)
      {
         super();
         this.sectionName = param4;
         this.menuName = param1;
         this.menuList = param2;
         this.associatedView = param3;
         this.offSetY = param5;
         this.offSetX = param6;
         this.shadowClip = new Sprite();
         this.shadowClip.filters = [new GlowFilter(0,0.6,20,20,3,2)];
         this.shadowClip.addChild(this.buttonSubContainer);
         this.addChild(this.shadowClip);
         FocusManager.getInstance().add(this);
         this.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMoveEvent);
      }
      
      public function createAccordionMenu(param1:Array, param2:Array = null) : void
      {
         var _loc4_:MovieClip = null;
         var _loc5_:AccordionButtonComponent = null;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Number = NaN;
         this.fullAccordionMask = new Sprite();
         this.fullAccordionMask.graphics.beginFill(15728640,0.2);
         this.fullAccordionMask.mouseEnabled = false;
         this.fullAccordionMask.mouseChildren = false;
         this.menuList = param1;
         if(param2 != null)
         {
            this.menuList.push("");
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.menuList.length)
         {
            _loc4_ = AssetProxy.getMovieClip("scrollComponents","accordionBtn");
            _loc5_ = new AccordionButtonComponent(_loc4_,_loc3_,this.menuList[_loc3_]);
            _loc6_ = _loc5_.actualButtonHeight;
            if(param2 != null)
            {
               _loc8_ = param2[_loc3_];
               if(_loc8_)
               {
                  _loc7_ = "label_slotset_" + _loc8_;
                  _loc5_.clip.btnText.text = BPLocale.getItem(_loc7_);
               }
            }
            else
            {
               _loc8_ = this.menuList[_loc3_];
               if(_loc8_)
               {
                  _loc7_ = "label_slotset_" + _loc8_;
                  _loc5_.clip.btnText.text = BPLocale.getItem(_loc7_);
               }
            }
            if(_loc5_.clip.btnText.text == "")
            {
               _loc5_.alpha = 0;
            }
            _loc9_ = 1;
            _loc5_.clip.btnText.selectable = false;
            _loc5_.x = 0;
            _loc5_.y = _loc5_.originalY = _loc6_ * _loc3_;
            _loc5_.contentHeight = 10;
            _loc5_.contentHeight = _loc9_;
            _loc5_.createBackgroundLayer();
            this.addEventListeners(_loc5_.clip);
            this.buttonSubContainer.addChild(_loc5_);
            _loc5_.slotSetName = _loc5_.section;
            this.menuButtonComponents[_loc5_.section] = _loc5_;
            if(_loc3_ == this.menuList.length - 1)
            {
               _loc5_.createBottomButtonCover();
               this.menuSectionToMaskOthers = _loc5_;
            }
            _loc3_++;
         }
         this.fullAccordionMask.graphics.drawRect(0,0,this.buttonSubContainer.width,this.menuSectionToMaskOthers.y);
         this.fullAccordionMask.graphics.endFill();
         this.buttonSubContainer.mask = this.fullAccordionMask;
         this.changeFullMaskHeight(_loc5_.y);
         addChild(this.fullAccordionMask);
         this.associatedScroller = new ScrollBar(this.offSetY,19,this.associatedView.x + this.x,this.offSetY + 327,this);
         this.associatedScroller.name = "associatedScrollBar";
         this.createExpandCollapseButton();
         this.checkIfMenuIsInsideVisibleBounds();
         this.handleToggleExpandedState();
      }
      
      public function removeAccordionSection(param1:String) : void
      {
         this.reOrderAccordionSections(param1);
         var _loc2_:AccordionButtonComponent = this.menuButtonComponents[param1];
         if(this.buttonSubContainer.contains(_loc2_))
         {
            this.buttonSubContainer.removeChild(_loc2_);
         }
         delete this.menuButtonComponents[param1];
      }
      
      private function reOrderAccordionSections(param1:String) : void
      {
         var _loc6_:Number = NaN;
         var _loc8_:AccordionButtonComponent = null;
         var _loc9_:String = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:int = 0;
         var _loc2_:AccordionButtonComponent = this.menuButtonComponents[param1];
         var _loc3_:Number = _loc2_.originalY;
         var _loc4_:Number = _loc3_;
         var _loc5_:int = _loc2_.id;
         var _loc7_:int = 0;
         while(_loc7_ < this.buttonSubContainer.numChildren)
         {
            _loc8_ = AccordionButtonComponent(this.buttonSubContainer.getChildAt(_loc7_));
            if(_loc2_ != _loc8_)
            {
               _loc9_ = _loc8_.section;
               _loc10_ = _loc8_.originalY;
               if(_loc4_ < _loc10_)
               {
                  _loc11_ = _loc8_.originalY;
                  _loc12_ = _loc8_.id;
                  _loc8_.originalY = _loc8_.y = _loc4_;
                  _loc4_ = _loc11_;
                  _loc8_.id = _loc5_;
                  _loc5_ = _loc12_;
                  if(_loc8_.clip.btnText.text != "")
                  {
                     _loc6_ = _loc4_;
                  }
               }
            }
            _loc7_++;
         }
         this.forceExpandAllMenuSections();
         TweenMax.delayedCall(this.TWEEN_SPEED * 1.5,this.expandAllMenuSections);
      }
      
      public function createExpandCollapseButton() : void
      {
         this.expandCollapseButton = new ExpandCollapseButton();
         this.toolTipControl.addToolTip(this.expandCollapseButton,BPLocale.getItem("tooltip_expand_collapse_button"));
         this.expandCollapseButton.addListeners();
         this.expandCollapseButton.addClickListener();
         this.expandCollapseButton.addEventListener(MouseEvent.CLICK,this.handleToggleExpandedState);
         this.associatedView.addChild(this.expandCollapseButton);
         this.expandCollapseButton.x = this.associatedScroller.scrollBarExternalXPos - 1;
         this.expandCollapseButton.y = 67;
      }
      
      private function handleToggleExpandedState(param1:MouseEvent = null) : void
      {
         this.expandCollapseButton.switchButtonMode();
         if(this.allExpanded)
         {
            this.collapseAllMenuSections();
            this.allExpanded = false;
         }
         else
         {
            this.expandAllMenuSections();
            this.allExpanded = true;
         }
      }
      
      public function defineEquippableAreas(param1:Dictionary) : void
      {
         var _loc2_:String = null;
         var _loc3_:AccordionButtonComponent = null;
         for(_loc2_ in param1)
         {
            _loc3_ = this.menuButtonComponents[_loc2_];
            _loc3_.equippableSections = param1[_loc2_].acceptedItemGroups;
         }
      }
      
      public function defineEquippableDroneAreas(param1:Dictionary) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:AccordionButtonComponent = null;
         for(_loc2_ in param1)
         {
            _loc3_ = [];
            _loc4_ = this.menuButtonComponents[_loc2_];
            _loc3_ = _loc3_.concat(param1[_loc2_]["default"]["acceptedItemGroups"]);
            _loc3_ = _loc3_.concat(param1[_loc2_]["design"]["acceptedItemGroups"]);
            _loc4_.equippableSections = _loc3_;
         }
      }
      
      public function addToView() : void
      {
         this.associatedView.addChild(this);
         if(this.associatedScroller != null)
         {
            this.associatedView.addChild(this.associatedScroller);
            this.associatedView.addChild(this.expandCollapseButton);
         }
      }
      
      public function removeFromView() : void
      {
         if(this.associatedView.contains(this))
         {
            this.associatedView.removeChild(this);
         }
         if(this.associatedScroller != null)
         {
            if(this.associatedView.contains(this.expandCollapseButton))
            {
               this.associatedView.removeChild(this.expandCollapseButton);
            }
            if(this.associatedView.contains(this.associatedScroller))
            {
               this.associatedView.removeChild(this.associatedScroller);
            }
         }
      }
      
      private function addEventListeners(param1:DisplayObject) : void
      {
         param1.addEventListener(MouseEvent.CLICK,this.handleMenuItemClicked);
      }
      
      private function handleMenuItemClicked(param1:MouseEvent) : void
      {
         var _loc2_:AccordionButtonComponent = param1.currentTarget.parent as AccordionButtonComponent;
         this.selectedMenu = _loc2_.id;
         dispatchEvent(new MenuEvent(MenuEvent.EVENT_BUTTON_CLICKED,this.selectedMenu));
      }
      
      public function expandAllMenuSections() : void
      {
         var _loc2_:AccordionButtonComponent = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.buttonSubContainer.numChildren)
         {
            _loc2_ = AccordionButtonComponent(this.buttonSubContainer.getChildAt(_loc1_));
            if(!_loc2_.open)
            {
               TweenMax.delayedCall(this.TWEEN_SPEED,this.openOtherMenuSlot,[_loc2_.id]);
            }
            _loc1_++;
         }
         this.expandCollapseButton.gotoAndStop(2);
      }
      
      public function forceExpandAllMenuSections() : void
      {
         var _loc2_:AccordionButtonComponent = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.buttonSubContainer.numChildren)
         {
            _loc2_ = AccordionButtonComponent(this.buttonSubContainer.getChildAt(_loc1_));
            TweenMax.delayedCall(this.TWEEN_SPEED,this.openOtherMenuSlot,[_loc2_.id]);
            _loc1_++;
         }
         this.expandCollapseButton.gotoAndStop(2);
      }
      
      public function collapseAllMenuSections() : void
      {
         var _loc2_:AccordionButtonComponent = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.buttonSubContainer.numChildren)
         {
            _loc2_ = AccordionButtonComponent(this.buttonSubContainer.getChildAt(_loc1_));
            if(_loc2_.open)
            {
               TweenMax.delayedCall(this.TWEEN_SPEED,this.openOtherMenuSlot,[_loc2_.id]);
            }
            _loc1_++;
         }
         this.expandCollapseButton.gotoAndStop(1);
      }
      
      public function openOtherMenuSlot(param1:int) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc6_:AccordionButtonComponent = null;
         var _loc5_:AccordionButtonComponent;
         var _loc7_:AccordionButtonComponent = _loc5_ = AccordionButtonComponent(this.buttonSubContainer.getChildAt(param1));
         if(!_loc7_.open)
         {
            _loc7_.setOpen();
            _loc4_ = 0;
            while(_loc4_ < this.buttonSubContainer.numChildren)
            {
               _loc6_ = AccordionButtonComponent(this.buttonSubContainer.getChildAt(_loc4_));
               _loc6_.currentYPos = _loc6_.y;
               if(_loc6_.y > _loc7_.y)
               {
                  if(_loc7_.open)
                  {
                     _loc6_.currentYPos = _loc7_.currentYPos + _loc7_.height - 7;
                     TweenMax.to(_loc6_,this.TWEEN_SPEED,{
                        "y":_loc6_.currentYPos,
                        "ease":Quart.easeOut,
                        "onComplete":this.checkIfMenuIsInsideVisibleBounds
                     });
                  }
                  else
                  {
                     _loc6_.currentYPos = _loc7_.currentYPos + _loc7_.actualButtonHeight;
                     TweenMax.to(_loc6_,this.TWEEN_SPEED,{
                        "y":_loc6_.currentYPos,
                        "ease":Quart.easeOut,
                        "onComplete":this.checkIfMenuIsInsideVisibleBounds
                     });
                  }
                  _loc7_ = _loc6_;
               }
               _loc4_++;
            }
         }
         else
         {
            _loc7_.setClosed();
            _loc4_ = 0;
            while(_loc4_ < this.buttonSubContainer.numChildren)
            {
               _loc6_ = AccordionButtonComponent(this.buttonSubContainer.getChildAt(_loc4_));
               _loc6_.currentYPos = _loc6_.y;
               if(_loc6_.y > _loc7_.y)
               {
                  if(_loc7_.open)
                  {
                     _loc6_.currentYPos = _loc7_.currentYPos + _loc7_.height - 7;
                     TweenMax.to(_loc6_,this.TWEEN_SPEED,{
                        "y":_loc6_.currentYPos,
                        "ease":Quart.easeOut,
                        "onComplete":this.checkIfMenuIsInsideVisibleBounds
                     });
                  }
                  else
                  {
                     _loc6_.currentYPos = _loc7_.currentYPos + _loc7_.actualButtonHeight;
                     TweenMax.to(_loc6_,this.TWEEN_SPEED,{
                        "y":_loc6_.currentYPos,
                        "ease":Quart.easeOut,
                        "onComplete":this.checkIfMenuIsInsideVisibleBounds
                     });
                  }
                  _loc7_ = _loc6_;
               }
               _loc4_++;
            }
         }
         _loc2_ = _loc6_.currentYPos;
         this.changeFullMaskHeight(_loc2_);
         this.associatedScroller.checkScrollBarWithinBounds();
      }
      
      private function changeFullMaskHeight(param1:Number) : void
      {
         TweenMax.to(this.fullAccordionMask,this.TWEEN_SPEED / 1.5,{"height":param1});
      }
      
      private function checkIfMenuIsInsideVisibleBounds() : void
      {
         var _loc1_:Number = this.fullAccordionMask.height;
         var _loc2_:Boolean = this.associatedScroller.setScrollBarConditions(_loc1_);
         if(_loc2_)
         {
            TweenMax.to(this,this.TWEEN_SPEED,{
               "y":AccordionView.MENU_Y_OFFSET,
               "ease":Quart.easeOut
            });
            this.associatedScroller.resetAllElementsToStartingPositions(false);
         }
         this.associatedScroller.checkScrollBarWithinBounds();
      }
      
      public function setUIActivated(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:AccordionButtonComponent = null;
         if(this.associatedScroller)
         {
            this.associatedScroller.mouseEnabled = param1;
            this.associatedScroller.mouseChildren = param1;
            this.associatedScroller.visible = param1;
         }
         if(this.buttonSubContainer)
         {
            this.buttonSubContainer.mouseEnabled = param1;
            this.buttonSubContainer.mouseChildren = param1;
         }
         if(this.expandCollapseButton)
         {
            this.expandCollapseButton.mouseEnabled = param1;
            this.expandCollapseButton.mouseChildren = param1;
            if(param1)
            {
               TweenMax.to(this.expandCollapseButton,0.75,PredefinedFilters.TWEENMAX_COLORMATRIX_BLACKANDWHITE);
            }
            else
            {
               TweenMax.to(this.expandCollapseButton,0.75,PredefinedFilters.TWEENMAX_COLORMATRIX_BLACKANDWHITE);
            }
         }
         if(!param1)
         {
            _loc2_ = this.buttonSubContainer.numChildren;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = AccordionButtonComponent(this.buttonSubContainer.getChildAt(_loc3_));
               _loc4_.setOpen();
               _loc3_++;
            }
         }
      }
      
      private function handleMouseMoveEvent(param1:MouseEvent) : void
      {
         this.focusing();
      }
      
      public function focusing() : void
      {
         if(this.associatedScroller)
         {
            this.associatedScroller.isMouseWheelActivcated = true;
         }
      }
      
      public function unfocusing() : void
      {
         if(this.associatedScroller)
         {
            this.associatedScroller.isMouseWheelActivcated = false;
         }
      }
   }
}

