package net.bigpoint.dataInterchange
{
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.dataInterchange.connectors.IConnector;
   import net.bigpoint.dataInterchange.serialization.ISerializer;
   
   public class InterchangeBroker
   {
      
      private static const logger:ILogger = Log.getLogger("InterchangeBroker");
      
      protected var _serializer:ISerializer = null;
      
      protected var _connector:IConnector = null;
      
      public function InterchangeBroker()
      {
         super();
      }
      
      public function executeAction(param1:String, param2:Object, param3:Function, param4:Function) : void
      {
         var _loc5_:Transaction = new Transaction();
         _loc5_.broker = this;
         _loc5_.callback = param3;
         _loc5_.errorCallback = param4;
         _loc5_.request.action = param1;
         _loc5_.request.parameters = param2;
         _loc5_.request.serializedParameters = this._serializer.serialize(param2);
         this._connector.requestAction(_loc5_);
      }
      
      public function replyReceived(param1:Transaction) : void
      {
         var rawData:Object = null;
         var transaction:Transaction = param1;
         try
         {
            rawData = this._serializer.unserialize(transaction.response.rawData) as Object;
            if(rawData == null)
            {
               transaction.response.hasErrors = true;
            }
            if(rawData != null && rawData.data != undefined)
            {
               transaction.response.data = rawData.data;
            }
            if(rawData != null && rawData.isError != undefined)
            {
               transaction.response.hasErrors = rawData.isError == 1;
            }
            if(rawData != null && transaction.response.hasErrors && rawData.error != undefined)
            {
               transaction.response.error = rawData.error;
            }
            transaction.executeCallback();
         }
         catch(e:Error)
         {
            transaction.response.hasErrors = true;
            errorOccured(transaction);
         }
      }
      
      public function errorOccured(param1:Transaction) : void
      {
         param1.response.hasErrors = true;
         param1.executeErrorCallback();
      }
      
      public function set connector(param1:IConnector) : void
      {
         this._connector = param1;
      }
      
      public function get connector() : IConnector
      {
         return this._connector;
      }
      
      public function set serializer(param1:ISerializer) : void
      {
         this._serializer = param1;
      }
      
      public function get serializer() : ISerializer
      {
         return this._serializer;
      }
   }
}

