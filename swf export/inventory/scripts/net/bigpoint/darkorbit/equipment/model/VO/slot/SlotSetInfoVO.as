package net.bigpoint.darkorbit.equipment.model.VO.slot
{
   public class SlotSetInfoVO
   {
      
      public var name:String;
      
      public var quantity:int;
      
      public var acceptedItemGroups:Array = [];
      
      public var unlockableSlots:int;
      
      public function SlotSetInfoVO()
      {
         super();
      }
   }
}

