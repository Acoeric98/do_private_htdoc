package net.bigpoint.as3toolbox.bplocale.structure
{
   import flash.utils.Dictionary;
   
   public class TimespanPlaceholder extends FormattedPlaceholder
   {
      
      private var _units:*;
      
      public function TimespanPlaceholder()
      {
         super();
      }
      
      public function get units() : *
      {
         return this._units;
      }
      
      public function set units(param1:*) : void
      {
         this._units = Placeholder.parseIntParameter(param1);
      }
      
      override public function link() : void
      {
         super.link();
         if(this._units is Placeholder)
         {
            (this._units as Placeholder).link();
         }
      }
      
      override public function getText(param1:Dictionary) : String
      {
         var _loc2_:Date = null;
         if(format == null)
         {
            throw new Error("TimespanPlaceholder " + name + " has no format defined.");
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
         var _loc5_:int;
         var _loc6_:* = _loc5_ = Placeholder.retrieveIntParameter(this._units,param1);
         var _loc7_:int = _loc2_.getUTCFullYear() - 1970;
         var _loc8_:int = int(_loc2_.getUTCMonth());
         var _loc9_:int = _loc2_.getUTCDate() - 1;
         if(_loc6_ == 0 || _loc6_ == this.units && _loc7_ == 0)
         {
            _loc4_[SystemPlaceholder.SYSTEM_YEAR] = -1;
         }
         else
         {
            _loc4_[SystemPlaceholder.SYSTEM_YEAR] = _loc7_;
            _loc6_--;
         }
         if(_loc6_ == 0 || _loc6_ == this.units && _loc8_ == 0)
         {
            _loc4_[SystemPlaceholder.SYSTEM_MONTH] = -1;
         }
         else
         {
            _loc4_[SystemPlaceholder.SYSTEM_MONTH] = _loc8_;
            _loc6_--;
         }
         if(_loc6_ == 0 || _loc6_ == this.units && _loc9_ == 0)
         {
            _loc4_[SystemPlaceholder.SYSTEM_DAY] = -1;
         }
         else
         {
            _loc4_[SystemPlaceholder.SYSTEM_DAY] = _loc9_;
            _loc6_--;
         }
         if(_loc6_ == 0 || _loc6_ == this.units && _loc2_.getUTCHours() == 0)
         {
            _loc4_[SystemPlaceholder.SYSTEM_HOUR] = -1;
         }
         else
         {
            _loc4_[SystemPlaceholder.SYSTEM_HOUR] = _loc2_.getUTCHours();
            _loc6_--;
         }
         if(_loc6_ == 0 || _loc6_ == this.units && _loc2_.getUTCMinutes() == 0)
         {
            _loc4_[SystemPlaceholder.SYSTEM_MINUTE] = -1;
         }
         else
         {
            _loc4_[SystemPlaceholder.SYSTEM_MINUTE] = _loc2_.getUTCMinutes();
            _loc6_--;
         }
         if(_loc6_ == 0 || _loc6_ == this.units && _loc2_.getUTCSeconds() == 0)
         {
            _loc4_[SystemPlaceholder.SYSTEM_SECOND] = -1;
         }
         else
         {
            _loc4_[SystemPlaceholder.SYSTEM_SECOND] = _loc2_.getUTCSeconds();
            _loc6_--;
         }
         if(_loc6_ == 0 || _loc6_ == this.units && _loc2_.getUTCMilliseconds() == 0)
         {
            _loc4_[SystemPlaceholder.SYSTEM_MILLISECOND] = -1;
         }
         else
         {
            _loc4_[SystemPlaceholder.SYSTEM_MILLISECOND] = _loc2_.getUTCMilliseconds();
            _loc6_--;
         }
         return format.getText(_loc4_);
      }
   }
}

