package net.bigpoint.darkorbit.equipment.model.VO
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.equipment.model.VO.slot.SlotSetVO;
   
   public class Equipment
   {
      
      public var name:String;
      
      public var slotSets:Dictionary = new Dictionary();
      
      public function Equipment()
      {
         super();
      }
      
      public function addSlotSet(param1:String, param2:Array = null, param3:int = 1) : SlotSetVO
      {
         var _loc4_:SlotSetVO = null;
         _loc4_ = new SlotSetVO();
         _loc4_.name = param1;
         _loc4_.acceptedItemGroups = param2;
         _loc4_.maxSlotCount = param3;
         this.slotSets[_loc4_.name] = _loc4_;
         return _loc4_;
      }
   }
}

