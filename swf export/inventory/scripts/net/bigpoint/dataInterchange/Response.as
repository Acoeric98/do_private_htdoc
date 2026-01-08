package net.bigpoint.dataInterchange
{
   import flash.events.Event;
   
   public class Response
   {
      
      protected var _hasErrors:Boolean = false;
      
      protected var _error:Object;
      
      protected var _data:*;
      
      protected var _rawData:String = "";
      
      protected var _finishEvent:Event = null;
      
      public function Response()
      {
         super();
         this._error = new Object();
      }
      
      public function set finishEvent(param1:Event) : void
      {
         this._finishEvent = param1;
      }
      
      public function get finishEvent() : Event
      {
         return this._finishEvent;
      }
      
      public function set rawData(param1:String) : void
      {
         this._rawData = param1;
      }
      
      public function get rawData() : String
      {
         return this._rawData;
      }
      
      public function set data(param1:*) : void
      {
         this._data = param1;
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function set error(param1:Object) : void
      {
         this._error = param1;
      }
      
      public function get error() : Object
      {
         return this._error;
      }
      
      public function set hasErrors(param1:Boolean) : void
      {
         this._hasErrors = param1;
      }
      
      public function get hasErrors() : Boolean
      {
         return this._hasErrors;
      }
   }
}

