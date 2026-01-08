package net.bigpoint.darkorbit.equipment.view.components.items
{
   import com.greensock.TweenMax;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.equipment.events.ActionIdentifiers;
   import net.bigpoint.darkorbit.equipment.events.InventoryEvent;
   import net.bigpoint.darkorbit.equipment.events.ItemEvent;
   import net.bigpoint.darkorbit.equipment.events.MoveItemEvent;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.model.VO.Config;
   import net.bigpoint.darkorbit.equipment.model.VO.Equipment;
   import net.bigpoint.darkorbit.equipment.model.VO.slot.SlotSetVO;
   import net.bigpoint.darkorbit.equipment.model.managers.ConfigManager;
   import net.bigpoint.darkorbit.equipment.model.transporter.Transporter;
   import net.bigpoint.darkorbit.equipment.view.components.AccordionView;
   import net.bigpoint.darkorbit.equipment.view.components.InventoryView;
   import net.bigpoint.darkorbit.equipment.view.components.interfaces.IMenuComponent;
   import net.bigpoint.darkorbit.equipment.view.components.interfaces.IMenuView;
   import net.bigpoint.darkorbit.equipment.view.components.menus.AccordionMenuComponent;
   import net.bigpoint.dataInterchange.DataInterchange;
   
   public class DragComponent extends Sprite
   {
      
      private static var _instance:DragComponent;
      
      public var collisionViews:Array = [];
      
      public var currentDraggedIcon:InventoryItemComponent;
      
      public var selectedItem:InventoryItemComponent;
      
      public var currentSelectedItem:InventoryItemComponent;
      
      public var previouslySelectedItem:InventoryItemComponent;
      
      public var multiSelection:Array;
      
      private var currentDraggedIconProxy:InventoryItemComponent;
      
      private var hoveredSection:AccordionButtonComponent;
      
      private var hoveredSections:Array = [];
      
      private var movingMouseCallBack:Function = null;
      
      private var multiSelector:MultiSelectionComponent;
      
      private var hoveredSectionSlotSet:String;
      
      private var _controlButtonDown:Boolean = false;
      
      private var _shiftButtonDown:Boolean = false;
      
      private var startDragX:int = 0;
      
      private var startDragY:int = 0;
      
      private var mouseDown:Boolean = false;
      
      public function DragComponent(param1:Function)
      {
         super();
         if(param1 != hidden)
         {
            throw new Error("DragComponent is a Singleton and can only be accessed through DragComponent.getInstance()");
         }
         this.multiSelector = MultiSelectionComponent.getInstance();
         this.multiSelector.dragComp = this;
      }
      
      private static function hidden() : void
      {
      }
      
      public static function getInstance() : DragComponent
      {
         if(_instance == null)
         {
            _instance = new DragComponent(hidden);
         }
         return _instance;
      }
      
      public function addDraggableIcon(param1:InventoryItemComponent) : void
      {
         this.createListeners(param1);
      }
      
      public function removeDraggableIcon(param1:InventoryItemComponent) : void
      {
         this.removeListeners(param1);
      }
      
      public function addCollisionView(param1:IMenuView) : void
      {
         this.collisionViews.push(param1);
      }
      
      private function createListeners(param1:InventoryItemComponent) : void
      {
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.handleObjectClicked);
      }
      
      private function removeListeners(param1:InventoryItemComponent) : void
      {
         param1.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleObjectClicked);
      }
      
      private function handleObjectClicked(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = param1.currentTarget as Sprite;
         this.selectTarget(_loc2_);
      }
      
      public function selectTarget(param1:Sprite) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:uint = 0;
         var _loc7_:GridComponent = null;
         var _loc8_:Array = null;
         var _loc9_:InventoryItemComponent = null;
         var _loc10_:Object = null;
         this.currentDraggedIcon = param1 as InventoryItemComponent;
         if(this._controlButtonDown && this.currentDraggedIcon != null)
         {
            if(!this.currentDraggedIcon.buyableExtraSlot)
            {
               this.quickMoveItem(param1);
               return;
            }
         }
         if(this.multiSelector.shiftButtonDown)
         {
            this._shiftButtonDown = true;
         }
         if(param1 is InventoryItemComponent)
         {
            this.currentSelectedItem = param1 as InventoryItemComponent;
         }
         if(this.previouslySelectedItem != null)
         {
            this.previouslySelectedItem.setDeselected();
         }
         this.currentDraggedIcon.setSelected();
         this.selectedItem = this.currentDraggedIcon;
         if(Boolean(this.multiSelection) && !this.currentIconIsPartOfSelection())
         {
            this.multiSelection = [];
            this.multiSelector.removeSelectedStatusFromAllItems();
         }
         dispatchEvent(new InventoryEvent(InventoryEvent.CHECK_INVENTORY_CONTEXT_BUTTON));
         dispatchEvent(new InventoryEvent(InventoryEvent.UPDATE_SELL_BUTTON));
         if(!this.currentDraggedIcon.buyableExtraSlot)
         {
            if(this._shiftButtonDown)
            {
               this.multiSelector.removeSelectedStatusFromAllItems();
               dispatchEvent(new ItemEvent(ItemEvent.ITEM_MULTISELECTED,this.selectedItem.itemID,this.selectedItem.itemName));
            }
            else
            {
               this.multiSelector.removeSelectedStatusFromAllItems();
               this.currentDraggedIcon.setSelected();
               dispatchEvent(new ItemEvent(ItemEvent.ITEM_SELECTED,this.currentDraggedIcon.itemID));
            }
         }
         if(this.currentDraggedIcon.isLargeIcon)
         {
            this.previouslySelectedItem = this.currentDraggedIcon;
            return;
         }
         this.multiSelector.removeListeners();
         if(this.currentDraggedIcon.buyableExtraSlot)
         {
            this.previouslySelectedItem = this.currentDraggedIcon;
            _loc6_ = uint(this.currentDraggedIcon.indexInGrid);
            _loc7_ = this.currentDraggedIcon.menuSectionComponent as GridComponent;
            _loc8_ = _loc7_.iconsInThisMenu;
            if(_loc6_ > 0)
            {
               _loc9_ = _loc8_[_loc6_ - 1];
               if(!(_loc9_.buyableExtraSlot == false && this.currentDraggedIcon.buyableExtraSlot == true))
               {
                  return;
               }
            }
            _loc10_ = new Object();
            _loc10_.slotset = _loc7_.getParent().section.toLowerCase();
            _loc10_.target = _loc7_.getContainingViewID();
            switch(_loc10_.slotset)
            {
               case ActionIdentifiers.GEARS:
                  _loc10_.slotPrice = Settings.PET_GEAR_SLOT_PRICES[_loc6_];
                  break;
               case ActionIdentifiers.LASERS:
                  _loc10_.slotPrice = Settings.PET_LASER_SLOT_PRICES[_loc6_];
                  break;
               case ActionIdentifiers.GENERATORS:
                  _loc10_.slotPrice = Settings.PET_GENERATOR_SLOT_PRICES[_loc6_];
                  break;
               case ActionIdentifiers.PROTCOLS:
                  _loc10_.slotPrice = Settings.PET_PROTOCOL_SLOT_PRICES[_loc6_];
            }
            _loc10_.action = ActionIdentifiers.BUY_SLOT;
            dispatchEvent(new InventoryEvent(InventoryEvent.BUYABLE_SLOT_CLICKED,_loc10_));
            return;
         }
         this.currentDraggedIconProxy = this.makeProxyDragObject(this.currentDraggedIcon);
         this.currentDraggedIconProxy.addEventListener(MouseEvent.MOUSE_UP,this.handleObjectReleased);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.handleObjectReleased);
         if(this.multiSelection != null)
         {
            if(this.multiSelection.length > 1 && this.currentIconIsPartOfSelection())
            {
               this.currentDraggedIconProxy.addStackUnderlay();
            }
         }
         else
         {
            this.multiSelector.resetAllIconsSelectedStatus();
            this.currentDraggedIcon.setSelected();
         }
         if(this.currentDraggedIconProxy.menuSectionComponent.getGridRearranger() != null)
         {
            this.currentDraggedIconProxy.menuSectionComponent.getGridRearranger().defineGrabbedIcon(this.currentDraggedIconProxy,this.currentDraggedIcon);
            this.mouseDown = true;
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMoved);
            stage.addEventListener(Event.ENTER_FRAME,this.handleEnterFrameEvent);
         }
         this.currentDraggedIconProxy.alpha = 0.6;
         var _loc2_:Number = this.currentDraggedIcon.x;
         var _loc3_:Number = this.currentDraggedIcon.y;
         if(this.currentDraggedIcon.menuSectionComponent.getParent() is AccordionButtonComponent)
         {
            _loc4_ = this.currentDraggedIcon.menuSectionComponent.getParent().x + this.currentDraggedIcon.menuSectionComponent.getParent().parent.parent.parent.x;
            _loc5_ = this.currentDraggedIcon.menuSectionComponent.getParent().y + this.currentDraggedIcon.menuSectionComponent.getParent().parent.parent.parent.y;
         }
         else
         {
            _loc4_ = this.currentDraggedIcon.menuSectionComponent.getX();
            _loc5_ = this.currentDraggedIcon.menuSectionComponent.getY();
         }
         this.startDragX = _loc2_ + _loc4_;
         this.startDragY = _loc3_ + _loc5_;
         this.startDelayedIconProxyDrag();
      }
      
      private function startDelayedIconProxyDrag() : void
      {
         this.currentDraggedIconProxy.startDrag();
         this.parent.addChild(this.currentDraggedIconProxy);
         this.currentDraggedIconProxy.mouseEnabled = false;
         this.currentDraggedIconProxy.mouseChildren = false;
         this.currentDraggedIconProxy.x = this.startDragX;
         this.currentDraggedIconProxy.y = this.startDragY;
      }
      
      private function sortItems(param1:Dictionary, param2:Array, param3:String) : Array
      {
         var _loc6_:Equipment = null;
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         while(_loc5_ < param2.length)
         {
            _loc6_ = this.getItem(param1,param2[_loc5_],param3);
            if(_loc6_)
            {
               _loc4_.push(_loc6_);
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      private function getItem(param1:Dictionary, param2:String, param3:String) : Equipment
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         for(_loc4_ in param1)
         {
            _loc5_ = _loc4_.substr(0,5);
            if(_loc5_ == param3)
            {
               _loc6_ = _loc4_.substr(param3.length + 1,_loc4_.length - 1);
               if(_loc6_ == param2)
               {
                  return param1[_loc4_];
               }
            }
         }
         return null;
      }
      
      private function quickMoveItem(param1:Sprite) : void
      {
         var _loc3_:Array = null;
         var _loc5_:IMenuView = null;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc2_:Sprite = param1;
         this.currentDraggedIcon = InventoryItemComponent(_loc2_);
         this.currentDraggedIconProxy = this.makeProxyDragObject(this.currentDraggedIcon);
         var _loc4_:Transporter = new Transporter();
         var _loc8_:int = 0;
         while(_loc8_ < this.collisionViews.length)
         {
            if(this.currentDraggedIconProxy.hitTestObject(DisplayObject((this.collisionViews[_loc8_] as IMenuView).getActualCollisionRegion())))
            {
               _loc5_ = this.collisionViews[_loc8_];
               _loc6_ = _loc5_.getCurrentlyOpenMenu();
               break;
            }
            _loc8_++;
         }
         switch(_loc6_)
         {
            case ActionIdentifiers.DRONES:
               this.handleMultiSectionQuickMove(_loc5_,_loc4_);
               break;
            default:
               this.handleOnlyOneSectionQuickMove(_loc5_,_loc7_,_loc3_,_loc4_);
         }
      }
      
      private function handleMultiSectionQuickMove(param1:IMenuView, param2:Transporter) : void
      {
         var _loc6_:AccordionView = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:AccordionMenuComponent = null;
         var _loc10_:Array = null;
         var _loc11_:Object = null;
         var _loc12_:String = null;
         var _loc13_:Config = null;
         var _loc14_:Array = null;
         var _loc15_:int = 0;
         var _loc16_:String = null;
         var _loc17_:int = 0;
         var _loc18_:Equipment = null;
         var _loc19_:SlotSetVO = null;
         var _loc20_:String = null;
         var _loc21_:int = 0;
         var _loc22_:Array = null;
         var _loc23_:int = 0;
         var _loc24_:String = null;
         param2 = new Transporter();
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         if(param1 is AccordionView)
         {
            _loc6_ = param1 as AccordionView;
            _loc7_ = _loc6_.numChildren;
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc9_ = _loc6_.getChildAt(_loc8_) as AccordionMenuComponent;
               if(_loc9_)
               {
                  _loc10_ = _loc9_.menuList;
                  _loc4_ = _loc4_.concat(_loc10_);
               }
               _loc8_++;
            }
         }
         var _loc5_:String = this.currentDraggedIcon.menuSectionComponent.getContainingViewID();
         switch(_loc5_)
         {
            case Settings.INVENTORY_NAME:
               if(this.multiSelection != null)
               {
                  if(this.currentIconIsPartOfSelection())
                  {
                     _loc3_ = this.returnItemIDs(this.multiSelection);
                  }
                  else
                  {
                     _loc3_ = this.returnItemIDs([this.currentDraggedIcon]);
                  }
               }
               else
               {
                  _loc3_ = this.returnItemIDs([this.currentDraggedIcon]);
               }
               _loc11_ = {};
               _loc12_ = this.currentDraggedIconProxy.group;
               _loc13_ = ConfigManager.getInstance().configs[Settings.activeConfig];
               _loc14_ = this.sortItems(_loc13_.equipments,_loc10_,"drone");
               _loc15_ = int(_loc14_.length);
               _loc17_ = 0;
               while(_loc17_ < _loc15_)
               {
                  _loc18_ = _loc14_[_loc17_];
                  _loc20_ = _loc18_.name.substr(6,_loc18_.name.length - 1);
                  if(_loc12_ == DataInterchange.DRONE_DESIGN_TYPE_CLASS)
                  {
                     _loc19_ = _loc18_.slotSets[DataInterchange.DESIGN];
                  }
                  else
                  {
                     _loc19_ = _loc18_.slotSets[DataInterchange.DEFAULT];
                  }
                  _loc21_ = _loc19_.maxSlotCount - _loc19_.items.length;
                  if(_loc21_ > 0)
                  {
                     _loc22_ = [];
                     _loc23_ = 0;
                     while(_loc23_ < _loc21_)
                     {
                        if(_loc3_.length > 0)
                        {
                           _loc24_ = _loc3_.pop();
                           _loc22_.push(_loc24_);
                        }
                        _loc23_++;
                     }
                     _loc11_[_loc20_] = _loc22_;
                  }
                  _loc17_++;
               }
               param2.action = ActionIdentifiers.DRONE_EQUIP;
               param2.from["configId"] = Settings.activeConfig;
               param2.from["target"] = this.currentDraggedIcon.menuSectionComponent.getContainingViewID().toLowerCase();
               param2.from["droneItems"] = _loc11_;
               param2.to["configId"] = Settings.activeConfig;
               param2.to["target"] = param1.getCurrentlyOpenMenu().toLowerCase();
               _loc16_ = this.currentDraggedIconProxy.group == DataInterchange.DRONE_DESIGN_TYPE_CLASS ? DataInterchange.DESIGN : DataInterchange.DEFAULT;
               param2.to["slotset"] = _loc16_;
               dispatchEvent(new MoveItemEvent(MoveItemEvent.ITEMS_MOVED_TO_N_DRONE_EQUIPMENT,param2));
               break;
            case ActionIdentifiers.DRONES:
               this.handleOnlyOneSectionQuickMove(param1,[],[],param2);
         }
      }
      
      private function handleOnlyOneSectionQuickMove(param1:IMenuView, param2:Array, param3:Array, param4:Transporter) : void
      {
         var _loc6_:AccordionView = null;
         var _loc7_:int = 0;
         var _loc8_:AccordionMenuComponent = null;
         var _loc9_:Config = null;
         var _loc10_:Array = null;
         var _loc11_:int = 0;
         var _loc12_:Equipment = null;
         var _loc13_:SlotSetVO = null;
         var _loc14_:String = null;
         if(Settings.inventoryOpen)
         {
            return;
         }
         if(param1 is AccordionView)
         {
            _loc6_ = param1 as AccordionView;
            _loc7_ = 0;
            while(_loc7_ < _loc6_.numChildren)
            {
               if(_loc6_.getChildAt(_loc7_) is AccordionMenuComponent)
               {
                  _loc8_ = _loc6_.getChildAt(_loc7_) as AccordionMenuComponent;
                  param2 = _loc8_.menuList;
                  break;
               }
               _loc7_++;
            }
         }
         if(!Settings.inventoryOpen)
         {
            this.highlightPossibleDropAreas(this.currentDraggedIconProxy.group,param1);
         }
         var _loc5_:String = this.currentDraggedIcon.menuSectionComponent.getContainingViewID();
         loop3:
         switch(_loc5_)
         {
            case Settings.INVENTORY_NAME:
               if(this.multiSelection != null)
               {
                  if(this.currentIconIsPartOfSelection())
                  {
                     param3 = this.returnItemIDs(this.multiSelection);
                  }
                  else
                  {
                     param3 = this.returnItemIDs([this.currentDraggedIcon]);
                  }
               }
               else
               {
                  param3 = this.returnItemIDs([this.currentDraggedIcon]);
               }
               param4.from["configId"] = Settings.activeConfig;
               param4.to["configId"] = Settings.activeConfig;
               param4.from["target"] = this.currentDraggedIcon.menuSectionComponent.getContainingViewID().toLowerCase();
               param4.from["items"] = param3;
               param4.to["target"] = param1.getCurrentlyOpenMenu().toLowerCase();
               param4.action = ActionIdentifiers.MOVE;
               if(param1.getCurrentlyOpenMenu() == ActionIdentifiers.DRONES)
               {
                  _loc9_ = ConfigManager.getInstance().configs[Settings.activeConfig];
                  _loc10_ = this.sortItems(_loc9_.equipments,param2,"drone");
                  _loc11_ = 0;
                  while(true)
                  {
                     if(_loc11_ >= _loc10_.length)
                     {
                        break loop3;
                     }
                     _loc12_ = _loc10_[_loc11_];
                     _loc14_ = _loc12_.name.substr(6,_loc12_.name.length - 1);
                     if(this.currentDraggedIconProxy.group == DataInterchange.DRONE_DESIGN_TYPE_CLASS)
                     {
                        _loc13_ = _loc12_.slotSets[DataInterchange.DESIGN];
                        param4.to["slotset"] = DataInterchange.DESIGN;
                     }
                     else
                     {
                        _loc13_ = _loc12_.slotSets[DataInterchange.DEFAULT];
                        param4.to["slotset"] = DataInterchange.DEFAULT;
                     }
                     if(_loc13_.items.length < _loc13_.maxSlotCount)
                     {
                        param4.to["droneId"] = _loc14_;
                        dispatchEvent(new MoveItemEvent(MoveItemEvent.ITEMS_MOVED_TO_DRONE_EQUIPMENT,param4));
                        break loop3;
                     }
                     _loc11_++;
                  }
                  break;
               }
               param4.to["slotset"] = this.hoveredSectionSlotSet;
               dispatchEvent(new MoveItemEvent(MoveItemEvent.ITEMS_MOVED_TO_SHIP_EQUIPMENT,param4));
               break;
            case ActionIdentifiers.SHIP:
            case ActionIdentifiers.DRONES:
            case ActionIdentifiers.PET:
               if(this.multiSelection != null)
               {
                  if(this.currentIconIsPartOfSelection())
                  {
                     param3 = this.returnItemIDs(this.multiSelection);
                  }
                  else
                  {
                     param3 = this.returnItemIDs([this.currentDraggedIcon]);
                  }
               }
               else
               {
                  param3 = this.returnItemIDs([this.currentDraggedIcon]);
               }
               param4.from["configId"] = Settings.activeConfig;
               param4.to["configId"] = Settings.activeConfig;
               param4.from["target"] = this.currentDraggedIcon.menuSectionComponent.getContainingViewID().toLowerCase();
               param4.from["items"] = param3;
               param4.to["target"] = Settings.INVENTORY_NAME;
               param4.to["index"] = 0;
               param4.action = ActionIdentifiers.MOVE;
               if(this.currentDraggedIcon.menuSectionComponent.getContainingViewID() == ActionIdentifiers.DRONES)
               {
                  param4.from["droneId"] = this.currentDraggedIcon.menuSectionComponent.getParent().section.toLowerCase();
                  if(this.currentDraggedIconProxy.group == DataInterchange.DRONE_DESIGN_TYPE_CLASS)
                  {
                     param4.from["slotset"] = DataInterchange.DESIGN;
                  }
                  else
                  {
                     param4.from["slotset"] = DataInterchange.DEFAULT;
                  }
               }
               else
               {
                  param4.from["slotset"] = this.currentDraggedIcon.menuSectionComponent.getParent().section.toLowerCase();
               }
               dispatchEvent(new MoveItemEvent(MoveItemEvent.ITEMS_MOVED_TO_INVENTORY,param4));
         }
         this.removeAllHighlightingFrom(param1);
      }
      
      private function makeProxyDragObject(param1:InventoryItemComponent) : InventoryItemComponent
      {
         this.currentDraggedIconProxy = new InventoryItemComponent();
         this.currentDraggedIconProxy.init();
         this.currentDraggedIconProxy.itemName = param1.itemName;
         this.currentDraggedIconProxy.changeGraphic(param1.itemName);
         this.currentDraggedIconProxy.itemID = param1.itemID;
         this.currentDraggedIconProxy.col = param1.col;
         this.currentDraggedIconProxy.row = param1.row;
         this.currentDraggedIconProxy.group = param1.group;
         this.currentDraggedIconProxy.equippedInConfigs = param1.equippedInConfigs;
         this.currentDraggedIconProxy.menuSectionComponent = param1.menuSectionComponent;
         this.currentDraggedIconProxy.indexInGrid = param1.indexInGrid;
         this.currentDraggedIconProxy.canBeSelected = param1.canBeSelected;
         this.currentDraggedIconProxy.quantityField = param1.quantityField;
         this.currentDraggedIconProxy.quantity = param1.quantity;
         this.currentDraggedIconProxy.sellable = param1.sellable;
         return this.currentDraggedIconProxy;
      }
      
      private function currentIconIsPartOfSelection() : Boolean
      {
         var _loc2_:InventoryItemComponent = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.multiSelection.length)
         {
            _loc2_ = this.multiSelection[_loc1_];
            if(_loc2_ == this.currentDraggedIcon)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      private function handleMouseMoved(param1:MouseEvent) : void
      {
         var _loc3_:IMenuView = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.collisionViews.length)
         {
            _loc3_ = this.collisionViews[_loc2_];
            if(this.currentDraggedIconProxy.hitTestObject(DisplayObject(_loc3_)))
            {
               if(!Settings.inventoryOpen)
               {
                  this.highlightPossibleDropAreas(this.currentDraggedIconProxy.group,_loc3_);
               }
               this.checkMenuSectionCollisions(this.currentDraggedIconProxy,_loc3_);
            }
            else
            {
               this.removeAllHighlightingFrom(_loc3_);
            }
            _loc2_++;
         }
         this.currentDraggedIconProxy.menuSectionComponent.getGridRearranger().mouseMoveCallback();
      }
      
      private function handleEnterFrameEvent(param1:Event) : void
      {
         var _loc2_:int = stage.mouseX;
         var _loc3_:int = stage.mouseY;
         if(this.mouseDown)
         {
            if(_loc2_ <= 0 || _loc3_ <= 0 || _loc3_ >= Settings.WINDOW_HEIGHT || _loc2_ >= Settings.WINDOW_WIDTH)
            {
               this.handleObjectReleased(null);
            }
         }
      }
      
      private function checkMenuSectionCollisions(param1:InventoryItemComponent, param2:IMenuView) : void
      {
         var _loc4_:AccordionMenuComponent = null;
         var _loc5_:Dictionary = null;
         var _loc6_:AccordionButtonComponent = null;
         var _loc3_:Dictionary = param2.getCurrentlyActiveSection();
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_[param2.getCurrentlyOpenMenu()];
            _loc5_ = _loc4_.menuButtonComponents;
            for each(_loc6_ in _loc5_)
            {
               if(_loc6_.open)
               {
                  if(this.currentDraggedIconProxy.hitTestObject(DisplayObject(_loc6_)))
                  {
                     this.hoveredSection = _loc6_;
                     break;
                  }
               }
               else
               {
                  this.hoveredSection = null;
               }
            }
         }
      }
      
      private function removeAllHighlightingFrom(param1:IMenuView) : void
      {
         var _loc3_:AccordionMenuComponent = null;
         var _loc4_:Dictionary = null;
         var _loc5_:AccordionButtonComponent = null;
         var _loc2_:Dictionary = param1.getCurrentlyActiveSection();
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_[param1.getCurrentlyOpenMenu()];
            _loc4_ = _loc3_.menuButtonComponents;
            for each(_loc5_ in _loc4_)
            {
               TweenMax.to(_loc5_,0.3,{"colorMatrixFilter":{"brightness":1}});
            }
         }
      }
      
      private function highlightPossibleDropAreas(param1:String, param2:IMenuView) : void
      {
         var _loc4_:AccordionMenuComponent = null;
         var _loc5_:Dictionary = null;
         var _loc6_:AccordionButtonComponent = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:GridComponent = null;
         var _loc3_:Dictionary = param2.getCurrentlyActiveSection();
         this.hoveredSections = [];
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_[param2.getCurrentlyOpenMenu()];
            _loc5_ = _loc4_.menuButtonComponents;
            for each(_loc6_ in _loc5_)
            {
               if(_loc6_.section != "")
               {
                  _loc7_ = _loc6_.equippableSections;
                  _loc8_ = 0;
                  while(_loc8_ < _loc7_.length)
                  {
                     if(param1 == DataInterchange.DRONE_DESIGN_TYPE_CLASS)
                     {
                        _loc9_ = _loc6_.gridDesign;
                     }
                     else
                     {
                        _loc9_ = _loc6_.grid;
                     }
                     if(param1 == _loc7_[_loc8_] && _loc9_.iconsInThisMenu.length > _loc9_.nextFreeSpace)
                     {
                        this.hoveredSections[_loc6_.id] = _loc6_;
                        this.hoveredSectionSlotSet = _loc6_.section;
                        TweenMax.to(_loc6_,0.3,{"colorMatrixFilter":{"brightness":1.3}});
                        if(_loc4_.menuName != "drone" && !_loc6_.open)
                        {
                           _loc4_.openOtherMenuSlot(_loc6_.id);
                        }
                     }
                     _loc8_++;
                  }
               }
            }
         }
      }
      
      public function handleObjectReleased(param1:MouseEvent) : void
      {
         var _loc4_:IMenuView = null;
         var _loc5_:IMenuView = null;
         this.multiSelector.addListeners();
         this.previouslySelectedItem = this.currentDraggedIcon;
         if(this.previouslySelectedItem.isLargeIcon)
         {
            return;
         }
         this.currentDraggedIconProxy.stopDrag();
         this.currentDraggedIconProxy.removeEventListener(MouseEvent.MOUSE_UP,this.handleObjectReleased);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.handleObjectReleased);
         this.currentDraggedIcon.addEventListener(MouseEvent.MOUSE_DOWN,this.handleObjectClicked);
         stage.removeEventListener(MouseEvent.MOUSE_OUT,this.handleObjectReleased);
         this.currentDraggedIcon.alpha = 1;
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMoved);
         stage.removeEventListener(Event.ENTER_FRAME,this.handleEnterFrameEvent);
         this.mouseDown = false;
         if(this.parent.contains(this.currentDraggedIconProxy))
         {
            this.parent.removeChild(this.currentDraggedIconProxy);
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.collisionViews.length)
         {
            _loc4_ = this.collisionViews[_loc2_];
            this.removeAllHighlightingFrom(_loc4_);
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.collisionViews.length)
         {
            _loc5_ = this.collisionViews[_loc3_];
            if(this.currentDraggedIconProxy.hitTestObject(DisplayObject(_loc5_.getActualCollisionRegion())))
            {
               if(!this._shiftButtonDown && !this._controlButtonDown)
               {
                  this.rearrangeItem(_loc5_);
                  this.multiSelection = null;
               }
               return;
            }
            _loc3_++;
         }
         if(this.currentDraggedIcon.menuSectionComponent.getParent() is InventoryView)
         {
            this.currentDraggedIcon.menuSectionComponent.getGridRearranger().mouseReleaseCallback();
         }
         else
         {
            this.currentDraggedIcon.menuSectionComponent.putThisItemBack(this.currentDraggedIcon);
         }
         this.multiSelection = null;
         this.currentDraggedIconProxy = null;
      }
      
      private function rearrangeItem(param1:IMenuView) : void
      {
         var _loc2_:String = null;
         var _loc3_:IMenuComponent = null;
         var _loc4_:Array = null;
         var _loc9_:Dictionary = null;
         var _loc10_:int = 0;
         var _loc11_:String = null;
         var _loc5_:Object = new Object();
         var _loc6_:Transporter = new Transporter();
         var _loc7_:Object = new Object();
         var _loc8_:Object = new Object();
         switch(param1.getViewID())
         {
            case Settings.INVENTORY_NAME:
               if(this.currentDraggedIcon.menuSectionComponent.getParent() is InventoryView)
               {
                  _loc9_ = this.currentDraggedIconProxy.menuSectionComponent.getGridRearranger().mouseReleaseCallback();
                  if(_loc9_[ActionIdentifiers.PUT_DRAGGED_ITEM_BACK_FUNCTION] is Function)
                  {
                     _loc9_[ActionIdentifiers.PUT_DRAGGED_ITEM_BACK_FUNCTION];
                     break;
                  }
                  _loc5_.action = ActionIdentifiers.MOVE;
                  _loc7_.target = param1.getViewID().toLowerCase();
                  _loc8_.target = param1.getViewID().toLowerCase();
                  _loc7_.items = new Array(_loc9_[ActionIdentifiers.DRAGGED_ITEM_INDEX]);
                  _loc8_.index = _loc9_[ActionIdentifiers.SWAPPED_ITEM_INDEX];
                  _loc5_.from = _loc7_;
                  _loc5_.to = _loc8_;
                  _loc10_ = int(_loc9_[ActionIdentifiers.DRAGGED_ITEM_QUANTITY]);
                  _loc11_ = _loc9_[ActionIdentifiers.SWAPPED_ITEM_GROUP];
                  dispatchEvent(new MoveItemEvent(MoveItemEvent.ITEM_REARRANGED_WITHIN_INVENTORY,_loc5_));
                  break;
               }
               if(this.multiSelection != null)
               {
                  if(this.currentIconIsPartOfSelection())
                  {
                     _loc4_ = this.returnItemIDs(this.multiSelection);
                  }
                  else
                  {
                     _loc4_ = this.returnItemIDs([this.selectedItem]);
                  }
               }
               else
               {
                  _loc4_ = this.returnItemIDs([this.selectedItem]);
               }
               _loc6_.to.configId = Settings.activeConfig;
               _loc6_.from.configId = Settings.activeConfig;
               _loc6_.from.target = this.currentDraggedIcon.menuSectionComponent.getContainingViewID().toLowerCase();
               _loc6_.from.items = _loc4_;
               _loc6_.to.target = param1.getViewID().toLowerCase();
               _loc6_.to.index = 0;
               _loc6_.action = ActionIdentifiers.MOVE;
               if(this.currentDraggedIcon.menuSectionComponent.getContainingViewID() == ActionIdentifiers.DRONES)
               {
                  _loc6_.from.droneId = this.currentDraggedIcon.menuSectionComponent.getParent().section.toLowerCase();
                  if(this.currentDraggedIconProxy.group == DataInterchange.DRONE_DESIGN_TYPE_CLASS)
                  {
                     _loc6_.from.slotset = DataInterchange.DESIGN;
                  }
                  else
                  {
                     _loc6_.from.slotset = DataInterchange.DEFAULT;
                  }
               }
               else
               {
                  _loc6_.from.slotset = this.currentDraggedIcon.menuSectionComponent.getParent().section.toLowerCase();
               }
               dispatchEvent(new MoveItemEvent(MoveItemEvent.ITEMS_MOVED_TO_INVENTORY,_loc6_));
               break;
            case Settings.ACCORDION_NAME:
               _loc3_ = this.currentDraggedIcon.menuSectionComponent;
               if(this.currentDraggedIcon.menuSectionComponent.getParent() is AccordionButtonComponent)
               {
                  this.currentDraggedIcon.menuSectionComponent.putThisItemBack(this.currentDraggedIcon);
                  break;
               }
               if((_loc3_.getFilterState() != ItemFilter.USER_FILTER || _loc3_.getFilterState() != ItemFilter.CONTEXT_FILTER) && this.hoveredSection != null)
               {
                  if(this.multiSelection != null)
                  {
                     if(this.currentIconIsPartOfSelection())
                     {
                        _loc4_ = this.returnItemIDs(this.multiSelection);
                     }
                     else
                     {
                        _loc4_ = this.returnItemIDs([this.selectedItem]);
                     }
                  }
                  else
                  {
                     _loc4_ = this.returnItemIDs([this.selectedItem]);
                  }
                  _loc6_ = new Transporter();
                  _loc6_.from.configId = Settings.activeConfig;
                  _loc6_.to.configId = Settings.activeConfig;
                  _loc6_.from.target = this.currentDraggedIcon.menuSectionComponent.getContainingViewID().toLowerCase();
                  _loc6_.from.items = _loc4_;
                  _loc6_.to.target = param1.getCurrentlyOpenMenu().toLowerCase();
                  _loc6_.action = ActionIdentifiers.MOVE;
                  if(param1.getCurrentlyOpenMenu() == ActionIdentifiers.DRONES)
                  {
                     _loc6_.to.droneId = this.hoveredSection.section.toLowerCase();
                     if(this.currentDraggedIconProxy.group == DataInterchange.DRONE_DESIGN_TYPE_CLASS)
                     {
                        _loc6_.to.slotset = DataInterchange.DESIGN;
                     }
                     else
                     {
                        _loc6_.to.slotset = DataInterchange.DEFAULT;
                     }
                     dispatchEvent(new MoveItemEvent(MoveItemEvent.ITEMS_MOVED_TO_DRONE_EQUIPMENT,_loc6_));
                     break;
                  }
                  _loc6_.to.slotset = this.hoveredSectionSlotSet;
                  dispatchEvent(new MoveItemEvent(MoveItemEvent.ITEMS_MOVED_TO_SHIP_EQUIPMENT,_loc6_));
                  break;
               }
               this.currentDraggedIcon.menuSectionComponent.getGridRearranger().mouseReleaseCallback();
               break;
            default:
               if(this.currentDraggedIcon.menuSectionComponent.getParent() is InventoryView)
               {
                  this.currentDraggedIcon.menuSectionComponent.getGridRearranger().mouseReleaseCallback();
               }
         }
         this.multiSelection = [];
      }
      
      private function returnItemIDs(param1:Array) : Array
      {
         var _loc4_:InventoryItemComponent = null;
         if(param1 == null || param1.length == 0)
         {
            return new Array(this.currentDraggedIcon.itemID);
         }
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_];
            _loc2_.push(_loc4_.itemID);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function set controlButtonDown(param1:Boolean) : void
      {
         this._controlButtonDown = param1;
      }
      
      public function get controlButtonDown() : Boolean
      {
         return this._controlButtonDown;
      }
      
      public function set shiftButtonDown(param1:Boolean) : void
      {
         this._shiftButtonDown = param1;
      }
      
      public function get shiftButtonDown() : Boolean
      {
         return this._shiftButtonDown;
      }
   }
}

