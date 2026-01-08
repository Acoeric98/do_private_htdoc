package net.bigpoint.darkorbit.equipment.model.VO
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInfoVO;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInstanceVO;
   import net.bigpoint.darkorbit.equipment.model.managers.FilterManager;
   import net.bigpoint.darkorbit.equipment.model.managers.ItemInfoManager;
   import net.bigpoint.dataInterchange.DataInterchange;
   
   public class Inventory
   {
      
      private static var _instance:Inventory = new Inventory();
      
      public var items:Dictionary;
      
      public function Inventory()
      {
         super();
         if(_instance != null)
         {
            throw new Error("Inventory is a Singleton and can only be accessed through Inventory.getInstance()");
         }
      }
      
      public static function getInstance() : Inventory
      {
         return _instance;
      }
      
      public function init(param1:Array) : void
      {
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:ItemInstanceVO = null;
         var _loc9_:Object = null;
         var _loc10_:Boolean = false;
         this.items = new Dictionary();
         var _loc2_:FilterManager = FilterManager.getInstance();
         var _loc3_:ItemInfoManager = ItemInfoManager.getInstance();
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = param1[_loc4_];
            _loc6_ = _loc5_[DataInterchange.ITEM_ID];
            _loc7_ = _loc2_.lootIDMap[_loc5_[DataInterchange.ITEM_LOOT_ID]];
            _loc8_ = new ItemInstanceVO(_loc3_.getItemInfo(_loc7_));
            if(_loc5_[DataInterchange.ITEM_QUANTITY])
            {
               _loc8_.quantity = _loc5_[DataInterchange.ITEM_QUANTITY];
            }
            _loc8_.ID = _loc6_;
            _loc8_.slot = _loc5_[DataInterchange.ITEM_SLOT];
            if(_loc5_[DataInterchange.PROPERTIES] != null)
            {
               _loc9_ = _loc5_[DataInterchange.PROPERTIES];
               _loc8_.attachedAmmo = _loc9_[DataInterchange.PROPERTY_ATTACHED_AMMO];
               _loc8_.installDate = _loc9_[DataInterchange.PROPERTY_INSTALL_DATE];
               _loc8_.wordpuzzleName = _loc9_[DataInterchange.WORDPUZZLE_EVENTNAME];
               _loc8_.wordpuzzlePos = _loc9_[DataInterchange.WORDPUZZLE_POS];
               _loc8_.wordpuzzleValue = _loc9_[DataInterchange.WORDPUZZLE_VALUE];
               _loc8_.durabilityUpgradeLevel = _loc9_[DataInterchange.PROPERTY_DURABILITY_UPGRADE_LEVEL];
            }
            if(_loc5_[DataInterchange.MAXIMAL_HIT_POINTS] != null)
            {
               _loc8_.maxHitPoints = _loc5_[DataInterchange.MAXIMAL_HIT_POINTS];
            }
            if(_loc5_[DataInterchange.ITEM_HITPOINTS] != null)
            {
               _loc8_.hitPoints = _loc5_[DataInterchange.ITEM_HITPOINTS];
            }
            if(_loc5_[DataInterchange.REPAIR_COSTS] != null)
            {
               _loc8_.repairCosts = _loc5_[DataInterchange.REPAIR_COSTS];
            }
            if(_loc5_[DataInterchange.BOOSTER_LEVEL] != null)
            {
               _loc8_.boosterLevel = _loc5_[DataInterchange.BOOSTER_LEVEL];
            }
            if(_loc5_[DataInterchange.MINUTE_LEVEL] != null)
            {
               _loc8_.minuteLevel = _loc5_[DataInterchange.MINUTE_LEVEL];
            }
            if(_loc5_[DataInterchange.DURABILITY_LEVEL] != null)
            {
               _loc8_.durabilityLevel = _loc5_[DataInterchange.DURABILITY_LEVEL];
            }
            if(_loc5_[DataInterchange.REPAIR_LEVEL] != null)
            {
               _loc8_.repairLevel = _loc5_[DataInterchange.REPAIR_LEVEL];
            }
            if(_loc5_[DataInterchange.MODULE_INSTALLED] != null)
            {
               _loc10_ = Boolean(_loc5_[DataInterchange.MODULE_INSTALLED]);
               _loc8_.moduleInstalled = _loc10_;
            }
            if(_loc5_[DataInterchange.KEY_BATTLESTATION_NAME] != null)
            {
               _loc8_.battleStationName = _loc5_[DataInterchange.KEY_BATTLESTATION_NAME];
            }
            if(_loc5_[DataInterchange.LEVEL] != null)
            {
               _loc8_.level = int(_loc5_[DataInterchange.LEVEL]);
            }
            else
            {
               _loc8_.level = 0;
            }
            if(_loc5_[DataInterchange.LEVEL_TEXT] != null)
            {
               _loc8_.levelText = _loc5_[DataInterchange.LEVEL_TEXT];
            }
            if(_loc5_[DataInterchange.DURABILITY] != null)
            {
               _loc8_.durability = _loc5_[DataInterchange.DURABILITY];
            }
            if(_loc5_[DataInterchange.CHARGES] != null)
            {
               _loc8_.charges = _loc5_[DataInterchange.CHARGES];
            }
            if(_loc5_[DataInterchange.DAMAGE_LEVEL] != null)
            {
               _loc8_.damageLevel = _loc5_[DataInterchange.DAMAGE_LEVEL];
            }
            if(_loc5_[DataInterchange.SHIELD_LEVEL] != null)
            {
               _loc8_.shieldLevel = _loc5_[DataInterchange.SHIELD_LEVEL];
            }
            this.items[_loc6_] = _loc8_;
            _loc4_++;
         }
      }
      
      public function addItem(param1:String, param2:Object) : ItemInstanceVO
      {
         var _loc3_:ItemInfoManager = ItemInfoManager.getInstance();
         var _loc4_:FilterManager = FilterManager.getInstance();
         var _loc5_:String = _loc4_.lootIDMap[param2[DataInterchange.ITEM_LOOT_ID]];
         var _loc6_:ItemInstanceVO = new ItemInstanceVO(_loc3_.getItemInfo(_loc5_));
         _loc6_.quantity = param2[DataInterchange.ITEM_QUANTITY];
         _loc6_.ID = param1;
         _loc6_.slot = param2[DataInterchange.ITEM_SLOT];
         if(param2[DataInterchange.PROPERTIES] != null)
         {
            _loc6_.attachedAmmo = param2[DataInterchange.PROPERTIES][DataInterchange.PROPERTY_ATTACHED_AMMO];
         }
         this.items[param1] = _loc6_;
         return _loc6_;
      }
      
      public function getItem(param1:String) : ItemInstanceVO
      {
         return this.items[param1];
      }
      
      public function getItemTextInfo(param1:String) : Dictionary
      {
         var _loc4_:ItemInfoVO = null;
         var _loc2_:Dictionary = new Dictionary();
         var _loc3_:ItemInstanceVO = this.getItem(param1);
         if(_loc3_)
         {
            _loc4_ = _loc3_.itemInfo;
            _loc2_ = _loc4_.loka;
         }
         return _loc2_;
      }
      
      public function swapItems(param1:int, param2:int) : int
      {
         var _loc5_:ItemInstanceVO = null;
         var _loc6_:ItemInstanceVO = null;
         var _loc3_:ItemInstanceVO = this.items[param1];
         var _loc4_:int = _loc3_.slot;
         for each(_loc6_ in this.items)
         {
            if(_loc6_.slot == param2)
            {
               _loc5_ = _loc6_;
            }
         }
         if(_loc5_ != null)
         {
            _loc5_.slot = _loc3_.slot;
         }
         if(_loc3_ != null)
         {
            _loc3_.slot = param2;
         }
         return _loc4_;
      }
      
      public function optionalItemUpdate(param1:String, param2:Object) : ItemInstanceVO
      {
         var _loc3_:ItemInstanceVO = this.items[param1];
         if(_loc3_ != null)
         {
            _loc3_.slot = param2[DataInterchange.ITEM_SLOT];
            _loc3_.quantity = param2[DataInterchange.ITEM_QUANTITY];
         }
         return _loc3_;
      }
      
      public function isSlotInUse(param1:int) : Boolean
      {
         return this.items[param1] != null;
      }
      
      public function deleteItem(param1:String) : void
      {
         this.items[param1] = null;
         delete this.items[param1];
      }
      
      public function getNumberOfInventoryItems() : int
      {
         var _loc2_:String = null;
         var _loc1_:int = 0;
         for(_loc2_ in this.items)
         {
            _loc1_++;
         }
         return _loc1_;
      }
      
      public function getItemInHighestSlot() : int
      {
         var _loc2_:String = null;
         var _loc3_:ItemInstanceVO = null;
         var _loc1_:int = 0;
         for(_loc2_ in this.items)
         {
            _loc3_ = this.items[_loc2_];
            if(_loc3_.slot > _loc1_)
            {
               _loc1_ = _loc3_.slot;
            }
         }
         return _loc1_;
      }
   }
}

