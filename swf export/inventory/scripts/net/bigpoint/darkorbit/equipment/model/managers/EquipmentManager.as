package net.bigpoint.darkorbit.equipment.model.managers
{
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.model.VO.Drone;
   import net.bigpoint.darkorbit.equipment.model.VO.Pet;
   import net.bigpoint.darkorbit.equipment.model.VO.Ship;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInfoVO;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemLocalisationKeys;
   import net.bigpoint.darkorbit.equipment.model.VO.slot.SlotSetInfoVO;
   import net.bigpoint.dataInterchange.DataInterchange;
   
   public class EquipmentManager
   {
      
      private static var _instance:EquipmentManager;
      
      public var ship:Ship = new Ship();
      
      public var generalDrone:Drone;
      
      public var pet:Pet;
      
      public var drones:Dictionary = new Dictionary();
      
      public function EquipmentManager(param1:Function)
      {
         super();
         if(param1 != hidden)
         {
            throw new Error("EquipmentManager is a Singleton and can only be accessed through EquipmentManager.getInstance()");
         }
      }
      
      public static function getInstance() : EquipmentManager
      {
         if(_instance == null)
         {
            _instance = new EquipmentManager(hidden);
         }
         return _instance;
      }
      
      private static function hidden() : void
      {
      }
      
      public function init(param1:Object) : void
      {
         var _loc6_:Object = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:ItemInfoVO = null;
         var _loc10_:Object = null;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         var _loc13_:Drone = null;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc16_:SlotSetInfoVO = null;
         var _loc17_:Object = null;
         var _loc18_:Array = null;
         var _loc19_:SlotSetInfoVO = null;
         var _loc20_:Object = null;
         var _loc21_:* = null;
         var _loc22_:String = null;
         var _loc23_:ItemInfoVO = null;
         var _loc24_:Object = null;
         var _loc25_:String = null;
         var _loc26_:int = 0;
         var _loc2_:ItemInfoManager = ItemInfoManager.getInstance();
         var _loc3_:FilterManager = FilterManager.getInstance();
         this.ship = new Ship();
         this.ship.level = 0;
         if(!(param1.ship is Array))
         {
            _loc6_ = param1.ship;
            if(_loc6_ != null)
            {
               _loc7_ = _loc6_[DataInterchange.ITEM_LOOT_ID];
               _loc8_ = _loc3_.lootIDMap[_loc7_];
               this.ship.lootID = _loc8_;
               this.ship.ID = _loc6_[DataInterchange.ITEM_ID];
               this.ship.hitPoints = _loc6_[DataInterchange.ITEM_HITPOINTS];
               this.ship.selectedDesign = _loc6_[DataInterchange.SELECTED_DESIGN];
               this.ship.setAvailableDesignsList(_loc6_[DataInterchange.AVAILABLE_DESIGNS]);
               this.ship.setAllAvailableDesignLokaInfo(_loc2_);
               _loc9_ = _loc2_.getItemInfo(this.ship.lootID);
               this.ship.saleValue = _loc9_.saleValuesByLevel[0];
               this.ship.sellable = _loc9_.sellable;
               _loc10_ = _loc9_.rawSlotSetInfoByLevel[this.ship.level];
               for(_loc11_ in _loc10_)
               {
                  this.ship.addSlotSetInfo(_loc11_,_loc10_[_loc11_]);
                  this.ship.addAcceptedGroupsToTotal(_loc10_[_loc11_][DataInterchange.ITEM_GROUP]);
               }
            }
         }
         this.generalDrone = new Drone();
         var _loc4_:Array = param1.drones;
         if(_loc4_ != null)
         {
            _loc12_ = 0;
            while(_loc12_ < _loc4_.length)
            {
               Settings.USER_HAS_DRONES = true;
               _loc13_ = new Drone();
               _loc14_ = _loc3_.lootIDMap[_loc4_[_loc12_][DataInterchange.ITEM_LOOT_ID]];
               _loc13_.ID = _loc4_[_loc12_][DataInterchange.ITEM_ID];
               _loc13_.level = _loc4_[_loc12_][DataInterchange.LEVEL];
               _loc13_.hitPoints = _loc4_[_loc12_][DataInterchange.ITEM_HITPOINTS];
               _loc13_.damage = int(_loc13_.hitPoints.substring(0,_loc13_.hitPoints.length - 1));
               _loc13_.effect = _loc4_[_loc12_][DataInterchange.DRONE_EFFECT];
               _loc13_.repairCurrency = _loc4_[_loc12_][DataInterchange.DRONE_CURRENCY];
               _loc13_.repairValue = _loc4_[_loc12_][DataInterchange.DRONE_REPAIR_VALUE];
               if(_loc4_[_loc12_][DataInterchange.DAMAGE_LEVEL] > 1)
               {
                  _loc13_.damageLevel = _loc4_[_loc12_][DataInterchange.DAMAGE_LEVEL];
               }
               if(_loc4_[_loc12_][DataInterchange.SHIELD_LEVEL] > 1)
               {
                  _loc13_.shieldLevel = _loc4_[_loc12_][DataInterchange.SHIELD_LEVEL];
               }
               if(_loc4_[_loc12_][DataInterchange.DRONE_DESIGN] != "")
               {
                  _loc15_ = _loc21_ = ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS + ItemLocalisationKeys.SEPARATOR + _loc4_[_loc12_][DataInterchange.DRONE_DESIGN] + "_fullname";
                  _loc13_.design = BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,_loc15_);
               }
               else
               {
                  _loc13_.design = "";
               }
               _loc13_.itemInfo = _loc2_.getItemInfo(_loc14_);
               _loc13_.lootID = _loc14_;
               _loc16_ = new SlotSetInfoVO();
               _loc16_.name = _loc13_.ID;
               _loc17_ = _loc13_.itemInfo.rawSlotSetInfoByLevel[_loc13_.level][DataInterchange.DEFAULT];
               _loc16_.quantity = _loc13_.itemInfo.rawSlotSetInfoByLevel[_loc13_.level][DataInterchange.DEFAULT][DataInterchange.ITEM_QUANTITY];
               _loc18_ = _loc3_.getGroupKeysFromArray(_loc17_[DataInterchange.ITEM_GROUP]);
               _loc16_.acceptedItemGroups = _loc18_;
               _loc19_ = new SlotSetInfoVO();
               _loc19_.name = _loc13_.ID;
               _loc19_.quantity = _loc13_.itemInfo.rawSlotSetInfoByLevel[_loc13_.level][DataInterchange.DESIGN][DataInterchange.ITEM_QUANTITY];
               _loc20_ = _loc13_.itemInfo.rawSlotSetInfoByLevel[_loc13_.level][DataInterchange.DESIGN];
               _loc18_ = _loc3_.getGroupKeysFromArray(_loc20_[DataInterchange.ITEM_GROUP]);
               _loc19_.acceptedItemGroups = _loc18_;
               _loc13_.slotSetInfos[DataInterchange.DEFAULT] = _loc16_;
               _loc13_.slotSetInfos[DataInterchange.DESIGN] = _loc19_;
               this.drones[_loc13_.ID] = _loc13_;
               if(_loc12_ == _loc4_.length - 1)
               {
                  this.generalDrone.ID = _loc13_.ID;
                  this.generalDrone.addAcceptedGroupsToTotal(_loc17_[DataInterchange.ITEM_GROUP]);
                  this.generalDrone.addAcceptedGroupsToTotal(_loc20_[DataInterchange.ITEM_GROUP]);
               }
               _loc12_++;
            }
         }
         var _loc5_:Object = param1.pet;
         if(_loc5_ != null)
         {
            this.pet = new Pet();
            _loc22_ = _loc3_.lootIDMap[_loc5_[DataInterchange.ITEM_LOOT_ID]];
            this.pet.ID = _loc5_[DataInterchange.ITEM_ID];
            this.pet.lootID = _loc22_;
            this.pet.hitPoints = _loc5_[DataInterchange.ITEM_HITPOINTS];
            this.pet.level = _loc5_[DataInterchange.LEVEL];
            this.pet.petName = _loc5_[DataInterchange.PET_NAME];
            _loc23_ = _loc2_.getItemInfo(this.pet.lootID);
            _loc24_ = _loc23_.rawSlotSetInfoByLevel[this.pet.level];
            for(_loc25_ in _loc24_)
            {
               _loc26_ = int(_loc5_[DataInterchange.UNLOCKABLE_SLOTS][_loc25_]);
               this.pet.addSlotSetInfo(_loc25_,_loc24_[_loc25_],_loc26_);
               this.pet.addAcceptedGroupsToTotal(_loc24_[_loc25_][DataInterchange.ITEM_GROUP]);
            }
            Settings.USER_HAS_PET = true;
         }
         else
         {
            Settings.USER_HAS_PET = false;
         }
      }
      
      public function getItemValueForDroneID(param1:String) : Number
      {
         var _loc2_:Drone = this.drones[param1];
         return _loc2_.itemInfo.saleValuesByLevel[_loc2_.level];
      }
      
      public function getDroneAtIndex(param1:int) : Drone
      {
         return this.drones[param1];
      }
      
      public function addDrone(param1:int) : Drone
      {
         var _loc2_:Drone = new Drone();
         _loc2_.index = param1;
         this.drones[_loc2_.index] = _loc2_;
         return _loc2_;
      }
      
      public function deleteDrone(param1:String) : void
      {
         delete this.drones[param1];
      }
      
      public function checkIfDronesRemain() : Boolean
      {
         var _loc2_:String = null;
         var _loc1_:int = 0;
         for(_loc2_ in this.drones)
         {
            _loc1_++;
         }
         if(_loc1_ == 0)
         {
            return false;
         }
         return true;
      }
   }
}

