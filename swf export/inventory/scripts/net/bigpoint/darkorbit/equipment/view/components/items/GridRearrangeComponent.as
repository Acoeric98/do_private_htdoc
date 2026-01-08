package net.bigpoint.darkorbit.equipment.view.components.items
{
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.equipment.events.ActionIdentifiers;
   import net.bigpoint.darkorbit.equipment.events.GridEvent;
   
   public class GridRearrangeComponent extends Sprite
   {
      
      private var grabbedIconOriginalGridPos:Point = new Point();
      
      private var grabbedIconOriginalActualPos:Point = new Point();
      
      private var oldGridPos:Point;
      
      private var currentGridPos:Point;
      
      private var lastCalculatedGridPos:Point;
      
      public var allIcons:Array;
      
      public var rearrangeActive:Boolean = true;
      
      public var currentlyGrabbedItem:InventoryItemComponent;
      
      private var currentDisplacedItem:InventoryItemComponent;
      
      public function GridRearrangeComponent(param1:Array)
      {
         super();
         this.allIcons = param1;
      }
      
      public function dispatchFillInGapEvent(param1:int) : void
      {
         dispatchEvent(new GridEvent(GridEvent.FILL_IN_GAP,param1));
      }
      
      public function dispatchReOrderGridEvent() : void
      {
         dispatchEvent(new GridEvent(GridEvent.RE_ORDER_GRID,0));
      }
      
      public function mouseMoveCallback() : void
      {
         this.lastCalculatedGridPos = this.currentGridPos;
         this.currentDisplacedItem = this.findGridSpaceCoordinates(this.currentlyGrabbedItem);
      }
      
      public function defineGrabbedIcon(param1:InventoryItemComponent, param2:InventoryItemComponent) : void
      {
         this.currentlyGrabbedItem = param1;
         this.grabbedIconOriginalActualPos.x = param2.x;
         this.grabbedIconOriginalActualPos.y = param2.y;
      }
      
      public function mouseReleaseCallback() : Dictionary
      {
         var _loc4_:int = 0;
         var _loc5_:InventoryItemComponent = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc1_:Dictionary = new Dictionary();
         var _loc2_:Number = 0.5;
         if(this.currentlyGrabbedItem == null)
         {
            return null;
         }
         var _loc3_:GridComponent = this.currentlyGrabbedItem.menuSectionComponent as GridComponent;
         if(this.currentDisplacedItem != null && this.rearrangeActive)
         {
            if(this.currentlyGrabbedItem.indexInGrid != this.currentDisplacedItem.indexInGrid)
            {
               _loc4_ = this.currentDisplacedItem.indexInGrid;
               _loc5_ = this.allIcons[_loc4_];
               _loc1_[ActionIdentifiers.SWAPPED_ITEM_INDEX] = String(_loc5_.indexInGrid);
               _loc6_ = _loc5_.x;
               _loc7_ = _loc5_.y;
               _loc1_[ActionIdentifiers.SWAPPED_ITEM_NEW_POS] = this.grabbedIconOriginalActualPos;
               _loc1_[ActionIdentifiers.SWAPPED_ITEM_GROUP] = _loc5_.group;
               _loc1_[ActionIdentifiers.DRAGGED_ITEM_QUANTITY] = this.currentlyGrabbedItem.quantity;
               _loc1_[ActionIdentifiers.DRAGGED_ITEM_INDEX] = this.currentlyGrabbedItem.itemID;
               _loc1_[ActionIdentifiers.DRAGGED_ITEM_NEW_POS] = new Point(_loc6_,_loc7_);
            }
            else
            {
               _loc1_[ActionIdentifiers.PUT_DRAGGED_ITEM_BACK_FUNCTION] = this.putGrabbedItemInSamePosition;
            }
         }
         else
         {
            _loc1_[ActionIdentifiers.PUT_DRAGGED_ITEM_BACK_FUNCTION] = this.putGrabbedItemInSamePosition;
         }
         this.currentGridPos = null;
         this.oldGridPos = null;
         this.lastCalculatedGridPos = null;
         this.currentlyGrabbedItem = new InventoryItemComponent();
         this.currentDisplacedItem = null;
         return _loc1_;
      }
      
      public function swapItemPositions(param1:int, param2:int) : void
      {
         var _loc3_:InventoryItemComponent = this.allIcons[param1];
         var _loc4_:InventoryItemComponent = this.allIcons[param2];
         _loc3_.menuSectionComponent.addThisChild(_loc3_);
         _loc3_.alpha = 1;
         var _loc5_:int = _loc3_.col;
         var _loc6_:int = _loc3_.row;
         var _loc7_:int = _loc4_.col;
         var _loc8_:int = _loc4_.row;
         var _loc9_:Number = this.grabbedIconOriginalActualPos.x;
         var _loc10_:Number = this.grabbedIconOriginalActualPos.y;
         var _loc11_:Number = _loc4_.x;
         var _loc12_:Number = _loc4_.y;
         _loc3_.col = _loc7_;
         _loc3_.row = _loc8_;
         _loc4_.col = _loc5_;
         _loc4_.row = _loc6_;
         _loc3_.x = _loc11_;
         _loc3_.y = _loc12_;
         _loc4_.x = _loc9_;
         _loc4_.y = _loc10_;
         _loc3_.indexInGrid = param2;
         _loc4_.indexInGrid = param1;
         this.allIcons[param2] = _loc3_;
         this.allIcons[param1] = _loc4_;
         this.grabbedIconOriginalActualPos = new Point();
      }
      
      public function putGrabbedItemInSamePosition() : void
      {
      }
      
      public function findGridSpaceCoordinates(param1:InventoryItemComponent) : InventoryItemComponent
      {
         var _loc11_:InventoryItemComponent = null;
         var _loc13_:InventoryItemComponent = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc2_:Number = 0;
         var _loc3_:Point = null;
         var _loc4_:Number = param1.x - (param1.menuSectionComponent.getParent().x + param1.menuSectionComponent.getX());
         var _loc5_:Number = param1.y - (param1.menuSectionComponent.getParent().y + param1.menuSectionComponent.getStartingYPosition() + param1.menuSectionComponent.getY());
         var _loc6_:Number = _loc4_;
         var _loc7_:Number = _loc5_;
         var _loc8_:Number = _loc6_ + param1.width;
         var _loc9_:Number = _loc7_ + param1.height;
         var _loc10_:GridComponent = this.currentlyGrabbedItem.menuSectionComponent as GridComponent;
         var _loc12_:int = 0;
         while(_loc12_ < this.allIcons.length)
         {
            _loc13_ = this.allIcons[_loc12_];
            if(_loc13_)
            {
               _loc14_ = _loc13_.x;
               _loc15_ = _loc13_.y;
               _loc16_ = _loc14_ + param1.width;
               _loc17_ = _loc15_ + param1.height;
               if(_loc14_ <= _loc8_ && _loc16_ >= _loc6_ && _loc15_ <= _loc9_ && _loc17_ >= _loc7_)
               {
                  if(_loc16_ < _loc8_)
                  {
                     _loc18_ = _loc16_ - _loc6_;
                  }
                  else
                  {
                     _loc18_ = _loc8_ - _loc14_;
                  }
                  if(_loc17_ < _loc9_)
                  {
                     _loc19_ = _loc17_ - _loc7_;
                  }
                  else
                  {
                     _loc19_ = _loc9_ - _loc15_;
                  }
                  _loc20_ = _loc18_ * _loc19_;
                  if(_loc20_ > _loc2_)
                  {
                     _loc2_ = _loc20_;
                     _loc11_ = _loc13_;
                  }
               }
            }
            _loc12_++;
         }
         return _loc11_;
      }
   }
}

