package net.bigpoint.darkorbit.equipment.view.components.items
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   
   public class MultiSelectionComponent extends Sprite
   {
      
      private static var _instance:MultiSelectionComponent;
      
      public var allGrids:Array = [];
      
      public var dragComp:DragComponent;
      
      public var gridBeingChecked:GridComponent;
      
      public var controlButtonDown:Boolean = false;
      
      public var shiftButtonDown:Boolean = false;
      
      private var selectionBox:Sprite = new Sprite();
      
      private var initialClickPoint:Point = new Point();
      
      private var collisionCheck:Function;
      
      private var currentlySelectedItems:Array = [];
      
      private var isEnabled:Boolean = false;
      
      private var mouseDown:Boolean = false;
      
      public function MultiSelectionComponent(param1:Function)
      {
         super();
         if(param1 != hidden)
         {
            throw new Error("MultiSelectionComponent is a Singleton and can only be accessed through MultiSelectionComponent.getInstance()");
         }
      }
      
      public static function getInstance() : MultiSelectionComponent
      {
         if(_instance == null)
         {
            _instance = new MultiSelectionComponent(hidden);
         }
         return _instance;
      }
      
      private static function hidden() : void
      {
      }
      
      public function addListeners() : void
      {
         if(stage)
         {
            this.init();
         }
         else
         {
            this.addEventListener(Event.ADDED_TO_STAGE,this.handleStageAddedEvent);
         }
      }
      
      public function removeListeners() : void
      {
         if(stage)
         {
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseClicked);
         }
      }
      
      private function handleStageAddedEvent(param1:Event) : void
      {
         this.removeEventListener(Event.ADDED_TO_STAGE,this.handleStageAddedEvent);
         this.init();
      }
      
      private function init() : void
      {
         stage.addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseClicked);
         stage.addChild(this.selectionBox);
         this.selectionBox.mouseEnabled = false;
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDown);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.handleKeyReleased);
      }
      
      private function handleKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.SHIFT && !this.shiftButtonDown)
         {
            this.shiftButtonDown = true;
         }
         else if(param1.keyCode == Keyboard.CONTROL && !this.dragComp.controlButtonDown)
         {
            this.dragComp.controlButtonDown = true;
         }
      }
      
      private function handleKeyReleased(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.SHIFT && this.shiftButtonDown)
         {
            this.shiftButtonDown = false;
         }
         else if(param1.keyCode == Keyboard.CONTROL && this.dragComp.controlButtonDown)
         {
            this.dragComp.controlButtonDown = false;
         }
      }
      
      private function handleMouseClicked(param1:MouseEvent) : void
      {
         if(!this.isEnabled)
         {
            return;
         }
         this.removeSelectedStatusFromAllItems();
         this.currentlySelectedItems = [];
         this.initialClickPoint.x = mouseX;
         this.initialClickPoint.y = mouseY;
         this.mouseDown = true;
         var _loc2_:Boolean = true;
         if(_loc2_)
         {
            this.collisionCheck = this.checkForFirstCollision;
            stage.addEventListener(Event.ENTER_FRAME,this.handleEnterFrameEvent);
            stage.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseReleased);
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMoved);
         }
      }
      
      private function handleEnterFrameEvent(param1:Event) : void
      {
         var _loc2_:int = stage.mouseX;
         var _loc3_:int = stage.mouseY;
         if(this.mouseDown)
         {
            if(_loc2_ <= 0 || _loc3_ <= 0 || _loc3_ >= Settings.WINDOW_HEIGHT || _loc2_ >= Settings.WINDOW_WIDTH)
            {
               this.handleMouseReleased(param1);
            }
            else
            {
               this.selectionBox.filters = [];
            }
         }
      }
      
      private function handleMouseMoved(param1:MouseEvent) : void
      {
         this.selectionBox.filters = [];
         stage.setChildIndex(this.selectionBox,stage.numChildren - 1);
         this.selectionBox.graphics.clear();
         this.selectionBox.graphics.beginFill(13816530,1);
         this.selectionBox.graphics.lineStyle(1,16434692);
         this.selectionBox.graphics.drawRect(this.initialClickPoint.x,this.initialClickPoint.y,mouseX - this.initialClickPoint.x,mouseY - this.initialClickPoint.y);
         this.selectionBox.graphics.endFill();
         this.selectionBox.alpha = 0.4;
         param1.updateAfterEvent();
         this.collisionCheck();
      }
      
      private function checkForFirstCollision() : void
      {
         var _loc2_:GridComponent = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:InventoryItemComponent = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.allGrids.length)
         {
            _loc2_ = this.allGrids[_loc1_];
            _loc3_ = _loc2_.iconsInThisMenu;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = _loc3_[_loc4_];
               if(stage.contains(_loc5_))
               {
                  if(_loc5_.hitTestObject(this.selectionBox))
                  {
                     this.collisionCheck = this.checkCollisionsForSpecificGrid;
                     this.gridBeingChecked = _loc2_;
                     break;
                  }
               }
               _loc4_++;
            }
            _loc1_++;
         }
      }
      
      private function checkCollisionsForSpecificGrid() : void
      {
         var _loc3_:InventoryItemComponent = null;
         var _loc4_:int = 0;
         var _loc1_:Array = this.gridBeingChecked.iconsInThisMenu;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            if(stage.contains(_loc3_) && _loc3_.canBeSelected && _loc3_.group != ItemFilter.EMPTY_SPACE_FILTER && !_loc3_.buyableExtraSlot)
            {
               if(_loc3_.hitTestObject(this.selectionBox))
               {
                  if(this.currentlySelectedItems.indexOf(_loc3_) == -1)
                  {
                     this.currentlySelectedItems.push(_loc3_);
                  }
                  _loc3_.setSelected();
               }
               else
               {
                  _loc4_ = int(this.currentlySelectedItems.indexOf(_loc3_));
                  if(_loc4_ != -1)
                  {
                     this.currentlySelectedItems.splice(_loc4_,1);
                  }
                  _loc3_.setDeselected();
               }
            }
            _loc2_++;
         }
      }
      
      public function resetAllIconsSelectedStatus() : void
      {
         var _loc2_:InventoryItemComponent = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.currentlySelectedItems.length)
         {
            _loc2_ = this.currentlySelectedItems[_loc1_];
            if(_loc2_.canBeSelected)
            {
               _loc2_.setDeselected();
            }
            _loc1_++;
         }
      }
      
      public function removeSelectedStatusFromAllItems() : void
      {
         var _loc2_:GridComponent = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:InventoryItemComponent = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.allGrids.length)
         {
            _loc2_ = this.allGrids[_loc1_];
            _loc3_ = _loc2_.iconsInThisMenu;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = _loc3_[_loc4_];
               _loc5_.setDeselected();
               _loc4_++;
            }
            _loc1_++;
         }
         this.dragComp.shiftButtonDown = this.shiftButtonDown;
         this.dragComp.controlButtonDown = this.controlButtonDown;
      }
      
      private function handleMouseReleased(param1:Event) : void
      {
         this.mouseDown = false;
         this.dragComp.shiftButtonDown = this.shiftButtonDown;
         this.dragComp.controlButtonDown = this.controlButtonDown;
         this.dragComp.multiSelection = this.currentlySelectedItems;
         this.selectionBox.graphics.clear();
         stage.removeEventListener(Event.ENTER_FRAME,this.handleEnterFrameEvent);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.handleMouseReleased);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMoved);
      }
      
      public function addGridComponent(param1:GridComponent) : void
      {
         this.allGrids.push(param1);
      }
      
      public function removeGridComponent(param1:GridComponent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.allGrids.length)
         {
            if(this.allGrids[_loc2_] == param1)
            {
               this.allGrids.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
      
      public function enable() : void
      {
         this.isEnabled = true;
      }
      
      public function disable() : void
      {
         this.isEnabled = false;
      }
   }
}

