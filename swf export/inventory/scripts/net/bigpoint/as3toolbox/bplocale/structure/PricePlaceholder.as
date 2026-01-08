package net.bigpoint.as3toolbox.bplocale.structure
{
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class PricePlaceholder extends FormattedPlaceholder
   {
      
      public function PricePlaceholder()
      {
         super();
      }
      
      override public function getText(param1:Dictionary) : String
      {
         var _loc2_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(format == null)
         {
            throw new Error("PricePlaceholder " + name + " has no format defined.");
         }
         var _loc3_:* = param1[name];
         var _loc4_:Dictionary = new Dictionary();
         if(_loc3_ is int || _loc3_ is uint)
         {
            _loc2_ = _loc3_;
         }
         else if(_loc3_ is Number)
         {
            _loc2_ = Math.round(_loc3_ * BPLocale.CURRENCY_RATIO);
         }
         else
         {
            if(!(_loc3_ is String))
            {
               throw new Error(_loc3_ + " is no valid value. PricePlaceholder can not process this value.");
            }
            _loc2_ = Number(_loc3_);
         }
         _loc6_ = int(_loc2_ / BPLocale.CURRENCY_RATIO);
         _loc5_ = int(_loc2_ - _loc6_ * BPLocale.CURRENCY_RATIO);
         _loc4_[SystemPlaceholder.SYSTEM_CURRENCY_BIG] = _loc6_;
         _loc4_[SystemPlaceholder.SYSTEM_CURRENCY_SMALL] = _loc5_;
         _loc4_[SystemPlaceholder.SYSTEM_CURRENCY_TOTAL] = _loc2_;
         return format.getText(_loc4_);
      }
   }
}

