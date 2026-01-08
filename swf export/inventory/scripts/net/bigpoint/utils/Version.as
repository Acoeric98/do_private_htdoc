package net.bigpoint.utils
{
   import flash.utils.ByteArray;
   
   public class Version
   {
      
      public static const VersionXML:Class = Version_VersionXML;
      
      public function Version()
      {
         super();
      }
      
      public static function getVersion() : String
      {
         var _loc1_:String = "";
         var _loc2_:ByteArray = new VersionXML() as ByteArray;
         var _loc3_:XML = new XML(_loc2_.readUTFBytes(_loc2_.length));
         _loc1_ = String(_loc3_.major.*) + "." + String(_loc3_.minor.*);
         var _loc4_:String = String(_loc3_.build.*);
         if(_loc4_.length > 0)
         {
            _loc1_ += "." + _loc4_;
         }
         var _loc5_:String = String(_loc3_.suffix.*);
         if(_loc5_.length > 0)
         {
            _loc5_ = " " + _loc5_;
         }
         else
         {
            _loc5_ = "";
         }
         return _loc1_ + _loc5_;
      }
   }
}

