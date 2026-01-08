package net.bigpoint.dataInterchange.connectors
{
   import flash.events.Event;
   import net.bigpoint.dataInterchange.Transaction;
   
   public interface IConnector
   {
      
      function requestAction(param1:Transaction) : void;
      
      function replyReceived(param1:Transaction, param2:Event) : void;
   }
}

