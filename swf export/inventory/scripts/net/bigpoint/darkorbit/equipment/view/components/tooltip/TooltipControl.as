package net.bigpoint.darkorbit.equipment.view.components.tooltip
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.equipment.view.components.items.InventoryItemComponent;
   
   public class TooltipControl
   {
      
      private static var _instance:TooltipControl;
      
      public static const WILDCARD:String = "%%";
      
      private var toolTipsList:Array;
      
      private var tooltipDict:Dictionary;
      
      private var bounds:Rectangle;
      
      private var scaleFactor:Number;
      
      private var t:Timer;
      
      public function TooltipControl(param1:Function)
      {
         var _loc2_:String = null;
         this.tooltipDict = new Dictionary();
         super();
         if(param1 !== hidden)
         {
            _loc2_ = "TooltipControl is a Singleton and can only be accessed through TooltipControl.getInstance()";
            throw new Error(_loc2_);
         }
         this.init();
      }
      
      private static function hidden() : void
      {
      }
      
      public static function getInstance() : TooltipControl
      {
         if(_instance == null)
         {
            _instance = new TooltipControl(hidden);
         }
         return _instance;
      }
      
      private function init() : void
      {
         this.toolTipsList = [];
      }
      
      public function addToolTip(param1:DisplayObject, param2:String, param3:Boolean = false, param4:int = 0) : ToolTipHook
      {
         if(param2.length < 1)
         {
            return null;
         }
         this.removeToolTip(param1);
         var _loc5_:ToolTipHook = new ToolTipHook(param1,param2,param3,param4);
         _loc5_.setBounds(this.bounds);
         this.toolTipsList.push(_loc5_);
         this.tooltipDict[param1] = _loc5_;
         return _loc5_;
      }
      
      public function setBounds(param1:Rectangle) : void
      {
         this.bounds = param1;
      }
      
      public function setScaleFactor(param1:Number) : void
      {
         this.scaleFactor = param1;
      }
      
      public function removeToolTip(param1:Object) : void
      {
         if(this.tooltipDict[param1])
         {
            this.tooltipDict[param1].suicide();
            this.tooltipDict[param1] = null;
            delete this.tooltipDict[param1];
         }
      }
      
      public function removeFromStageOnly(param1:Object) : void
      {
         if(this.tooltipDict[param1])
         {
            this.tooltipDict[param1].removeFromStageOnly();
            delete this.tooltipDict[param1];
         }
      }
      
      public function setHiddenStatus(param1:Object, param2:Boolean) : void
      {
         var _loc3_:ToolTipHook = this.tooltipDict[param1];
         if(_loc3_ == null)
         {
            return;
         }
         switch(param2)
         {
            case true:
               _loc3_.addListeners();
               break;
            case false:
               _loc3_.removeListeners();
         }
      }
      
      public function copyToolTipTo(param1:InteractiveObject, param2:InteractiveObject) : void
      {
         var _loc3_:String = null;
         if(this.tooltipDict[param1])
         {
            _loc3_ = this.tooltipDict[param1].getToolTipText();
            this.addToolTip(param2,_loc3_);
         }
      }
      
      public function hideAllToolTips() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.toolTipsList.length)
         {
            if(this.toolTipsList[_loc1_] != undefined && this.toolTipsList[_loc1_] != null)
            {
               ToolTipHook(this.toolTipsList[_loc1_]).hideTooltip();
            }
            _loc1_++;
         }
      }
      
      public function getScaleFactor() : Number
      {
         return this.scaleFactor;
      }
      
      public function getInventoryItemToolTip(param1:InventoryItemComponent) : ToolTipHook
      {
         return this.tooltipDict[param1];
      }
   }
}

