package net.bigpoint.darkorbit.equipment.model.VO.slot
{
   import net.bigpoint.darkorbit.equipment.model.ConnectionProxy;
   import net.bigpoint.darkorbit.equipment.model.VO.Ship;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInstanceVO;
   import net.bigpoint.darkorbit.equipment.model.managers.EquipmentManager;
   
   public class SlotSetVO
   {
      
      public var items:Array = [];
      
      public var acceptedItemGroups:Array = [];
      
      public var maxSlotCount:int = 1;
      
      public var name:String;
      
      public var hasSlotCPUEquipped:Boolean = false;
      
      public var partOfConfig:String;
      
      public function SlotSetVO()
      {
         super();
      }
      
      public function SlotSet() : void
      {
      }
      
      public function addItem(param1:ItemInstanceVO, param2:int = 0, param3:String = null) : SlotItemVO
      {
         this.partOfConfig = param3;
         var _loc4_:SlotItemVO = new SlotItemVO();
         _loc4_.itemInstance = param1;
         this.items.push(_loc4_);
         this.checkItemAgainstSlotCPUs(param1);
         return _loc4_;
      }
      
      private function checkItemAgainstSlotCPUs(param1:ItemInstanceVO) : void
      {
         var _loc4_:String = null;
         var _loc2_:EquipmentManager = EquipmentManager.getInstance();
         var _loc3_:Ship = _loc2_.ship;
         for(_loc4_ in ConnectionProxy.EXTENDER_CPUS)
         {
            if(param1.itemInfo.lootID == _loc4_)
            {
               _loc3_.actualSlotsWithSlotCPUForConfig[this.partOfConfig] = ConnectionProxy.EXTENDER_CPUS[_loc4_];
            }
         }
      }
      
      public function removeItem(param1:ItemInstanceVO) : void
      {
         var _loc3_:ItemInstanceVO = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.items.length)
         {
            _loc3_ = this.items[_loc2_].itemInstance;
            if(_loc3_ == param1)
            {
               this.items.splice(_loc2_,1);
               return;
            }
            _loc2_++;
         }
      }
      
      public function removeAll() : Object
      {
         var _loc4_:SlotItemVO = null;
         var _loc1_:Object = {};
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         for each(_loc4_ in this.items)
         {
            _loc2_.push(_loc4_.itemInstance.ID);
            _loc3_.push(_loc4_.itemInstance);
         }
         this.items = null;
         this.items = [];
         _loc1_.IDs = _loc2_;
         _loc1_.instances = _loc3_;
         return _loc1_;
      }
   }
}

