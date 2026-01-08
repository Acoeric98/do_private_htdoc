package net.bigpoint.utils
{
   import flash.text.TextField;
   import flash.text.TextFormat;
   import mx.formatters.NumberBaseRoundType;
   import mx.formatters.NumberFormatter;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class TextFormatter
   {
      
      public static var THOUSANDS_SEPARATOR:String;
      
      public static var DECIMALS_SEPARATOR:String;
      
      private static var intFormatter:NumberFormatter;
      
      private static var floatFormatter:NumberFormatter;
      
      public function TextFormatter()
      {
         super();
      }
      
      public static function setNumberSeparators() : void
      {
         BPLocale.setItem("thousands_separator",",");
         BPLocale.setItem("decimal_separator",".");
         updateNumberSeparators();
      }
      
      public static function updateNumberSeparators() : void
      {
         if(BPLocale.getItem("decimal_separator") != " " && BPLocale.getItem("thousands_separator") != " " && BPLocale.getItem("thousands_separator") != BPLocale.getItem("decimal_separator"))
         {
            THOUSANDS_SEPARATOR = BPLocale.getItem("thousands_separator");
            DECIMALS_SEPARATOR = BPLocale.getItem("decimal_separator");
            intFormatter = new NumberFormatter();
            intFormatter.thousandsSeparatorTo = THOUSANDS_SEPARATOR;
            intFormatter.decimalSeparatorTo = DECIMALS_SEPARATOR;
            intFormatter.rounding = NumberBaseRoundType.NEAREST;
            floatFormatter = new NumberFormatter();
            floatFormatter.thousandsSeparatorTo = THOUSANDS_SEPARATOR;
            floatFormatter.decimalSeparatorTo = DECIMALS_SEPARATOR;
            floatFormatter.rounding = NumberBaseRoundType.NEAREST;
         }
      }
      
      public static function replaceWithFormattedPrice(param1:Number, param2:String, param3:RegExp, param4:String) : String
      {
         return PriceFormatter.instance.format(param1,param2,param3,param4);
      }
      
      public static function round(param1:Number, param2:int = 0) : String
      {
         floatFormatter.precision = param2;
         return floatFormatter.format(param1);
      }
      
      public static function roundInteger(param1:Number) : String
      {
         return intFormatter.format(param1);
      }
      
      public static function distillAndWrite(param1:String, param2:TextField, param3:String = "left", param4:TextFormat = null) : Boolean
      {
         var _loc7_:int = 0;
         var _loc5_:Number = param2.width;
         param2.autoSize = param3;
         param2.text = param1;
         if(param4 != null)
         {
            param2.defaultTextFormat = param4;
         }
         if(param2.width <= _loc5_)
         {
            return false;
         }
         var _loc6_:* = param1;
         while(param2.width > _loc5_)
         {
            _loc7_ = _loc6_.length;
            _loc6_ = _loc6_.substring(0,_loc7_ - 3) + "… ";
            param2.text = _loc6_;
         }
         return true;
      }
   }
}

