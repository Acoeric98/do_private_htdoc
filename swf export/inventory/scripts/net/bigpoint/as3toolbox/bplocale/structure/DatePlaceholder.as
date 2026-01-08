package net.bigpoint.as3toolbox.bplocale.structure
{
   import flash.utils.Dictionary;
   
   public class DatePlaceholder extends FormattedPlaceholder
   {
      
      public function DatePlaceholder()
      {
         super();
      }
      
      override public function getText(param1:Dictionary) : String
      {
         var _loc2_:Date = null;
         if(format == null)
         {
            throw new Error("DatePlaceholder " + name + " has no format defined.");
         }
         var _loc3_:* = param1[name];
         var _loc4_:Dictionary = new Dictionary();
         if(_loc3_ is Date)
         {
            _loc2_ = _loc3_;
         }
         else
         {
            _loc2_ = new Date(_loc3_);
         }
         _loc4_[SystemPlaceholder.SYSTEM_YEAR] = _loc2_.fullYear;
         _loc4_[SystemPlaceholder.SYSTEM_MONTH] = _loc2_.month;
         _loc4_[SystemPlaceholder.SYSTEM_DAY] = _loc2_.date;
         _loc4_[SystemPlaceholder.SYSTEM_HOUR] = _loc2_.hours;
         _loc4_[SystemPlaceholder.SYSTEM_MINUTE] = _loc2_.minutes;
         _loc4_[SystemPlaceholder.SYSTEM_SECOND] = _loc2_.seconds;
         _loc4_[SystemPlaceholder.SYSTEM_MILLISECOND] = _loc2_.milliseconds;
         return format.getText(_loc4_);
      }
   }
}

