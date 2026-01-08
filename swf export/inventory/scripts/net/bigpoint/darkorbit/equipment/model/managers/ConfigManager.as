package net.bigpoint.darkorbit.equipment.model.managers
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.equipment.events.ActionIdentifiers;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.model.VO.Config;
   import net.bigpoint.darkorbit.equipment.model.VO.Equipment;
   import net.bigpoint.darkorbit.equipment.model.VO.Inventory;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInstanceVO;
   import net.bigpoint.darkorbit.equipment.model.VO.slot.SlotItemVO;
   import net.bigpoint.darkorbit.equipment.model.VO.slot.SlotSetInfoVO;
   import net.bigpoint.darkorbit.equipment.model.VO.slot.SlotSetVO;
   import net.bigpoint.dataInterchange.DataInterchange;
   
   public class ConfigManager
   {
      
      private static var _instance:ConfigManager;
      
      public static var ADD:String = "ADD";
      
      public static var REMOVE:String = "REMOVE";
      
      public var configs:Dictionary = new Dictionary();
      
      public function ConfigManager(param1:Function)
      {
         super();
         if(param1 != hidden)
         {
            throw new Error("ConfigManager is a Singleton and can only be accessed through ConfigManager.getInstance()");
         }
      }
      
      public static function getInstance() : ConfigManager
      {
         if(_instance == null)
         {
            _instance = new ConfigManager(hidden);
         }
         return _instance;
      }
      
      private static function hidden() : void
      {
      }
      
      private function buildBasicConfigStructure(param1:Object) : void
      {
         var _loc3_:SlotSetVO = null;
         var _loc4_:String = null;
         var _loc5_:Config = null;
         var _loc6_:Equipment = null;
         var _loc7_:Equipment = null;
         var _loc8_:Dictionary = null;
         var _loc9_:String = null;
         var _loc10_:SlotSetInfoVO = null;
         var _loc11_:Dictionary = null;
         var _loc12_:String = null;
         var _loc13_:SlotSetInfoVO = null;
         var _loc14_:Dictionary = null;
         var _loc15_:String = null;
         var _loc16_:int = 0;
         var _loc17_:Dictionary = null;
         var _loc18_:Equipment = null;
         var _loc19_:String = null;
         var _loc20_:SlotSetInfoVO = null;
         var _loc21_:Array = null;
         var _loc22_:int = 0;
         var _loc2_:EquipmentManager = EquipmentManager.getInstance();
         for(_loc4_ in param1)
         {
            _loc5_ = this.addConfig(_loc4_);
            _loc6_ = _loc5_.addEquipment(ActionIdentifiers.SHIP);
            _loc7_ = _loc5_.addEquipment(ActionIdentifiers.PET);
            _loc8_ = _loc2_.ship.slotSetInfos;
            for(_loc9_ in _loc8_)
            {
               _loc10_ = _loc8_[_loc9_];
               _loc3_ = _loc6_.addSlotSet(_loc9_,_loc10_.acceptedItemGroups);
            }
            if(_loc2_.pet != null)
            {
               _loc11_ = _loc2_.pet.slotSetInfos;
               for(_loc12_ in _loc11_)
               {
                  _loc13_ = _loc11_[_loc12_];
                  _loc3_ = _loc7_.addSlotSet(_loc12_,_loc13_.acceptedItemGroups);
               }
            }
            if(_loc2_.drones != null)
            {
               _loc14_ = _loc2_.drones;
               for(_loc15_ in _loc14_)
               {
                  _loc16_ = int(_loc15_);
                  _loc17_ = _loc14_[_loc15_]["slotSetInfos"];
                  _loc18_ = _loc5_.addEquipment("drone_" + _loc15_);
                  for(_loc19_ in _loc17_)
                  {
                     _loc20_ = _loc2_.drones[_loc16_]["slotSetInfos"][_loc19_];
                     _loc21_ = _loc20_.acceptedItemGroups;
                     _loc22_ = _loc20_.quantity;
                     _loc3_ = _loc18_.addSlotSet(_loc19_,_loc21_,_loc22_);
                  }
               }
            }
         }
      }
      
      public function init(param1:Object) : void
      {
         var _loc4_:String = null;
         var _loc5_:SlotSetVO = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:ItemInstanceVO = null;
         var _loc10_:String = null;
         var _loc11_:Object = null;
         var _loc12_:Config = null;
         var _loc13_:Equipment = null;
         var _loc14_:Object = null;
         var _loc15_:Equipment = null;
         var _loc16_:String = null;
         var _loc17_:Object = null;
         var _loc18_:Equipment = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc9_:Inventory = Inventory.getInstance();
         this.buildBasicConfigStructure(param1);
         for(_loc10_ in param1)
         {
            _loc11_ = param1[_loc10_];
            _loc12_ = this.configs[_loc10_];
            _loc13_ = _loc12_.getEquipment(ActionIdentifiers.SHIP);
            _loc14_ = _loc11_.ship;
            if(_loc14_ != null)
            {
               for(_loc4_ in _loc14_.EQ)
               {
                  _loc5_ = _loc13_.slotSets[_loc4_];
                  _loc6_ = _loc11_.ship.EQ[_loc4_];
                  _loc2_ = 0;
                  while(_loc2_ < _loc6_.length)
                  {
                     _loc7_ = int(_loc6_[_loc2_]);
                     _loc8_ = _loc9_.getItem(String(_loc7_));
                     _loc5_.addItem(_loc8_,_loc2_,_loc10_);
                     _loc8_.equipToConfig(_loc12_);
                     _loc2_++;
                  }
               }
            }
            if(_loc11_.drones != null)
            {
               for(_loc16_ in _loc11_.drones)
               {
                  _loc17_ = _loc11_.drones[_loc16_];
                  _loc18_ = _loc12_.getEquipment("drone_" + _loc16_);
                  for(_loc4_ in _loc17_.EQ)
                  {
                     _loc5_ = _loc18_.slotSets[_loc4_];
                     _loc6_ = _loc17_.EQ[_loc4_];
                     _loc3_ = 0;
                     while(_loc3_ < _loc6_.length)
                     {
                        _loc7_ = int(_loc6_[_loc3_]);
                        _loc5_.addItem(_loc9_.getItem(String(_loc7_)),_loc3_,_loc10_);
                        _loc8_ = _loc9_.getItem(String(_loc7_));
                        _loc8_.equipToConfig(_loc12_);
                        _loc3_++;
                     }
                  }
               }
            }
            _loc15_ = _loc12_.getEquipment(ActionIdentifiers.PET);
            if(_loc11_.pet != null)
            {
               for(_loc4_ in _loc11_.pet.EQ)
               {
                  _loc5_ = _loc15_.slotSets[_loc4_];
                  _loc6_ = _loc11_.pet.EQ[_loc4_];
                  _loc2_ = 0;
                  while(_loc2_ < _loc6_.length)
                  {
                     _loc7_ = int(_loc6_[_loc2_]);
                     _loc5_.addItem(_loc9_.getItem(String(_loc7_)),_loc2_);
                     _loc8_ = _loc9_.getItem(String(_loc7_));
                     _loc8_.equipToConfig(_loc12_);
                     _loc2_++;
                  }
               }
            }
         }
      }
      
      public function clearConfig(param1:int) : Object
      {
         var _loc5_:SlotSetVO = null;
         var _loc8_:Equipment = null;
         var _loc9_:Dictionary = null;
         var _loc10_:String = null;
         var _loc11_:Object = null;
         var _loc12_:Object = null;
         var _loc13_:Object = null;
         var _loc14_:int = 0;
         var _loc15_:Equipment = null;
         var _loc16_:Dictionary = null;
         var _loc17_:Object = null;
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:Config = this.configs[param1];
         var _loc6_:Equipment = _loc4_.equipments[ActionIdentifiers.SHIP];
         var _loc7_:Dictionary = _loc6_.slotSets;
         for each(_loc5_ in _loc7_)
         {
            _loc12_ = _loc5_.removeAll();
            _loc2_ = _loc2_.concat(_loc12_.IDs);
            _loc3_ = _loc3_.concat(_loc12_.instances);
         }
         _loc8_ = _loc4_.equipments[ActionIdentifiers.PET];
         _loc9_ = _loc8_.slotSets;
         for each(_loc5_ in _loc9_)
         {
            _loc13_ = _loc5_.removeAll();
            _loc2_ = _loc2_.concat(_loc13_.IDs);
            _loc3_ = _loc3_.concat(_loc13_.instances);
         }
         for(_loc10_ in _loc4_.equipments)
         {
            _loc14_ = int(_loc10_.indexOf("drone"));
            if(_loc14_ >= 0)
            {
               _loc15_ = _loc4_.equipments[_loc10_];
               _loc16_ = _loc15_.slotSets;
               for each(_loc5_ in _loc16_)
               {
                  _loc17_ = _loc5_.removeAll();
                  _loc2_ = _loc2_.concat(_loc17_.IDs);
                  _loc3_ = _loc3_.concat(_loc17_.instances);
               }
            }
         }
         return {
            "IDs":_loc2_,
            "instances":_loc3_
         };
      }
      
      public function addConfig(param1:String) : Config
      {
         var _loc2_:Config = new Config(param1);
         this.configs[_loc2_.name] = _loc2_;
         return _loc2_;
      }
      
      public function updateEquipment(param1:Array, param2:String, param3:String, param4:String, param5:int = -1) : Array
      {
         var _loc11_:ItemInstanceVO = null;
         var _loc12_:SlotSetVO = null;
         if(param5 == -1)
         {
            param5 = Settings.activeConfig;
         }
         var _loc6_:Array = [];
         var _loc7_:Inventory = Inventory.getInstance();
         var _loc8_:Config = this.configs[param5];
         var _loc9_:Equipment = _loc8_.equipments[param3];
         var _loc10_:int = 0;
         while(_loc10_ < param1.length)
         {
            _loc11_ = _loc7_.getItem(param1[_loc10_]);
            for each(_loc12_ in _loc9_.slotSets)
            {
               if(_loc12_.name == param4)
               {
                  _loc6_ = this.updateSlotSet(_loc12_,param2,_loc11_,_loc6_,_loc8_);
               }
            }
            _loc10_++;
         }
         return _loc6_;
      }
      
      public function updateAllDronesEquipment(param1:Array, param2:String, param3:String, param4:String, param5:int = -1) : Array
      {
         var _loc9_:String = null;
         var _loc10_:Array = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:ItemInstanceVO = null;
         var _loc14_:int = 0;
         var _loc15_:Equipment = null;
         var _loc16_:SlotSetVO = null;
         var _loc17_:int = 0;
         var _loc18_:SlotItemVO = null;
         if(param5 == -1)
         {
            param5 = Settings.activeConfig;
         }
         var _loc6_:Inventory = Inventory.getInstance();
         var _loc7_:Config = this.configs[param5];
         var _loc8_:Array = [];
         for(_loc9_ in _loc7_.equipments)
         {
            _loc12_ = int(_loc9_.indexOf("drone"));
            if(_loc12_ >= 0)
            {
               _loc8_.push(_loc9_);
            }
         }
         _loc10_ = [];
         _loc11_ = 0;
         while(_loc11_ < param1.length)
         {
            _loc13_ = _loc6_.getItem(param1[_loc11_]);
            _loc14_ = 0;
            while(_loc14_ < _loc8_.length)
            {
               _loc15_ = _loc7_.equipments[_loc8_[_loc14_]];
               for each(_loc16_ in _loc15_.slotSets)
               {
                  if(_loc16_.name == param4)
                  {
                     _loc17_ = 0;
                     while(_loc17_ < _loc16_.items.length)
                     {
                        _loc18_ = _loc16_.items[_loc17_];
                        if(_loc18_.itemInstance.ID == _loc13_.ID)
                        {
                           _loc10_ = this.updateSlotSet(_loc16_,param2,_loc13_,_loc10_,_loc7_);
                        }
                        _loc17_++;
                     }
                  }
               }
               _loc14_++;
            }
            _loc11_++;
         }
         return _loc10_;
      }
      
      public function updateDroneEquipment(param1:Array, param2:String, param3:String, param4:int = -1) : Array
      {
         var _loc11_:ItemInstanceVO = null;
         var _loc12_:SlotSetVO = null;
         if(param4 == -1)
         {
            param4 = Settings.activeConfig;
         }
         var _loc5_:Array = [];
         var _loc6_:Inventory = Inventory.getInstance();
         var _loc7_:Config = this.configs[param4];
         var _loc8_:String = "drone_" + String(param3);
         var _loc9_:Equipment = _loc7_.equipments[_loc8_];
         var _loc10_:int = 0;
         while(_loc10_ < param1.length)
         {
            _loc11_ = _loc6_.getItem(param1[_loc10_]);
            for each(_loc12_ in _loc9_.slotSets)
            {
               _loc5_ = this.updateSlotSet(_loc12_,param2,_loc11_,_loc5_,_loc7_);
            }
            _loc10_++;
         }
         return _loc5_;
      }
      
      public function deleteItem(param1:String) : void
      {
         var _loc3_:String = null;
         var _loc2_:Array = [param1];
         for(_loc3_ in this.configs)
         {
            this.cycleAllEquipment(this.configs[_loc3_],_loc2_,REMOVE);
         }
      }
      
      private function cycleAllEquipment(param1:Config, param2:Array, param3:String) : void
      {
         var _loc4_:String = null;
         var _loc5_:Equipment = null;
         for(_loc4_ in param1.equipments)
         {
            _loc5_ = param1.equipments[_loc4_];
            this.updateAllOccurancesInAllEquipments(param2,_loc5_,param1,param3);
         }
      }
      
      private function updateAllOccurancesInAllEquipments(param1:Array, param2:Equipment, param3:Config, param4:String) : void
      {
         var _loc7_:ItemInstanceVO = null;
         var _loc8_:SlotSetVO = null;
         var _loc5_:Inventory = Inventory.getInstance();
         var _loc6_:int = 0;
         while(_loc6_ < param1.length)
         {
            _loc7_ = _loc5_.getItem(param1[_loc6_]);
            for each(_loc8_ in param2.slotSets)
            {
               this.updateSlotSet(_loc8_,param4,_loc7_,new Array(),param3);
            }
            _loc6_++;
         }
      }
      
      private function updateSlotSet(param1:SlotSetVO, param2:String, param3:ItemInstanceVO, param4:Array, param5:Config) : Array
      {
         var _loc6_:int = 0;
         while(_loc6_ < param1.acceptedItemGroups.length)
         {
            if(param3.itemInfo.group.name == param1.acceptedItemGroups[_loc6_])
            {
               if(param2 == ADD)
               {
                  param1.addItem(param3);
                  param3.equipToConfig(param5);
                  param4.push(param3);
                  break;
               }
               if(param2 == REMOVE)
               {
                  param1.removeItem(param3);
                  param3.unequipFromConfig(param5);
                  param4.push(param3);
               }
               break;
            }
            _loc6_++;
         }
         return param4;
      }
      
      public function printAllConfigInformation() : void
      {
         var _loc2_:Config = null;
         var _loc3_:String = null;
         var _loc4_:Equipment = null;
         var _loc5_:SlotSetVO = null;
         var _loc6_:int = 0;
         var _loc7_:SlotItemVO = null;
         var _loc1_:int = 1;
         for each(_loc2_ in this.configs)
         {
            for(_loc3_ in _loc2_.equipments)
            {
               _loc4_ = _loc2_.equipments[_loc3_];
               for each(_loc5_ in _loc4_.slotSets)
               {
                  _loc6_ = 0;
                  while(_loc6_ < _loc5_.items.length)
                  {
                     _loc7_ = _loc5_.items[_loc6_];
                     _loc6_++;
                  }
               }
            }
            _loc1_++;
         }
      }
      
      public function getAllItemsEquippedToThisDrone(param1:String) : Array
      {
         var _loc3_:Config = null;
         var _loc4_:Equipment = null;
         var _loc5_:SlotSetVO = null;
         var _loc2_:Array = [];
         for each(_loc3_ in this.configs)
         {
            _loc4_ = _loc3_.equipments["drone_" + param1];
            _loc5_ = _loc4_.slotSets[DataInterchange.DEFAULT];
            _loc2_.push(this.getItemIDsFromSlotItems(_loc5_.items));
            _loc5_ = _loc4_.slotSets[DataInterchange.DESIGN];
            _loc2_.push(this.getItemIDsFromSlotItems(_loc5_.items));
         }
         return _loc2_;
      }
      
      private function getItemIDsFromSlotItems(param1:Array) : Array
      {
         var _loc4_:SlotItemVO = null;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_];
            _loc2_.push(_loc4_.itemInstance.ID);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function deleteDrone(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc3_:Config = null;
         for(_loc2_ in this.configs)
         {
            _loc3_ = this.configs[_loc2_];
            delete _loc3_.equipments[param1];
         }
      }
   }
}

