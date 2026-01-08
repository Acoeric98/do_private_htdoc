package net.bigpoint.dataInterchange.connectors
{
   import flash.events.*;
   import flash.net.*;
   import net.bigpoint.dataInterchange.Transaction;
   
   public class HTTPConnector implements IConnector
   {
      
      protected var _serverUrl:String = "";
      
      public function HTTPConnector()
      {
         super();
      }
      
      public function requestAction(param1:Transaction) : void
      {
         var request:URLRequest;
         var requestVars:URLVariables;
         var transaction:Transaction = param1;
         var loader:URLLoader = new URLLoader();
         loader.addEventListener(Event.COMPLETE,transaction.replyReceived);
         loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,transaction.errorOccured);
         loader.addEventListener(IOErrorEvent.IO_ERROR,transaction.errorOccured);
         request = new URLRequest(this._serverUrl);
         requestVars = new URLVariables();
         requestVars.action = transaction.request.action;
         requestVars.params = transaction.request.serializedParameters;
         request.data = requestVars;
         request.method = URLRequestMethod.POST;
         try
         {
            loader.load(request);
         }
         catch(error:Error)
         {
         }
      }
      
      public function replyReceived(param1:Transaction, param2:Event) : void
      {
         param1.response.rawData = param2.target.data;
      }
      
      public function set serverURL(param1:String) : void
      {
         this._serverUrl = param1;
      }
      
      public function get serverURL() : String
      {
         return this._serverUrl;
      }
   }
}

