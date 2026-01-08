package net.bigpoint.dataInterchange
{
   import flash.events.Event;
   
   public class DataInterchangeEvent extends Event
   {
      
      public static const CONFIG_RECEIVED:String = "CONFIG_RECEIVED";
      
      public static const SHIP_CONFIG_CLEARED_REPLY_RECEIVED:String = "SHIP_CONFIG_CLEARED_REPLY_RECEIVED";
      
      public static const ACTION_REPLY_RECEIVED:String = "ACTION_REPLY_RECEIVED";
      
      public static const DESIGN_CHANGE_REPLY_RECEIVED:String = "DESIGN_CHANGE_REPLY_RECEIVED";
      
      public static const PET_NAME_CHANGE_REPLY_RECEIVED:String = "PET_NAME_CHANGE_REPLY_RECEIVED";
      
      public static const CPU_MODE_CHANGE_REPLY:String = "CPU_MODE_CHANGE_REPLY";
      
      public static const SERVER_RESPONSE_ERROR:String = "SERVER_RESPONSE_ERROR";
      
      public static const DRONE_ITEMS_EQUIPPED_REPLY_RECEIVED:String = "DRONE_ITEMS_EQUIPPED_REPLY_RECEIVED";
      
      public var transaction:Transaction;
      
      public function DataInterchangeEvent(param1:String, param2:Transaction, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.transaction = param2;
      }
   }
}

