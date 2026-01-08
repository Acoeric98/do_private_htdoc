package net.bigpoint.darkorbit.equipment.view.components.items
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.model.managers.FilterManager;
   
   public class ItemFilter
   {
      
      public static const USER_FILTER:String = "user";
      
      public static const CONTEXT_FILTER:String = "context_filter";
      
      public static const LASER_FILTER:String = "laser";
      
      public static const HEAVY_GUNS_FILTER:String = "heavy_gun";
      
      public static const GENERATORS_FILTER:String = "generator";
      
      public static const EXTRAS_FILTER:String = "extra";
      
      public static const EMPTY_SHIP_POSFTFIX:String = ".ship";
      
      public static const EMPTY_PET_POSFTFIX:String = ".pet";
      
      public static const EMPTY_SPACE_FILTER:String = "xxxempty";
      
      public static const UNLOCKABLE_ITEM:String = "zzzunlockable";
      
      public static const UNKNOWN_FILTER:String = "unknown";
      
      public static const ALPHA_DESCEND_FILTER:String = "alpha_dec";
      
      public static const ALPHA_ASCEND_FILTER:String = "alpha_acc";
      
      private var filterManager:FilterManager;
      
      public function ItemFilter()
      {
         super();
         this.filterManager = FilterManager.getInstance();
      }
      
      public function filterByParentGroup(param1:String, param2:Array, param3:Boolean = false) : Array
      {
         var _loc6_:InventoryItemComponent = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         while(_loc5_ < param2.length)
         {
            _loc6_ = param2[_loc5_];
            _loc7_ = this.filterManager.getFilter(param1);
            _loc8_ = _loc6_.group;
            _loc9_ = 0;
            while(_loc9_ < _loc7_.length)
            {
               _loc10_ = _loc7_[_loc9_];
               if(_loc8_ == _loc10_)
               {
                  if(!param3)
                  {
                     if(_loc6_.equippedInConfigs[Settings.activeConfig] == false || _loc6_.equippedInConfigs[Settings.activeConfig] == undefined)
                     {
                        _loc4_.push(_loc6_);
                     }
                  }
                  else
                  {
                     _loc4_.push(_loc6_);
                  }
               }
               _loc9_++;
            }
            _loc5_++;
         }
         return this.sortAllItemsByGroup(_loc4_);
      }
      
      public function filterBySpecificGroup(param1:String, param2:Array, param3:Boolean = false) : Array
      {
         var _loc6_:InventoryItemComponent = null;
         var _loc7_:String = null;
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         while(_loc5_ < param2.length)
         {
            _loc6_ = param2[_loc5_];
            _loc7_ = _loc6_.group;
            if(_loc7_ == param1)
            {
               if(!param3)
               {
                  if(_loc6_.equippedInConfigs[Settings.activeConfig] == false || _loc6_.equippedInConfigs[Settings.activeConfig] == undefined)
                  {
                     _loc4_.push(_loc6_);
                  }
               }
               else
               {
                  _loc4_.push(_loc6_);
               }
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function filterByArrayOfSpecificGroups(param1:Array, param2:Array, param3:Boolean = false) : Array
      {
         var _loc6_:Array = null;
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc6_ = this.filterBySpecificGroup(param1[_loc5_],param2,param3);
            _loc4_ = _loc4_.concat(_loc6_);
            _loc5_++;
         }
         return this.sortAllItemsByGroup(_loc4_);
      }
      
      public function getItemsNotInOtherArray(param1:Array, param2:Array) : Array
      {
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if(param2.indexOf(param1[_loc4_]) == -1)
            {
               _loc3_.push(param1[_loc4_]);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function sortAllItemsByGroup(param1:Array) : Array
      {
         var _loc5_:InventoryItemComponent = null;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc2_:Array = [];
         var _loc3_:Dictionary = new Dictionary();
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = param1[_loc4_];
            _loc6_ = _loc5_.group;
            if(_loc3_[_loc6_] == undefined)
            {
               _loc7_ = new Array();
               _loc7_.push(_loc5_);
               _loc3_[_loc6_] = _loc7_;
               _loc2_.push(_loc6_);
            }
            else
            {
               _loc8_ = _loc3_[_loc6_];
               _loc8_.push(_loc5_);
            }
            _loc4_++;
         }
         this.sortAllIndividualGroupArrays(_loc3_);
         _loc2_.sort();
         return this.putSortedItemsInSingleArray(_loc2_,_loc3_);
      }
      
      private function sortAllIndividualGroupArrays(param1:Dictionary) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in param1)
         {
            param1[_loc2_].sortOn("itemName",Array.DESCENDING);
         }
      }
      
      private function putSortedItemsInSingleArray(param1:Array, param2:Dictionary) : Array
      {
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc6_ = param1[_loc5_];
            _loc7_ = param2[_loc6_];
            _loc8_ = 0;
            while(_loc8_ < _loc7_.length)
            {
               _loc3_[_loc4_] = _loc7_[_loc8_];
               _loc4_++;
               _loc8_++;
            }
            _loc5_++;
         }
         return _loc3_;
      }
   }
}

