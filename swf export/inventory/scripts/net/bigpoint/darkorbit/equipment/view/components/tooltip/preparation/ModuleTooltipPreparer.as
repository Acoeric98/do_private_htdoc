package net.bigpoint.darkorbit.equipment.view.components.tooltip.preparation
{
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInfoVO;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInstanceVO;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemLocalisationKeys;
   import net.bigpoint.darkorbit.equipment.view.components.items.InventoryItemComponent;
   import net.bigpoint.dataInterchange.DataInterchange;
   
   public class ModuleTooltipPreparer extends AbstractTooltipPreparer implements ITooltipPreparer
   {
      
      protected var lines:Dictionary;
      
      public function ModuleTooltipPreparer(param1:InventoryItemComponent)
      {
         super();
         this.lines = new Dictionary();
         this.createText(param1);
      }
      
      protected function createText(param1:InventoryItemComponent) : void
      {
         var _loc5_:String = null;
         var _loc9_:String = null;
         var _loc2_:ItemInstanceVO = param1.getItemInstanceData();
         var _loc3_:ItemInfoVO = _loc2_.itemInfo;
         var _loc4_:Dictionary = _loc3_.loka;
         tooltipText = "";
         var _loc6_:String = BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,_loc4_[ItemLocalisationKeys.LOCA_CODE]);
         _loc5_ = BPLocale.getItem("inventory_item_details_field_name").replace(/%VALUE%/,_loc6_);
         this.addLine(ItemLocalisationKeys.LOCA_CODE,_loc5_);
         this.newline();
         var _loc7_:String = BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,_loc4_[ItemLocalisationKeys.LOCA_SHORT_NAME]);
         _loc5_ = BPLocale.getItem("inventory_item_details_field_type").replace(/%VALUE%/,_loc7_);
         this.addLine(ItemLocalisationKeys.LOCA_SHORT_NAME,_loc5_);
         var _loc8_:int = _loc2_.getLevelValue();
         if(_loc8_ > 0)
         {
            this.newline();
            _loc5_ = BPLocale.getItem("inventory_item_details_field_upgrade").replace(/%VALUE%/,_loc8_);
            this.addLine(DataInterchange.DURABILITY_LEVEL,_loc5_);
         }
         if(_loc2_.hitPoints >= 0)
         {
            this.newline();
            _loc5_ = BPLocale.getItem("inventory_item_details_field_current_hitpoints").replace(/%VALUE%/,_loc2_.hitPoints);
            this.addLine(DataInterchange.ITEM_HITPOINTS,_loc5_);
         }
         if(_loc2_.maxHitPoints >= 0)
         {
            this.newline();
            _loc5_ = BPLocale.getItem("inventory_item_details_field_max_hitpoints").replace(/%VALUE%/,_loc2_.maxHitPoints);
            this.addLine(DataInterchange.MAXIMAL_HIT_POINTS,_loc5_);
         }
         if(_loc2_.moduleInstalled)
         {
            this.newline();
            _loc9_ = _loc2_.battleStationName;
            _loc5_ = BPLocale.getItem("inventory_item_details_field_installed").replace(/%VALUE%/,_loc9_);
            this.addLine(DataInterchange.MODULE_INSTALLED,_loc5_);
         }
      }
      
      protected function addLine(param1:String, param2:String) : void
      {
         this.lines[param1] = param2;
         tooltipText += param2;
      }
      
      protected function getShortenedLine(param1:String) : String
      {
         var _loc2_:* = "";
         if(this.lines[param1])
         {
            _loc2_ = cutSingleLine(this.lines[param1],18);
            _loc2_ += "\n";
         }
         return _loc2_;
      }
      
      protected function newline() : void
      {
         tooltipText += "\n";
      }
      
      public function getShortenedText(param1:Boolean) : String
      {
         var _loc2_:String = "";
         _loc2_ += this.getShortenedLine(ItemLocalisationKeys.LOCA_CODE);
         _loc2_ += this.getShortenedLine(ItemLocalisationKeys.LOCA_SHORT_NAME);
         return _loc2_ + this.getShortenedLine(DataInterchange.DURABILITY_LEVEL);
      }
      
      public function callDirtyRelict() : void
      {
      }
   }
}

