package net.bigpoint.darkorbit.equipment.view.components.tooltip.preparation
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemLocalisationKeys;
   import net.bigpoint.darkorbit.equipment.view.components.items.DragComponent;
   import net.bigpoint.darkorbit.equipment.view.components.items.InventoryItemComponent;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.TooltipControl;
   
   public class DefaultTooltipPreparer extends AbstractTooltipPreparer implements ITooltipPreparer
   {
      
      private var valuesOnly:Array;
      
      private var linesOfText:Array;
      
      public var actualLinesOfText:Array;
      
      private var nameField:String;
      
      private var typeField:String;
      
      private var chargeField:String;
      
      private var damageLevelField:String;
      
      private var shieldLevelField:String;
      
      public var detailsCutOff:int = 21;
      
      public var descCutOff:int = 150;
      
      public function DefaultTooltipPreparer(param1:String, param2:String, param3:int, param4:String, param5:String, param6:String, param7:int, param8:int, param9:Boolean = true)
      {
         var _loc12_:String = null;
         var _loc13_:int = 0;
         this.valuesOnly = [];
         this.linesOfText = [];
         this.actualLinesOfText = [];
         super();
         if(param1 == null || param2 == null)
         {
            return;
         }
         this.valuesOnly[0] = BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,param1);
         this.valuesOnly[1] = BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,param2);
         if(param5 != null)
         {
            if(param5.length > 1)
            {
               this.valuesOnly[2] = param5;
            }
         }
         if(param7 > 1)
         {
            this.valuesOnly[2] = param7;
         }
         else if(param8 > 1)
         {
            this.valuesOnly[2] = param8;
         }
         if(param3 > 1)
         {
            this.valuesOnly[3] = TooltipControl.WILDCARD;
         }
         else
         {
            this.valuesOnly[3] = param3;
         }
         this.valuesOnly[4] = param4;
         this.valuesOnly[5] = param6;
         this.linesOfText[0] = BPLocale.getItem("inventory_item_details_field_name").replace(/%VALUE%/,BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,param1));
         this.linesOfText[1] = BPLocale.getItem("inventory_item_details_field_type").replace(/%VALUE%/,BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,param2));
         if(param5 != null)
         {
            if(param5.length > 1)
            {
               this.linesOfText[2] = param5;
            }
         }
         if(param7 > 1)
         {
            this.linesOfText[2] = BPLocale.getItem("inventory_item_details_field_damage").replace(/%VALUE%/,param7);
         }
         else if(param8 > 1)
         {
            this.linesOfText[2] = BPLocale.getItem("inventory_item_details_field_shield").replace(/%VALUE%/,param8);
         }
         if(param3 > 1)
         {
            this.linesOfText[3] = BPLocale.getItem("inventory_item_details_field_charge").replace(/%VALUE%/,TooltipControl.WILDCARD);
         }
         else
         {
            this.linesOfText[3] = BPLocale.getItem("inventory_item_details_field_charge").replace(/%VALUE%/,String(param3));
         }
         this.linesOfText[4] = param4;
         this.linesOfText[5] = param6;
         tooltipText = "";
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         while(_loc11_ < this.valuesOnly.length)
         {
            if(this.valuesOnly[_loc11_] is String)
            {
               _loc12_ = this.valuesOnly[_loc11_];
               if(_loc12_ != null)
               {
                  tooltipText += this.linesOfText[_loc11_] + "\n";
                  this.actualLinesOfText[_loc10_] = this.linesOfText[_loc11_];
                  _loc10_++;
               }
            }
            if(this.valuesOnly[_loc11_] is int)
            {
               _loc13_ = int(this.valuesOnly[_loc11_]);
               if(_loc13_ > 1)
               {
                  tooltipText += this.linesOfText[_loc11_] + "\n";
                  this.actualLinesOfText[_loc10_] = this.linesOfText[_loc11_];
                  _loc10_++;
               }
            }
            _loc11_++;
         }
      }
      
      public function callDirtyRelict() : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc1_:InventoryItemComponent = DragComponent.getInstance().selectedItem;
         var _loc2_:Array = tooltipText.split(TooltipControl.WILDCARD);
         tooltipText = "";
         if(_loc2_[0])
         {
            tooltipText += _loc2_[0];
         }
         if(_loc1_.quantity > 1)
         {
            tooltipText += _loc1_.quantity;
         }
         if(_loc2_[1])
         {
            tooltipText += _loc2_[1];
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.actualLinesOfText.length)
         {
            _loc4_ = this.actualLinesOfText[_loc3_];
            if((Boolean(_loc4_)) && _loc4_.indexOf(TooltipControl.WILDCARD) != -1)
            {
               _loc5_ = this.actualLinesOfText[_loc3_];
               _loc6_ = _loc5_.split(TooltipControl.WILDCARD);
               this.actualLinesOfText[_loc3_] = _loc6_[0] + _loc1_.quantity;
            }
            _loc3_++;
         }
      }
      
      public function getShortenedText(param1:Boolean) : String
      {
         return this.cutLinesThatAreTooLong(param1);
      }
      
      protected function cutLinesThatAreTooLong(param1:Boolean = false) : String
      {
         var _loc2_:String = param1 ? "<br/>" : "\n";
         var _loc3_:String = "";
         var _loc4_:int = 0;
         while(_loc4_ < this.actualLinesOfText.length)
         {
            this.actualLinesOfText[_loc4_] = AbstractTooltipPreparer.cutSingleLine(this.actualLinesOfText[_loc4_],this.detailsCutOff);
            _loc3_ += this.actualLinesOfText[_loc4_] + _loc2_;
            _loc4_++;
         }
         return _loc3_;
      }
   }
}

