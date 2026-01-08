package net.bigpoint.darkorbit.equipment.model.managers
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInfoVO;
   import net.bigpoint.dataInterchange.DataInterchange;
   
   public class ItemInfoManager
   {
      
      private static var _instance:ItemInfoManager;
      
      public var items:Dictionary = new Dictionary();
      
      public function ItemInfoManager(param1:Function)
      {
         super();
         if(param1 != hidden)
         {
            throw new Error("ItemInfoManager is a Singleton and can only be accessed through ItemInfoManager.getInstance()");
         }
      }
      
      public static function getInstance() : ItemInfoManager
      {
         if(_instance == null)
         {
            _instance = new ItemInfoManager(hidden);
         }
         return _instance;
      }
      
      private static function hidden() : void
      {
      }
      
      public function init(param1:Array, param2:String = "") : void
      {
         var _loc6_:Object = null;
         var _loc7_:ItemInfoVO = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         this.items = new Dictionary();
         var _loc3_:ItemGroupManager = ItemGroupManager.getInstance();
         var _loc4_:FilterManager = FilterManager.getInstance();
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc6_ = param1[_loc5_];
            _loc7_ = new ItemInfoVO();
            _loc7_.name = _loc6_[DataInterchange.ITEM_NAME];
            _loc7_.group = _loc3_.getGroup(_loc4_.typeMap[_loc6_[DataInterchange.ITEM_GROUP]]);
            _loc7_.lootID = _loc4_.lootIDMap[_loc6_[DataInterchange.ITEM_LOOT_ID]];
            _loc8_ = _loc7_.lootID.split("_");
            _loc7_.graphicKey = _loc8_.pop();
            _loc7_.elite = _loc6_[DataInterchange.ITEM_ELITE] != undefined && _loc6_[DataInterchange.ITEM_ELITE] == 1;
            _loc7_.shopDeepLink = _loc6_[DataInterchange.SHOP_DEEP_LINK];
            _loc7_.defineLokaKeysInfo();
            if(_loc6_[DataInterchange.REPAIR_PRICE] != null)
            {
               _loc7_.repairPrice = _loc6_[DataInterchange.REPAIR_PRICE];
               Settings.DRONE_REPAIR_COST = _loc6_[DataInterchange.REPAIR_PRICE];
            }
            if(_loc6_[DataInterchange.RENAME_PRICE] != null)
            {
               _loc7_.renamePrice = _loc6_[DataInterchange.RENAME_PRICE];
               Settings.PET_RENAME_COST = _loc6_[DataInterchange.RENAME_PRICE];
            }
            if(_loc6_[DataInterchange.COST_WEAPON_SLOT] != null)
            {
               Settings.PET_LASER_SLOT_PRICES = _loc6_[DataInterchange.COST_WEAPON_SLOT];
            }
            if(_loc6_[DataInterchange.COST_GENERATOR_SLOT] != null)
            {
               Settings.PET_GENERATOR_SLOT_PRICES = _loc6_[DataInterchange.COST_GENERATOR_SLOT];
            }
            if(_loc6_[DataInterchange.COST_GEAR_SLOT] != null)
            {
               Settings.PET_GEAR_SLOT_PRICES = _loc6_[DataInterchange.COST_GEAR_SLOT];
            }
            if(_loc6_[DataInterchange.COST_PROTOCOL_SLOT] != null)
            {
               Settings.PET_PROTOCOL_SLOT_PRICES = _loc6_[DataInterchange.COST_PROTOCOL_SLOT];
            }
            if(_loc6_[DataInterchange.FACTION_DEPENDED] != null)
            {
               _loc7_.factionDepended = _loc6_[DataInterchange.FACTION_DEPENDED];
               _loc7_.factionID = param2;
            }
            if(_loc6_[DataInterchange.TEXT_REPLACEMENTS] != null)
            {
               _loc7_.textReplacements = _loc6_[DataInterchange.TEXT_REPLACEMENTS];
            }
            _loc9_ = _loc6_[DataInterchange.LEVELS_KEY];
            this.processLevelSpecificInformation(_loc7_,_loc9_);
            this.items[_loc7_.lootID] = _loc7_;
            _loc5_++;
         }
      }
      
      private function processLevelSpecificInformation(param1:ItemInfoVO, param2:Array) : void
      {
         var _loc4_:Object = null;
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            _loc4_ = param2[_loc3_];
            if(_loc4_[DataInterchange.ITEM_SLOTSETS] != null)
            {
               param1.rawSlotSetInfoByLevel[_loc3_] = _loc4_[DataInterchange.ITEM_SLOTSETS];
            }
            if(_loc4_[DataInterchange.ITEM_SELLING] != null)
            {
               param1.saleValuesByLevel[_loc3_] = _loc4_[DataInterchange.ITEM_SELLING][DataInterchange.ITEM_CREDITS_VALUE];
            }
            else
            {
               param1.sellable = false;
            }
            if(_loc4_[DataInterchange.CDN_KEYS] != null)
            {
               param1.populateCdnDictionary(_loc3_,_loc4_[DataInterchange.CDN_KEYS]);
            }
            if(_loc4_[DataInterchange.TEXT_REPLACE_KEYS] != null)
            {
               param1.populateReplacementTextKeysDict(_loc3_,_loc4_[DataInterchange.TEXT_REPLACE_KEYS]);
            }
            _loc3_++;
         }
      }
      
      public function getItemInfo(param1:String) : ItemInfoVO
      {
         return this.items[param1];
      }
   }
}

