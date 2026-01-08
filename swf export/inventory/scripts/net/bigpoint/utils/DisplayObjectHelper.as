package net.bigpoint.utils
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public class DisplayObjectHelper
   {
      
      public function DisplayObjectHelper()
      {
         super();
      }
      
      public static function removeDisplayObject(param1:DisplayObject) : void
      {
         var _loc2_:DisplayObjectContainer = null;
         if(param1)
         {
            _loc2_ = param1.parent;
            if(_loc2_)
            {
               _loc2_.removeChild(param1);
            }
         }
      }
   }
}

