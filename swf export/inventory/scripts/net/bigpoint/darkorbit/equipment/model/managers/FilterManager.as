package net.bigpoint.darkorbit.equipment.model.managers
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.equipment.view.components.items.ItemFilter;
   
   public class FilterManager
   {
      
      private static var _instance:FilterManager;
      
      public static const FILTER_AMMUNITION:String = "filter_ammunition";
      
      public static const FILTER_DRONE_RELATED:String = "filter_drone_related";
      
      public static const FILTER_EXTRAS:String = "filter_extras";
      
      public static const FILTER_GENERATORS:String = "filter_generators";
      
      public static const FILTER_RESSOURCES:String = "filter_resources";
      
      public static const FILTER_USER:String = "filter_user";
      
      public static const FILTER_WEAPONS:String = "filter_weapons";
      
      public static const FILTER_MODULES:String = "filter_modules";
      
      public var filters:Dictionary = new Dictionary();
      
      public var lootIDMap:Array = [];
      
      public var typeMap:Array = [];
      
      public function FilterManager(param1:Function)
      {
         super();
         if(param1 != hidden)
         {
            throw new Error("FilterManager is a Singleton and can only be accessed through FilterManager.getInstance()");
         }
      }
      
      public static function getInstance() : FilterManager
      {
         if(_instance == null)
         {
            _instance = new FilterManager(hidden);
         }
         return _instance;
      }
      
      private static function hidden() : void
      {
      }
      
      public function init(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         this.filters = new Dictionary();
         for(_loc2_ in param1)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = this.getGroupKeysFromArray(_loc3_);
            this.filters["filter_" + _loc2_] = _loc4_;
         }
         this.filters["filter_user"] = new Array(ItemFilter.USER_FILTER);
      }
      
      public function initNameMaps(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1.lootIds != null)
         {
            this.lootIDMap = [];
            _loc2_ = int(param1.lootIds.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               this.lootIDMap.push(param1.lootIds[_loc3_]);
               _loc3_++;
            }
         }
         if(param1.types != null)
         {
            this.typeMap = [];
            _loc4_ = int(param1.types.length);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               this.typeMap.push(param1.types[_loc3_]);
               _loc3_++;
            }
         }
      }
      
      public function getFilter(param1:String) : Array
      {
         return this.filters[param1];
      }
      
      public function getGroupKeysFromArray(param1:Array) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(this.typeMap[param1[_loc3_]]);
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

