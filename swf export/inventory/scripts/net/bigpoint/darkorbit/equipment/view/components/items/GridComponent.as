package net.bigpoint.darkorbit.equipment.view.components.items
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.equipment.events.GridEvent;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInstanceVO;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemLocalisationKeys;
   import net.bigpoint.darkorbit.equipment.model.VO.slot.SlotItemVO;
   import net.bigpoint.darkorbit.equipment.model.VO.slot.SlotSetVO;
   import net.bigpoint.darkorbit.equipment.model.managers.FilterManager;
   import net.bigpoint.darkorbit.equipment.model.managers.HangarManagerProxy;
   import net.bigpoint.darkorbit.equipment.view.components.InventoryView;
   import net.bigpoint.darkorbit.equipment.view.components.buttons.DropDownButton;
   import net.bigpoint.darkorbit.equipment.view.components.interfaces.IMenuComponent;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.TooltipControl;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.preparation.DefaultTooltipPreparer;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.preparation.ITooltipPreparer;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.preparation.TooltipPreparerFactory;
   import net.bigpoint.darkorbit.equipment.view.managers.IFocusable;
   import net.bigpoint.dataInterchange.DataInterchange;
   
   public class GridComponent extends Sprite implements IMenuComponent, IFocusable
   {
      
      public static const OBJECT_NAME:String = "GridComponent";
      
      public static const NORMAL_GRID:String = "normal_grid";
      
      public static const BLOCK_BASED_GRID:String = "block_based_grid";
      
      public static var GRID_HORIZONTAL_SPACING:int = 10;
      
      public static var GRID_VERTICAL_SPACING:int = 6;
      
      public static var ITEMS_PER_BLOCK:int = 24;
      
      public static const DRAG_GROUP_ACCORDIONVIEW_ID:int = 1;
      
      public static const DRAG_GROUP_INVENTORYVIEW_ID:int = 2;
      
      public const STAGE_HEIGHT:Number = 430;
      
      public const HALF_STAGE_HEIGHT:Number = 215;
      
      public const TWEEN_SPEED:Number = 0.3;
      
      private var ITEM_WIDTH:Number = 34;
      
      private var ITEM_HEIGHT:Number = 34;
      
      public var GRID_MODE:String = "normal_grid";
      
      private var menuList:Array;
      
      public var selectedMenu:int = -1;
      
      public var menuName:String;
      
      public var associatedView:Sprite;
      
      private var offSetY:Number;
      
      private var offSetX:Number;
      
      public var ICONS_ACROSS:int = 4;
      
      public var BLOCKS_ACROSS:int = 1;
      
      public var ICONS_DOWN:int = 6;
      
      public var blocksList:Array = [];
      
      private var visualBlockArray:Array;
      
      public var GAP_AMOUNT:int = 10;
      
      public var startYPos:Number = 0;
      
      public var rowTracker:int = 0;
      
      private var redrawBlockColumn:int = 0;
      
      private var redrawBlockRow:int = 0;
      
      protected var startingPointFromLeft:Number = 0;
      
      protected var startingPointFromTop:Number = 0;
      
      public var iconsInThisMenu:Array = [];
      
      public var numberOfIconsInThisMenu:int = 0;
      
      public var canRearrange:Boolean = false;
      
      public var nextFreeSpace:int;
      
      public var filterBy:String = "user";
      
      public var currentFilter:String = this.filterBy;
      
      private var sortOrderArray:Array = [];
      
      private var sortedItems:Array;
      
      private var nonFilteredItems:Array;
      
      private var emptyItems:Array;
      
      public var sectionName:String;
      
      public var slotSetName:String;
      
      public var verticallyAligned:Boolean = false;
      
      public var startXPos:Number = 0;
      
      private var hangarIDasFilter:int = 0;
      
      public var gridArranger:GridRearrangeComponent;
      
      public var lowestOfSortedItems:InventoryItemComponent;
      
      private var dragComp:DragComponent;
      
      private var toolTipControl:TooltipControl;
      
      private var hangarManager:HangarManagerProxy;
      
      private var lastHangarWideEquippedItemIDsToRemove:Array;
      
      private var _dragGroupID:int;
      
      public function GridComponent(param1:Boolean, param2:InventoryView = null)
      {
         super();
         this.toolTipControl = TooltipControl.getInstance();
         this.associatedView = param2 as InventoryView;
         this.offSetY = this.offSetY;
         this.offSetX = this.offSetX;
         if(this.dragComp == null)
         {
            this.dragComp = DragComponent.getInstance();
         }
         this.canRearrange = param1;
         this.gridArranger = new GridRearrangeComponent(this.iconsInThisMenu);
         this.gridArranger.addEventListener(GridEvent.FILL_IN_GAP,this.fillEmptyGridSquares);
         this.gridArranger.addEventListener(GridEvent.RE_ORDER_GRID,this.reOrderGridByGroups);
         this.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMoveEvent);
         if(param1)
         {
            this.gridArranger.rearrangeActive = true;
         }
      }
      
      private function handleMouseMoveEvent(param1:MouseEvent) : void
      {
         this.focusing();
      }
      
      public function focusing() : void
      {
         dispatchEvent(new GridEvent(GridEvent.FOCUSED));
      }
      
      public function unfocusing() : void
      {
         dispatchEvent(new GridEvent(GridEvent.UNFOCUSED));
      }
      
      public function createGridMenu(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc6_:InventoryItemComponent = null;
         var _loc7_:int = 0;
         this.verticallyAligned = param2;
         var _loc4_:Number = 0;
         var _loc5_:int = 0;
         while(_loc5_ < param1)
         {
            _loc6_ = new InventoryItemComponent();
            _loc6_.init();
            _loc6_.menuSectionComponent = this;
            _loc6_.group = ItemFilter.EMPTY_SPACE_FILTER;
            this.dragComp.addDraggableIcon(_loc6_);
            addChild(_loc6_);
            _loc7_ = _loc5_ % this.ICONS_ACROSS;
            if(param2)
            {
               _loc6_.x = this.rowTracker * _loc6_.height + Math.floor(this.rowTracker / GRID_VERTICAL_SPACING) * this.GAP_AMOUNT + this.startYPos;
               _loc6_.y = _loc7_ * _loc6_.width + Math.floor(_loc7_ / GRID_HORIZONTAL_SPACING) * this.GAP_AMOUNT + this.startXPos;
            }
            else
            {
               _loc6_.x = _loc7_ * _loc6_.width + Math.floor(_loc7_ / GRID_HORIZONTAL_SPACING) * this.GAP_AMOUNT + this.startXPos;
               _loc6_.y = this.rowTracker * _loc6_.height + Math.floor(this.rowTracker / GRID_VERTICAL_SPACING) * this.GAP_AMOUNT + this.startYPos;
            }
            _loc6_.col = _loc7_;
            _loc6_.row = this.rowTracker;
            _loc3_ = _loc6_.row * this.ICONS_ACROSS + _loc6_.col;
            _loc6_.indexInGrid = _loc3_;
            this.iconsInThisMenu[_loc3_] = _loc6_;
            if(_loc7_ == this.ICONS_ACROSS - 1)
            {
               ++this.rowTracker;
            }
            ++this.numberOfIconsInThisMenu;
            _loc5_++;
         }
         this.addDragListeners(this.iconsInThisMenu);
         this.giveIconsToGridArranger(this.iconsInThisMenu);
         this.addGridToMultiSelector();
      }
      
      public function splitItemsIntoBlocks(param1:int) : void
      {
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:InventoryItemComponent = null;
         this.GRID_MODE = BLOCK_BASED_GRID;
         var _loc2_:int = 0;
         var _loc3_:int = Math.ceil(param1 / ITEMS_PER_BLOCK);
         var _loc4_:int = 0;
         while(_loc4_ <= _loc3_)
         {
            _loc5_ = [];
            _loc6_ = 0;
            while(_loc6_ < ITEMS_PER_BLOCK)
            {
               _loc7_ = new InventoryItemComponent();
               _loc7_.init();
               _loc7_.menuSectionComponent = this;
               this.toolTipControl.addToolTip(_loc7_,"Name: Item Name \nType: Item Type \nCharges: 1x10 to the 5000 \nDuration: Not Long");
               _loc7_.group = ItemFilter.EMPTY_SPACE_FILTER;
               this.iconsInThisMenu[_loc2_] = _loc7_;
               _loc7_.indexInGrid = _loc2_;
               _loc5_.push(_loc7_);
               _loc2_++;
               ++this.numberOfIconsInThisMenu;
               _loc6_++;
            }
            this.blocksList[_loc4_] = _loc5_;
            _loc4_++;
         }
         this.displayBlocks(this.blocksList);
      }
      
      private function displayBlocks(param1:Array) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Sprite = null;
         var _loc2_:int = 0;
         this.visualBlockArray = [];
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = _loc3_ % this.BLOCKS_ACROSS;
            _loc5_ = this.arrangeIndividualBlock(param1[_loc3_]);
            this.visualBlockArray.push(_loc5_);
            _loc5_.x = _loc4_ * (_loc5_.width + this.GAP_AMOUNT);
            _loc5_.y = _loc2_ * (_loc5_.height + this.GAP_AMOUNT);
            if(_loc4_ == this.BLOCKS_ACROSS - 1)
            {
               _loc2_++;
            }
            addChild(_loc5_);
            _loc3_++;
         }
      }
      
      private function arrangeIndividualBlock(param1:Array) : BlockComponent
      {
         var _loc5_:int = 0;
         var _loc6_:InventoryItemComponent = null;
         var _loc2_:int = 0;
         var _loc3_:BlockComponent = new BlockComponent();
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = _loc4_ % this.ICONS_ACROSS;
            _loc6_ = param1[_loc4_];
            _loc6_.x = _loc5_ * _loc6_.width;
            _loc6_.y = _loc2_ * _loc6_.height;
            if(_loc5_ == this.ICONS_ACROSS - 1)
            {
               _loc2_++;
            }
            _loc3_.addChild(_loc6_);
            _loc3_.blockIndex = _loc4_;
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function findContainingBlock(param1:int) : int
      {
         return int(Math.floor(param1 / ITEMS_PER_BLOCK) + 1);
      }
      
      public function globalToLocalIndex(param1:int) : int
      {
         var _loc2_:int = this.findContainingBlock(param1);
         if(_loc2_ == 1)
         {
            return param1;
         }
         var _loc3_:int = (_loc2_ - 1) * ITEMS_PER_BLOCK;
         return int(Math.abs(param1 - _loc3_));
      }
      
      private function reOrderGridByGroups(param1:GridEvent = null) : void
      {
         var _loc2_:ItemFilter = new ItemFilter();
         this.addDragListeners(this.iconsInThisMenu);
         var _loc3_:Array = _loc2_.sortAllItemsByGroup(this.iconsInThisMenu);
         this.reOrderIconArray(_loc3_);
         this.reDrawGridWithFilter(_loc3_);
         var _loc4_:Array = _loc2_.filterBySpecificGroup(ItemFilter.EMPTY_SPACE_FILTER,this.gridArranger.allIcons);
         this.removeDragListeners(_loc4_);
      }
      
      private function reOrderIconArray(param1:Array) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this.iconsInThisMenu[_loc2_] = param1[_loc2_];
            this.iconsInThisMenu[_loc2_].indexInGrid = _loc2_;
            _loc2_++;
         }
      }
      
      public function filterByContext(param1:Array, param2:Array = null, param3:Array = null) : void
      {
         var _loc4_:ItemFilter = new ItemFilter();
         var _loc5_:Array = this.gridArranger.allIcons;
         this.sortedItems = _loc4_.filterByArrayOfSpecificGroups(param1,_loc5_);
         var _loc6_:Array = this.sortedItems;
         if(param2)
         {
            this.removeAllHangarWideEquippedItems(param2,_loc6_);
         }
         this.nonFilteredItems = _loc4_.getItemsNotInOtherArray(_loc5_,_loc6_);
         this.changeVisibleState(true,this.iconsInThisMenu);
         this.addDragListeners(this.iconsInThisMenu);
         this.removeDragListeners(this.nonFilteredItems);
         this.putToBack(this.nonFilteredItems);
         this.gridArranger.rearrangeActive = false;
         this.redrawGridWithSortedAndNonFilteredItems();
         this.lowestOfSortedItems = _loc6_[_loc6_.length - 1];
         this.removeAllEquippedOverlays(this.iconsInThisMenu);
         if(param3)
         {
            this.changeEquipmentState(_loc6_,param3);
         }
         this.currentFilter = ItemFilter.CONTEXT_FILTER;
      }
      
      private function removeAllHangarWideEquippedItems(param1:Array, param2:Array) : void
      {
         var _loc4_:int = 0;
         var _loc5_:InventoryItemComponent = null;
         this.lastHangarWideEquippedItemIDsToRemove = param1;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = 0;
            while(_loc4_ < param2.length)
            {
               _loc5_ = param2[_loc4_] as InventoryItemComponent;
               if(_loc5_.itemID == param1[_loc3_])
               {
                  param2.splice(_loc4_,1);
               }
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      public function fillEmptyGridSquares(param1:GridEvent = null) : void
      {
         this.changeVisibleState(true,this.iconsInThisMenu);
         var _loc2_:ItemFilter = new ItemFilter();
         this.addDragListeners(this.iconsInThisMenu);
         this.sortedItems = _loc2_.filterByParentGroup(this.currentFilter,this.gridArranger.allIcons);
         this.nonFilteredItems = _loc2_.getItemsNotInOtherArray(this.gridArranger.allIcons,this.sortedItems);
         this.emptyItems = _loc2_.filterBySpecificGroup(ItemFilter.EMPTY_SPACE_FILTER,this.gridArranger.allIcons);
         this.lowestOfSortedItems = this.sortedItems[this.sortedItems.length - 1];
         this.removeDragListeners(this.nonFilteredItems);
         this.putToBack(this.nonFilteredItems);
         this.changeVisibleState(false,this.nonFilteredItems);
         this.reDrawGridWithFilter(this.sortedItems);
         this.removeAllEquippedOverlays(this.iconsInThisMenu);
      }
      
      public function refreshFilteredInventoryView(param1:GridEvent = null) : void
      {
         this.changeVisibleState(true,this.iconsInThisMenu);
         var _loc2_:ItemFilter = new ItemFilter();
         this.addDragListeners(this.iconsInThisMenu);
         this.sortedItems = _loc2_.filterByParentGroup(this.currentFilter,this.gridArranger.allIcons,true);
         this.nonFilteredItems = _loc2_.getItemsNotInOtherArray(this.gridArranger.allIcons,this.sortedItems);
         this.emptyItems = _loc2_.filterBySpecificGroup(ItemFilter.EMPTY_SPACE_FILTER,this.gridArranger.allIcons);
         this.lowestOfSortedItems = this.sortedItems[this.sortedItems.length - 1];
         this.removeDragListeners(this.nonFilteredItems);
         this.putToBack(this.nonFilteredItems);
         this.changeVisibleState(false,this.nonFilteredItems);
         this.reDrawGridWithFilter_TheSecondComing(this.sortedItems);
         this.removeAllEquippedOverlays(this.iconsInThisMenu);
      }
      
      public function setHangarIDasFilter(param1:int) : void
      {
         this.hangarIDasFilter = param1;
      }
      
      public function filterGridOnMouseEvent(param1:MouseEvent = null) : void
      {
         var _loc2_:DropDownButton = DropDownButton(param1.currentTarget);
         this.filterGridByButton(_loc2_);
      }
      
      public function filterGridByButton(param1:DropDownButton) : void
      {
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc2_:String = param1.filterKey;
         var _loc3_:* = param1.buttonKey == ItemFilter.USER_FILTER;
         this.changeVisibleState(true,this.iconsInThisMenu);
         this.addDragListeners(this.iconsInThisMenu);
         var _loc4_:ItemFilter = new ItemFilter();
         if(_loc3_ && this.hangarIDasFilter != 0)
         {
            this.sortedItems = this.gridArranger.allIcons;
         }
         else
         {
            this.sortedItems = _loc4_.filterByParentGroup(_loc2_,this.gridArranger.allIcons,true);
         }
         if(this.hangarIDasFilter != 0)
         {
            switch(_loc2_)
            {
               case FilterManager.FILTER_RESSOURCES:
                  this.sortedItems = _loc4_.filterByParentGroup(FilterManager.FILTER_RESSOURCES,this.gridArranger.allIcons,true);
                  break;
               case FilterManager.FILTER_AMMUNITION:
                  this.sortedItems = _loc4_.filterByParentGroup(FilterManager.FILTER_AMMUNITION,this.gridArranger.allIcons,true);
                  break;
               default:
                  this.prefilterItemlistForSpecificHangar(this.hangarIDasFilter,_loc4_);
            }
            if(_loc3_)
            {
               _loc5_ = _loc4_.filterByParentGroup(FilterManager.FILTER_RESSOURCES,this.gridArranger.allIcons,true);
               _loc6_ = _loc4_.filterByParentGroup(FilterManager.FILTER_AMMUNITION,this.gridArranger.allIcons,true);
               this.sortedItems = this.sortedItems.concat(_loc5_);
               this.sortedItems = this.sortedItems.concat(_loc6_);
            }
         }
         this.nonFilteredItems = _loc4_.getItemsNotInOtherArray(this.gridArranger.allIcons,this.sortedItems);
         this.emptyItems = _loc4_.filterBySpecificGroup(ItemFilter.EMPTY_SPACE_FILTER,this.gridArranger.allIcons);
         this.lowestOfSortedItems = this.sortedItems[this.sortedItems.length - 1];
         this.removeDragListeners(this.nonFilteredItems);
         this.putToBack(this.nonFilteredItems);
         if(param1.buttonKey == ItemFilter.USER_FILTER && this.hangarIDasFilter == 0)
         {
            this.gridArranger.rearrangeActive = true;
            this.reDrawGrid_TheSecondComing();
            this.addAllEquippedOverlays(this.iconsInThisMenu);
            this.currentFilter = param1.buttonKey;
         }
         else
         {
            this.gridArranger.rearrangeActive = false;
            this.redrawGridWithSortedAndNonFilteredItems();
            this.removeAllEquippedOverlays(this.iconsInThisMenu);
            this.currentFilter = _loc2_;
         }
      }
      
      private function prefilterItemlistForSpecificHangar(param1:int, param2:ItemFilter) : void
      {
         var _loc8_:InventoryItemComponent = null;
         var _loc9_:int = 0;
         var _loc10_:InventoryItemComponent = null;
         var _loc3_:Array = this.hangarManager.getAllEquippedItemIDsForHangar(param1);
         var _loc4_:Array = [];
         var _loc5_:Dictionary = new Dictionary();
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_.length)
         {
            _loc9_ = 0;
            while(_loc9_ < this.sortedItems.length)
            {
               _loc10_ = this.sortedItems[_loc9_];
               if(_loc10_.itemID == _loc3_[_loc6_])
               {
                  _loc4_.push(_loc10_);
                  _loc5_[_loc10_.itemID] = _loc10_;
               }
               _loc9_++;
            }
            _loc6_++;
         }
         this.sortedItems = _loc4_;
         var _loc7_:Array = [];
         for each(_loc8_ in _loc5_)
         {
            _loc7_.push(_loc8_);
         }
         this.sortedItems = _loc7_;
      }
      
      public function addAllEquippedOverlays(param1:Array) : void
      {
         var _loc6_:int = 0;
         var _loc7_:InventoryItemComponent = null;
         var _loc8_:String = null;
         var _loc2_:int = this.hangarManager.getCurrentHangarSlotVO().hangarID;
         var _loc3_:Array = this.hangarManager.getAllEquippedItemIDsForHangar(_loc2_);
         var _loc4_:Array = this.hangarManager.getAllEquippedItemIDsHangarWideExceptTheCurrentHangarFor();
         _loc4_ = _loc4_.concat(_loc3_);
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               _loc7_ = param1[_loc5_];
               _loc8_ = _loc4_[_loc6_];
               if(_loc7_.itemID == _loc8_)
               {
                  _loc7_.setEquipped();
                  _loc4_.splice(_loc6_,1);
               }
               _loc6_++;
            }
            _loc5_++;
         }
      }
      
      private function removeAllEquippedOverlays(param1:Array) : void
      {
         var _loc3_:InventoryItemComponent = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc3_.setUnEquipped();
            _loc2_++;
         }
      }
      
      private function putToBack(param1:Array) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            param1[_loc2_].parent.setChildIndex(param1[_loc2_],0);
            _loc2_++;
         }
      }
      
      public function changeEquipmentState(param1:Array, param2:Array) : void
      {
         var _loc7_:int = 0;
         var _loc8_:InventoryItemComponent = null;
         var _loc3_:Dictionary = new Dictionary();
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            _loc7_ = int(param2[_loc4_]);
            _loc3_[_loc7_] = _loc7_;
            _loc4_++;
         }
         var _loc5_:uint = param1.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc8_ = param1[_loc6_];
            if(_loc3_[_loc8_.itemID])
            {
               _loc8_.setEquipped();
            }
            if(_loc8_)
            {
               _loc8_.setContenActivation(visible);
               this.toolTipControl.setHiddenStatus(_loc8_,visible);
            }
            _loc6_++;
         }
      }
      
      public function changeVisibleState(param1:Boolean, param2:Array) : void
      {
         var _loc5_:InventoryItemComponent = null;
         var _loc3_:uint = param2.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param2[_loc4_];
            if(_loc5_)
            {
               _loc5_.setContenActivation(param1);
               this.toolTipControl.setHiddenStatus(_loc5_,param1);
            }
            _loc4_++;
         }
      }
      
      private function calculateItemXPosition(param1:int, param2:Number) : Number
      {
         return param1 * param2;
      }
      
      private function calculateItemYPosition(param1:Number) : Number
      {
         return this.rowTracker * param1;
      }
      
      private function redrawGridWithSortedAndNonFilteredItems() : void
      {
         this.rowTracker = 0;
         this.redrawBlockRow = 0;
         this.redrawBlockColumn = 0;
         this.startingPointFromTop = 0;
         this.startingPointFromLeft = 0;
         this.changeVisibleState(false,this.nonFilteredItems);
         this.redrawGridElements(this.sortedItems,0,true);
         this.redrawGridElements(this.nonFilteredItems,this.sortedItems.length);
      }
      
      private function redrawGridElements(param1:Array, param2:uint = 0, param3:Boolean = false) : Point
      {
         var _loc5_:InventoryItemComponent = null;
         var _loc9_:int = 0;
         var _loc4_:uint = param1.length;
         var _loc6_:uint = param2;
         this.calcStartPoint_ICONS_DOWN();
         this.calcStartPoint_BLOCKS_ACROSS();
         var _loc7_:int = 0;
         while(_loc7_ < _loc4_)
         {
            _loc5_ = param1[_loc7_];
            if(_loc5_ != null)
            {
               _loc9_ = _loc6_ % this.ICONS_ACROSS;
               _loc6_++;
               _loc5_.x = this.calculateItemXPosition(_loc9_,_loc5_.width);
               _loc5_.x += this.startingPointFromLeft;
               _loc5_.y = this.calculateItemYPosition(_loc5_.height);
               _loc5_.y += this.startingPointFromTop;
               if(_loc9_ == this.ICONS_ACROSS - 1)
               {
                  ++this.rowTracker;
               }
               this.calcStartPoint_ICONS_DOWN();
               this.calcStartPoint_BLOCKS_ACROSS();
               ++this.numberOfIconsInThisMenu;
            }
            _loc7_++;
         }
         var _loc8_:Point = new Point(0,0);
         if(_loc5_)
         {
            _loc8_ = new Point(_loc5_.x,_loc5_.y);
         }
         return _loc8_;
      }
      
      private function calcStartPoint_ICONS_DOWN() : void
      {
         if(this.rowTracker == this.ICONS_DOWN)
         {
            this.rowTracker = 0;
            ++this.redrawBlockColumn;
            this.startingPointFromLeft = (this.ICONS_ACROSS * this.ITEM_WIDTH + GRID_HORIZONTAL_SPACING) * this.redrawBlockColumn;
         }
      }
      
      private function calcStartPoint_BLOCKS_ACROSS() : void
      {
         if(this.redrawBlockColumn == this.BLOCKS_ACROSS)
         {
            ++this.redrawBlockRow;
            this.startingPointFromTop = (this.ICONS_DOWN * this.ITEM_HEIGHT + GRID_VERTICAL_SPACING) * this.redrawBlockRow;
            this.redrawBlockColumn = 0;
            this.startingPointFromLeft = 0;
         }
      }
      
      private function reDrawGridWithFilter_TheSecondComing(param1:Array) : Point
      {
         var _loc7_:InventoryItemComponent = null;
         var _loc10_:int = 0;
         this.rowTracker = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:uint = param1.length;
         var _loc8_:int = 0;
         while(_loc8_ < _loc6_)
         {
            _loc7_ = param1[_loc8_];
            _loc10_ = _loc8_ % this.ICONS_ACROSS;
            _loc7_.x = this.calculateItemXPosition(_loc10_,_loc7_.width);
            _loc7_.x += _loc4_;
            _loc7_.y = this.calculateItemYPosition(_loc7_.height);
            _loc7_.y += _loc5_;
            if(_loc10_ == this.ICONS_ACROSS - 1)
            {
               ++this.rowTracker;
            }
            if(this.rowTracker == this.ICONS_DOWN)
            {
               this.rowTracker = 0;
               _loc2_++;
               _loc4_ = (this.ICONS_ACROSS * this.ITEM_WIDTH + GRID_HORIZONTAL_SPACING) * _loc2_;
            }
            if(_loc2_ == this.BLOCKS_ACROSS)
            {
               _loc3_++;
               _loc5_ = (this.ICONS_DOWN * this.ITEM_HEIGHT + GRID_VERTICAL_SPACING) * _loc3_;
               _loc2_ = 0;
               _loc4_ = 0;
            }
            ++this.numberOfIconsInThisMenu;
            _loc8_++;
         }
         var _loc9_:Point = new Point(0,0);
         if(_loc7_)
         {
            _loc9_ = new Point(_loc7_.x,_loc7_.y);
         }
         return _loc9_;
      }
      
      private function reDrawGridWithFilter(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc4_:InventoryItemComponent = null;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         this.rowTracker = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_];
            _loc5_ = _loc3_ % this.ICONS_ACROSS;
            if(this.verticallyAligned)
            {
               _loc6_ = this.rowTracker * _loc4_.height + Math.floor(this.rowTracker / GRID_VERTICAL_SPACING) * this.GAP_AMOUNT + this.startYPos;
               _loc7_ = _loc5_ * _loc4_.width + Math.floor(_loc5_ / GRID_HORIZONTAL_SPACING) * this.GAP_AMOUNT + this.startXPos;
            }
            else
            {
               _loc6_ = _loc5_ * _loc4_.width + Math.floor(_loc5_ / GRID_HORIZONTAL_SPACING) * this.GAP_AMOUNT + this.startXPos;
               _loc7_ = this.rowTracker * _loc4_.height + Math.floor(this.rowTracker / GRID_VERTICAL_SPACING) * this.GAP_AMOUNT + this.startYPos;
            }
            _loc4_.x = Math.round(_loc6_);
            _loc4_.y = Math.round(_loc7_);
            _loc4_.col = _loc5_;
            _loc4_.row = this.rowTracker;
            if(_loc5_ == this.ICONS_ACROSS - 1)
            {
               ++this.rowTracker;
            }
            ++this.numberOfIconsInThisMenu;
            _loc3_++;
         }
      }
      
      public function addDragListeners(param1:Array) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this.dragComp.addDraggableIcon(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      public function removeDragListeners(param1:Array) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this.dragComp.removeDraggableIcon(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      public function changeNumberOfSlots(param1:int) : void
      {
         var _loc4_:* = 0;
         var _loc5_:InventoryItemComponent = null;
         var _loc6_:int = 0;
         var _loc7_:InventoryItemComponent = null;
         var _loc2_:int = param1 - this.iconsInThisMenu.length;
         var _loc3_:String = "adding";
         if(_loc2_ < 0)
         {
            _loc2_ = Math.abs(_loc2_);
            _loc3_ = "removing";
         }
         if(_loc3_ == "adding")
         {
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc5_ = new InventoryItemComponent();
               _loc5_.init();
               _loc5_.menuSectionComponent = this;
               _loc5_.group = ItemFilter.EMPTY_SPACE_FILTER;
               this.dragComp.addDraggableIcon(_loc5_);
               this.gridArranger.allIcons.push(_loc5_);
               addChild(_loc5_);
               _loc4_++;
            }
         }
         else if(_loc3_ == "removing")
         {
            _loc6_ = 0;
            _loc4_ = this.iconsInThisMenu.length - 1;
            while(_loc4_ > 0)
            {
               if(_loc6_ != _loc2_)
               {
                  _loc7_ = this.iconsInThisMenu[_loc4_];
                  if(contains(_loc7_))
                  {
                     removeChild(_loc7_);
                  }
                  this.gridArranger.allIcons.splice(_loc4_,1);
                  this.iconsInThisMenu.splice(_loc4_,1);
                  _loc6_++;
               }
               _loc4_--;
            }
         }
         this.resetNextEmptySlotIndex();
         this.reDrawGrid();
      }
      
      private function resetNextEmptySlotIndex() : void
      {
         var _loc3_:InventoryItemComponent = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.iconsInThisMenu.length)
         {
            _loc3_ = this.iconsInThisMenu[_loc2_];
            if(_loc3_.group == ItemFilter.EMPTY_SPACE_FILTER)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         this.nextFreeSpace = this.iconsInThisMenu.length - _loc1_;
      }
      
      public function addGridToMultiSelector() : void
      {
         var _loc1_:MultiSelectionComponent = MultiSelectionComponent.getInstance();
         _loc1_.addGridComponent(this);
      }
      
      public function removeGridFromMultiSelector() : void
      {
         var _loc1_:MultiSelectionComponent = MultiSelectionComponent.getInstance();
         _loc1_.removeGridComponent(this);
      }
      
      public function reDrawGrid() : void
      {
         var _loc1_:int = 0;
         var _loc5_:InventoryItemComponent = null;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         this.rowTracker = 0;
         this.numberOfIconsInThisMenu = 0;
         this.iconsInThisMenu = [];
         var _loc2_:uint = this.gridArranger.allIcons.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc5_ = this.gridArranger.allIcons[_loc3_];
            _loc6_ = _loc3_ % this.ICONS_ACROSS;
            if(this.verticallyAligned)
            {
               _loc7_ = this.rowTracker * _loc5_.height + Math.floor(this.rowTracker / GRID_VERTICAL_SPACING) * this.GAP_AMOUNT + this.startYPos;
               _loc8_ = _loc6_ * _loc5_.width + Math.floor(_loc6_ / GRID_HORIZONTAL_SPACING) * this.GAP_AMOUNT + this.startXPos;
            }
            else
            {
               _loc7_ = _loc6_ * _loc5_.width + Math.floor(_loc6_ / GRID_HORIZONTAL_SPACING) * this.GAP_AMOUNT + this.startXPos;
               _loc8_ = this.rowTracker * _loc5_.height + Math.floor(this.rowTracker / GRID_VERTICAL_SPACING) * this.GAP_AMOUNT + this.startYPos;
            }
            _loc5_.x = _loc7_;
            _loc5_.y = _loc8_;
            _loc5_.col = _loc6_;
            _loc5_.row = this.rowTracker;
            _loc1_ = _loc5_.row * this.ICONS_ACROSS + _loc5_.col;
            this.iconsInThisMenu[_loc1_] = _loc5_;
            if(_loc6_ == this.ICONS_ACROSS - 1)
            {
               ++this.rowTracker;
            }
            ++this.numberOfIconsInThisMenu;
            _loc3_++;
         }
         this.addDragListeners(this.iconsInThisMenu);
         this.giveIconsToGridArranger(this.iconsInThisMenu);
         var _loc4_:ItemFilter = new ItemFilter();
         this.emptyItems = _loc4_.filterBySpecificGroup(ItemFilter.EMPTY_SPACE_FILTER,this.gridArranger.allIcons);
         this.removeDragListeners(this.emptyItems);
      }
      
      public function reDrawGrid_TheSecondComing() : void
      {
         var _loc1_:int = 0;
         var _loc9_:InventoryItemComponent = null;
         var _loc10_:int = 0;
         this.rowTracker = 0;
         this.numberOfIconsInThisMenu = 0;
         this.iconsInThisMenu = [];
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:uint = this.gridArranger.allIcons.length;
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc9_ = this.gridArranger.allIcons[_loc7_];
            _loc10_ = _loc7_ % this.ICONS_ACROSS;
            _loc9_.x = _loc10_ * _loc9_.width + _loc4_;
            _loc9_.y = this.rowTracker * _loc9_.height + _loc5_;
            if(_loc10_ == this.ICONS_ACROSS - 1)
            {
               ++this.rowTracker;
            }
            if(this.rowTracker == this.ICONS_DOWN)
            {
               this.rowTracker = 0;
               _loc2_++;
               _loc4_ = (this.ICONS_ACROSS * this.ITEM_WIDTH + GRID_HORIZONTAL_SPACING) * _loc2_;
            }
            if(_loc2_ == this.BLOCKS_ACROSS)
            {
               _loc3_++;
               _loc5_ = (this.ICONS_DOWN * this.ITEM_HEIGHT + GRID_VERTICAL_SPACING) * _loc3_;
               _loc2_ = 0;
               _loc4_ = 0;
            }
            this.iconsInThisMenu[this.numberOfIconsInThisMenu] = _loc9_;
            ++this.numberOfIconsInThisMenu;
            _loc7_++;
         }
         this.addDragListeners(this.iconsInThisMenu);
         this.giveIconsToGridArranger(this.iconsInThisMenu);
         var _loc8_:ItemFilter = new ItemFilter();
         this.emptyItems = _loc8_.filterBySpecificGroup(ItemFilter.EMPTY_SPACE_FILTER,this.gridArranger.allIcons);
         this.removeDragListeners(this.emptyItems);
      }
      
      public function populateEquipmentSide(param1:SlotSetVO) : void
      {
         var _loc3_:SlotItemVO = null;
         var _loc4_:InventoryItemComponent = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:ItemInstanceVO = null;
         var _loc8_:Dictionary = null;
         var _loc9_:String = null;
         var _loc10_:ITooltipPreparer = null;
         var _loc2_:int = 0;
         for each(_loc3_ in param1.items)
         {
            _loc4_ = this.iconsInThisMenu[_loc2_];
            if(_loc4_ == null)
            {
               return;
            }
            _loc5_ = _loc3_.itemInstance.itemInfo.lootID.split("_");
            _loc6_ = _loc5_.pop();
            _loc7_ = _loc3_.itemInstance;
            _loc4_.changeGraphic(_loc6_);
            _loc4_.group = _loc7_.itemInfo.group.name;
            _loc4_.itemID = _loc7_.ID;
            _loc4_.setLevelText(_loc7_.getLevelValue());
            _loc4_.setModuleHitpointState(_loc7_.getHitPointsInPercent());
            _loc8_ = _loc3_.itemInstance.itemInfo.loka;
            _loc10_ = new DefaultTooltipPreparer(_loc8_[ItemLocalisationKeys.LOCA_FULLNAME],_loc8_[ItemLocalisationKeys.LOCA_SHORT_NAME],_loc3_.itemInstance.quantity,_loc3_.itemInstance.durability,_loc3_.itemInstance.levelText,_loc3_.itemInstance.charges,_loc3_.itemInstance.damageLevel,_loc3_.itemInstance.shieldLevel);
            _loc9_ = _loc10_.getTooltipText();
            this.toolTipControl.addToolTip(_loc4_,_loc9_);
            _loc2_++;
         }
         this.nextFreeSpace = _loc2_;
      }
      
      public function placeDroppedItemFromInventory(param1:InventoryItemComponent) : void
      {
         var _loc2_:InventoryItemComponent = this.iconsInThisMenu[this.nextFreeSpace];
         _loc2_.changeGraphic(param1.itemName);
         _loc2_.group = param1.group;
         _loc2_.itemID = param1.itemID;
         _loc2_.setLevelText(param1.getLevel());
         this.toolTipControl.copyToolTipTo(param1,_loc2_);
         ++this.nextFreeSpace;
      }
      
      public function clearEquippedItemIDsToRemove() : void
      {
         this.lastHangarWideEquippedItemIDsToRemove = [];
      }
      
      public function placeDroppedItemFromEquipment(param1:InventoryItemComponent, param2:Array) : void
      {
         var _loc5_:InventoryItemComponent = null;
         var _loc3_:ItemFilter = new ItemFilter();
         var _loc4_:Array = _loc3_.filterByArrayOfSpecificGroups(param2,this.iconsInThisMenu,true);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc5_ = _loc4_[_loc6_];
            if(_loc5_.itemID == param1.itemID)
            {
               if(_loc5_.equippedInConfigs[Settings.activeConfig] == true)
               {
                  _loc5_.equippedInConfigs[Settings.activeConfig] = false;
                  _loc5_.checkEquippedStatus();
                  break;
               }
            }
            _loc6_++;
         }
      }
      
      public function placeSingleItem(param1:ItemInstanceVO) : void
      {
         var _loc2_:InventoryItemComponent = this.iconsInThisMenu[param1.slot];
         _loc2_.itemID = param1.ID;
         _loc2_.group = param1.itemInfo.group.name;
         _loc2_.sellable = param1.itemInfo.sellable;
         _loc2_.setModuleHitpointState(param1.getHitPointsInPercent());
         _loc2_.setLevelText(param1.getLevelValue());
         _loc2_.setModuleInstalledState(param1.moduleInstalled);
         var _loc3_:int = 0;
         while(_loc3_ < param1.equippedInConfigs.length)
         {
            if(param1.equippedInConfigs[_loc3_] != null)
            {
               _loc2_.equippedInConfigs[_loc3_] = true;
               _loc2_.checkEquippedStatus();
            }
            _loc3_++;
         }
         var _loc4_:Array = param1.itemInfo.lootID.split("_");
         var _loc5_:String = _loc4_.pop();
         if(_loc5_.indexOf(DataInterchange.WORDPUZZLE_ID) != -1 && (param1.wordpuzzleName == DataInterchange.WORDPUZZLE_NAME_HITEC2 || param1.wordpuzzleName == DataInterchange.WORDPUZZLE_NAME_ROCCAT))
         {
            _loc5_ = param1.wordpuzzleValue.toLowerCase();
            _loc2_.lootID = DataInterchange.WORDPUZZLE_ID;
         }
         _loc2_.changeGraphic(_loc5_);
         var _loc6_:ITooltipPreparer = TooltipPreparerFactory.create(_loc2_);
         var _loc7_:String = _loc6_.getTooltipText();
         this.toolTipControl.addToolTip(_loc2_,_loc7_,false,param1.quantity);
         _loc2_.setQuantityValue(param1.quantity);
      }
      
      public function returnItemToOriginalMenu(param1:InventoryItemComponent, param2:Boolean = false) : void
      {
         if(param2)
         {
            param1.changeGraphic("empty");
            param1.group = ItemFilter.EMPTY_SPACE_FILTER;
            param1.itemID = "null";
            param1.removeLevelText();
            this.toolTipControl.removeToolTip(param1);
         }
         this.putThisItemBack(param1);
      }
      
      public function putThisItemBack(param1:InventoryItemComponent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(param1.group == ItemFilter.EMPTY_SPACE_FILTER)
         {
         }
         if(this.verticallyAligned)
         {
            _loc2_ = param1.row * param1.height + Math.floor(param1.row / GRID_VERTICAL_SPACING) * this.GAP_AMOUNT + this.startYPos;
            _loc3_ = param1.col * param1.width + Math.floor(param1.col / GRID_HORIZONTAL_SPACING) * this.GAP_AMOUNT + this.startXPos;
         }
         else
         {
            _loc2_ = param1.col * param1.width + Math.floor(param1.col / GRID_HORIZONTAL_SPACING) * this.GAP_AMOUNT + this.startXPos;
            _loc3_ = param1.row * param1.height + Math.floor(param1.row / GRID_VERTICAL_SPACING) * this.GAP_AMOUNT + this.startYPos;
         }
         param1.x = _loc2_;
         param1.y = _loc3_;
         addChild(param1);
      }
      
      private function giveIconsToGridArranger(param1:Array) : void
      {
         if(this.gridArranger != null)
         {
            this.gridArranger.allIcons = this.iconsInThisMenu;
         }
      }
      
      public function updateStackQuantity(param1:ItemInstanceVO) : void
      {
         var _loc3_:InventoryItemComponent = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.iconsInThisMenu.length)
         {
            _loc3_ = this.iconsInThisMenu[_loc2_];
            if(_loc3_.itemID == param1.ID)
            {
               _loc3_.setQuantityValue(param1.quantity);
            }
            _loc2_++;
         }
      }
      
      public function deleteItem(param1:String) : void
      {
         var _loc3_:InventoryItemComponent = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.iconsInThisMenu.length)
         {
            _loc3_ = this.iconsInThisMenu[_loc2_];
            if(_loc3_.itemID == param1)
            {
               _loc3_.itemID = null;
               _loc3_.quantityField.text = "";
               _loc3_.removeQuantityOverlay();
               _loc3_.group = ItemFilter.EMPTY_SPACE_FILTER;
               _loc3_.equippedInConfigs = [];
               _loc3_.checkEquippedStatus();
               _loc3_.clearModuleHitpointState();
               _loc3_.changeGraphic("empty");
               _loc3_.removeLevelText();
               this.toolTipControl.removeToolTip(_loc3_);
               this.removeDragListeners([_loc3_]);
            }
            _loc2_++;
         }
      }
      
      public function selectItem(param1:String) : void
      {
         var _loc3_:InventoryItemComponent = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.iconsInThisMenu.length)
         {
            _loc3_ = this.iconsInThisMenu[_loc2_];
            if(_loc3_.itemID == param1)
            {
               _loc3_.setSelected();
            }
            _loc2_++;
         }
      }
      
      public function unlockOneSlot() : void
      {
         var _loc2_:InventoryItemComponent = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.iconsInThisMenu.length)
         {
            _loc2_ = this.iconsInThisMenu[_loc1_];
            if(_loc2_.buyableExtraSlot)
            {
               _loc2_.group = ItemFilter.EMPTY_SPACE_FILTER;
               _loc2_.removeUnlockableSlotIcon();
               _loc2_.setDeselected();
               this.removeDragListeners([_loc2_]);
               return;
            }
            _loc1_++;
         }
      }
      
      public function createUnlockableSlots(param1:int) : void
      {
         var _loc5_:InventoryItemComponent = null;
         var _loc2_:int = 0;
         var _loc3_:Array = [];
         var _loc4_:* = int(this.iconsInThisMenu.length - 1);
         while(_loc4_ > 0)
         {
            _loc5_ = this.iconsInThisMenu[_loc4_];
            _loc5_.addUnlockableSlotIcon();
            _loc5_.group = ItemFilter.UNLOCKABLE_ITEM;
            _loc3_.push(_loc5_);
            if(++_loc2_ == param1)
            {
               this.addDragListeners(_loc3_);
               return;
            }
            _loc4_--;
         }
      }
      
      private function setToOriginalCoordinates(param1:InventoryItemComponent, param2:Number, param3:Number) : void
      {
         param1.x = param2 * param1.width + Math.floor(param2 / GRID_HORIZONTAL_SPACING) * this.GAP_AMOUNT + this.startXPos;
         param1.y = param3 * param1.height + Math.floor(param3 / GRID_VERTICAL_SPACING) * this.GAP_AMOUNT + this.startYPos;
      }
      
      public function getStartingYPosition() : Number
      {
         return this.startYPos;
      }
      
      public function getGridRearranger() : GridRearrangeComponent
      {
         return this.gridArranger;
      }
      
      public function getParent() : Object
      {
         return this.parent;
      }
      
      public function getY() : Number
      {
         return this.y;
      }
      
      public function getX() : Number
      {
         return this.x;
      }
      
      public function addThisChild(param1:InventoryItemComponent) : void
      {
         this.addChild(param1);
      }
      
      public function getFilterState() : String
      {
         return this.currentFilter;
      }
      
      public function getObjectType() : String
      {
         return OBJECT_NAME;
      }
      
      public function getContainingViewID() : String
      {
         return this.sectionName;
      }
      
      public function getSlotSetName() : String
      {
         return this.slotSetName;
      }
      
      public function containsIconInThisMenu(param1:String) : Boolean
      {
         var _loc2_:InventoryItemComponent = null;
         for each(_loc2_ in this.iconsInThisMenu)
         {
            if(_loc2_.itemID == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function injectHangarManager(param1:HangarManagerProxy) : void
      {
         this.hangarManager = param1;
      }
      
      public function set dragGroupID(param1:int) : void
      {
         this._dragGroupID = param1;
      }
      
      public function get dragGroupID() : int
      {
         return this._dragGroupID;
      }
   }
}

