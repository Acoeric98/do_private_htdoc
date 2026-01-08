package net.bigpoint.darkorbit.equipment.events
{
   import flash.events.Event;
   
   public class MenuEvent extends Event
   {
      
      public static const EVENT_BUTTON_CLICKED:String = "EVENT_BUTTON_CLICKED";
      
      public static const EVENT_CONFIG_BUTTON_CLICKED:String = "EVENT_CONFIG_BUTTON_CLICKED";
      
      public static const EVENT_CONFIG_CLEAR_BUTTON_CLICKED:String = "EVENT_CONFIG_CLEAR_BUTTON_CLICKED";
      
      public static const EVENT_HANGAR_SLOT_BUTTON_CLICKED:String = "EVENT_HANGAR_SLOT_BUTTON_CLICKED";
      
      public var ID:int;
      
      public function MenuEvent(param1:String, param2:int, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.ID = param2;
      }
   }
}

