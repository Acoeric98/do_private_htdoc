package net.bigpoint.darkorbit.equipment.model.VO
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.equipment.events.ActionIdentifiers;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.model.VO.slot.SlotSetInfoVO;
   import net.bigpoint.darkorbit.equipment.model.managers.FilterManager;
   import net.bigpoint.dataInterchange.DataInterchange;
   
   public class EquippableObject
   {
      
      public var allGroupsAcceptedByThisObject:Array = [];
      
      public var slotSetInfos:Dictionary = new Dictionary();
      
      public var lootID:String = "";
      
      public var level:int;
      
      public function EquippableObject()
      {
         super();
      }
      
      public function addSlotSetInfo(param1:String, param2:Object, param3:int = -1) : SlotSetInfoVO
      {
         var _loc4_:FilterManager = FilterManager.getInstance();
         var _loc5_:SlotSetInfoVO = new SlotSetInfoVO();
         _loc5_.name = param1;
         _loc5_.quantity = param2[DataInterchange.ITEM_QUANTITY];
         if(param1 == ActionIdentifiers.EXTRAS)
         {
            Settings.defaultNumberOfExtrasSlots = _loc5_.quantity;
         }
         var _loc6_:Array = _loc4_.getGroupKeysFromArray(param2[DataInterchange.ITEM_GROUP]);
         _loc5_.acceptedItemGroups = _loc6_;
         if(param3 != -1)
         {
            _loc5_.unlockableSlots = param3;
         }
         this.slotSetInfos[_loc5_.name] = _loc5_;
         return _loc5_;
      }
      
      public function getSlotSetInfo(param1:String) : SlotSetInfoVO
      {
         return this.slotSetInfos[param1];
      }
      
      public function addAcceptedGroupsToTotal(param1:Array) : void
      {
         var _loc4_:String = null;
         var _loc2_:FilterManager = FilterManager.getInstance();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = _loc2_.typeMap[param1[_loc3_]];
            if(!this.arrayAlreadyContains(this.allGroupsAcceptedByThisObject,_loc4_))
            {
               this.allGroupsAcceptedByThisObject.push(_loc4_);
            }
            _loc3_++;
         }
      }
      
      private function arrayAlreadyContains(param1:Array, param2:String) : Boolean
      {
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] == param2)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
   }
}

