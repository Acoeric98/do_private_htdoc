package net.bigpoint.as3toolbox.bplocale.structure
{
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class NumberPlaceholder extends Placeholder
   {
      
      private var _precision:* = -1;
      
      public function NumberPlaceholder()
      {
         super();
      }
      
      public function get precision() : *
      {
         return this._precision;
      }
      
      public function set precision(param1:*) : void
      {
         this._precision = Placeholder.parseIntParameter(param1);
      }
      
      override public function link() : void
      {
         super.link();
         if(this._precision is Placeholder)
         {
            (this._precision as Placeholder).link();
         }
      }
      
      override public function getText(param1:Dictionary) : String
      {
         var _loc7_:uint = 0;
         var _loc2_:Number = Number(param1[name]);
         var _loc3_:int = Placeholder.retrieveIntParameter(this._precision,param1);
         var _loc4_:String = this.roundTo(_loc2_,_loc3_).toString();
         var _loc5_:int = int(_loc4_.indexOf("."));
         var _loc6_:uint = BPLocale.SEPARATOR_PATTERN.length;
         if(_loc5_ >= 0)
         {
            _loc4_ = _loc4_.replace(".",BPLocale.DECIMAL_MARK);
         }
         if(_loc6_ <= 0)
         {
            return _loc4_;
         }
         _loc5_ = _loc5_ < 0 ? _loc4_.length : _loc5_;
         _loc5_ = _loc5_ - BPLocale.SEPARATOR_PATTERN[0];
         _loc7_ = _loc7_ < _loc6_ - 1 ? 1 : 0;
         while(_loc5_ > 0)
         {
            _loc4_ = _loc4_.slice(0,_loc5_) + BPLocale.THOUSANDS_SEPARATOR + _loc4_.slice(_loc5_);
            _loc5_ -= BPLocale.SEPARATOR_PATTERN[_loc7_];
            if(_loc7_ < _loc6_ - 1)
            {
               _loc7_++;
            }
         }
         return _loc4_;
      }
      
      private function roundTo(param1:Number, param2:int = 0) : Number
      {
         var _loc3_:Number = Math.pow(10,param2);
         return Math.round(param1 * _loc3_) / _loc3_;
      }
   }
}

