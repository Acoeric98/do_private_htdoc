package net.bigpoint.darkorbit.equipment.model.VO
{
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInfoVO;
   import net.bigpoint.darkorbit.equipment.model.managers.FilterManager;
   import net.bigpoint.darkorbit.equipment.model.managers.ItemInfoManager;
   import net.bigpoint.dataInterchange.DataInterchange;
   
   public class HangarSlotEntity
   {
      
      public var slotID:int = 0;
      
      public var hangarID:int;
      
      public var name:String;
      
      public var isSelected:Boolean = false;
      
      public var configs:Object;
      
      public var general:Object;
      
      private var ship:Ship;
      
      private var filterManager:FilterManager;
      
      private var itemInfoManager:ItemInfoManager;
      
      public function HangarSlotEntity(param1:Object = null)
      {
         super();
         if(param1)
         {
            this.hangarID = param1.hangarID;
            this.name = param1.name;
            this.configs = param1.config;
            this.general = param1.general;
            this.isSelected = param1.hangar_is_selected;
            this.filterManager = FilterManager.getInstance();
            this.itemInfoManager = ItemInfoManager.getInstance();
            this.createShipEntity();
            this.createPetEntity();
            this.createDroneEntities();
         }
      }
      
      private function createShipEntity() : void
      {
         var _loc1_:Object = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:ItemInfoVO = null;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         if(!this.isHangarEmpty())
         {
            this.ship = new Ship();
            this.ship.level = 0;
            _loc1_ = this.general.ship;
            if(_loc1_ != null)
            {
               _loc2_ = _loc1_[DataInterchange.ITEM_LOOT_ID];
               _loc3_ = this.filterManager.lootIDMap[_loc2_];
               this.ship.lootID = _loc3_;
               this.ship.ID = _loc1_[DataInterchange.ITEM_ID];
               this.ship.hitPoints = _loc1_[DataInterchange.ITEM_HITPOINTS];
               this.ship.selectedDesign = _loc1_[DataInterchange.SELECTED_DESIGN];
               _loc4_ = this.itemInfoManager.getItemInfo(this.ship.lootID);
               this.ship.saleValue = _loc4_.saleValuesByLevel[0];
               this.ship.setAvailableDesignsList(_loc1_[DataInterchange.AVAILABLE_DESIGNS]);
               this.ship.setAllAvailableDesignLokaInfo(this.itemInfoManager);
               _loc5_ = _loc4_.rawSlotSetInfoByLevel[this.ship.level];
               for(_loc6_ in _loc5_)
               {
                  this.ship.addSlotSetInfo(_loc6_,_loc5_[_loc6_]);
                  this.ship.addAcceptedGroupsToTotal(_loc5_[_loc6_][DataInterchange.ITEM_GROUP]);
               }
            }
         }
      }
      
      private function createPetEntity() : void
      {
      }
      
      private function createDroneEntities() : void
      {
      }
      
      public function isHangarEmpty() : Boolean
      {
         var _loc1_:Array = this.general.ship as Array;
         if(_loc1_ != null)
         {
            return true;
         }
         return false;
      }
      
      public function getShip() : Ship
      {
         return this.ship;
      }
      
      public function getDrones() : void
      {
      }
      
      public function getPet() : void
      {
      }
      
      public function getItemInfoManager() : ItemInfoManager
      {
         return this.itemInfoManager;
      }
   }
}

