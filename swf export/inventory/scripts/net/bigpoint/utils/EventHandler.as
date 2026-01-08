package net.bigpoint.utils
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class EventHandler extends Sprite
   {
      
      private var eventList:Array;
      
      private var _dispatcher:DisplayObject;
      
      public function EventHandler(param1:DisplayObject)
      {
         super();
         this.eventList = new Array();
         this._dispatcher = param1;
      }
      
      public function killDispatcher() : void
      {
         this._dispatcher = null;
      }
      
      public function get dispatcher() : DisplayObject
      {
         return this._dispatcher;
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = true) : void
      {
         this.eventList.push({
            "TYPE":param1,
            "LISTENER":param2
         });
         if(this._dispatcher.hasEventListener(param1))
         {
            this._dispatcher.removeEventListener(param1,param2);
         }
         this._dispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function RemoveEvent(param1:String) : void
      {
         var _loc2_:int = int(this.eventList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.eventList[_loc3_].TYPE == param1)
            {
               this._dispatcher.removeEventListener(this.eventList[_loc3_].TYPE,this.eventList[_loc3_].LISTENER);
               this.eventList.splice(_loc3_,1);
               _loc2_ = int(this.eventList.length);
            }
            _loc3_++;
         }
      }
      
      public function RemoveEvents() : void
      {
         var _loc1_:int = int(this.eventList.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this._dispatcher.removeEventListener(this.eventList[_loc2_].TYPE,this.eventList[_loc2_].LISTENER);
            _loc2_++;
         }
         this.eventList = [];
      }
   }
}

