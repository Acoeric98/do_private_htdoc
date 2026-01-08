package net.bigpoint.as3toolbox.bplocale.structure
{
   internal class SystemPlaceholder extends Placeholder
   {
      
      private static const SYSTEM_PLACEHOLDERS_NAMES:Array = ["quantity","year","month","day","hour","minute","second","millisecond","currencyBig","currencySmall","currencyTotal"];
      
      public function SystemPlaceholder()
      {
         super();
      }
      
      public static function get SYSTEM_QUANTITY() : String
      {
         return SYSTEM_PLACEHOLDERS_NAMES[0];
      }
      
      public static function get SYSTEM_YEAR() : String
      {
         return SYSTEM_PLACEHOLDERS_NAMES[1];
      }
      
      public static function get SYSTEM_MONTH() : String
      {
         return SYSTEM_PLACEHOLDERS_NAMES[2];
      }
      
      public static function get SYSTEM_DAY() : String
      {
         return SYSTEM_PLACEHOLDERS_NAMES[3];
      }
      
      public static function get SYSTEM_HOUR() : String
      {
         return SYSTEM_PLACEHOLDERS_NAMES[4];
      }
      
      public static function get SYSTEM_MINUTE() : String
      {
         return SYSTEM_PLACEHOLDERS_NAMES[5];
      }
      
      public static function get SYSTEM_SECOND() : String
      {
         return SYSTEM_PLACEHOLDERS_NAMES[6];
      }
      
      public static function get SYSTEM_MILLISECOND() : String
      {
         return SYSTEM_PLACEHOLDERS_NAMES[7];
      }
      
      public static function get SYSTEM_CURRENCY_BIG() : String
      {
         return SYSTEM_PLACEHOLDERS_NAMES[8];
      }
      
      public static function get SYSTEM_CURRENCY_SMALL() : String
      {
         return SYSTEM_PLACEHOLDERS_NAMES[9];
      }
      
      public static function get SYSTEM_CURRENCY_TOTAL() : String
      {
         return SYSTEM_PLACEHOLDERS_NAMES[10];
      }
      
      public static function isSystemPlaceholder(param1:String) : Boolean
      {
         var _loc2_:uint = SYSTEM_PLACEHOLDERS_NAMES.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1 == SYSTEM_PLACEHOLDERS_NAMES[_loc3_])
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      override public function set name(param1:String) : void
      {
         var _loc2_:uint = SYSTEM_PLACEHOLDERS_NAMES.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1 == SYSTEM_PLACEHOLDERS_NAMES[_loc3_])
            {
               super.name = SYSTEM_PLACEHOLDERS_NAMES[_loc3_];
               return;
            }
            _loc3_++;
         }
         throw new Error(param1 + " is not a valid SystemPlaceholder name.");
      }
   }
}

