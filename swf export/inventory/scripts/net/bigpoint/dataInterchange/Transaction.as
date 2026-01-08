package net.bigpoint.dataInterchange
{
   import flash.events.Event;
   
   public class Transaction
   {
      
      protected var _broker:InterchangeBroker = null;
      
      protected var _request:Request = new Request();
      
      protected var _response:Response = new Response();
      
      protected var _callback:Function = null;
      
      protected var _errorCallback:Function = null;
      
      public function Transaction()
      {
         super();
      }
      
      public function executeCallback() : void
      {
         this._callback(this);
      }
      
      public function executeErrorCallback() : void
      {
         this._errorCallback(this);
      }
      
      public function replyReceived(param1:Event) : void
      {
         this._response.finishEvent = param1;
         this._broker.connector.replyReceived(this,param1);
         this._broker.replyReceived(this);
      }
      
      public function errorOccured(param1:Event) : void
      {
         this._response.finishEvent = param1;
         this._broker.errorOccured(this);
      }
      
      public function hasErrors() : Boolean
      {
         return this._response.hasErrors;
      }
      
      public function getErrorMessage() : String
      {
         return this._response.error.message == undefined ? "" : this._response.error.message;
      }
      
      public function set broker(param1:InterchangeBroker) : void
      {
         this._broker = param1;
      }
      
      public function get broker() : InterchangeBroker
      {
         return this._broker;
      }
      
      public function set callback(param1:Function) : void
      {
         this._callback = param1;
      }
      
      public function get errorCallback() : Function
      {
         return this._errorCallback;
      }
      
      public function set errorCallback(param1:Function) : void
      {
         this._errorCallback = param1;
      }
      
      public function get callback() : Function
      {
         return this._callback;
      }
      
      public function set request(param1:Request) : void
      {
         this._request = param1;
      }
      
      public function get request() : Request
      {
         return this._request;
      }
      
      public function set response(param1:Response) : void
      {
         this._response = param1;
      }
      
      public function get response() : Response
      {
         return this._response;
      }
   }
}

