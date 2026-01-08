package net.bigpoint.darkorbit.equipment.events
{
   import flash.events.Event;
   
   public class InventoryEvent extends Event
   {
      
      public static const INVENTORY_SWITCHED:String = "TAB_SWITCHED";
      
      public static const BUYABLE_SLOT_CLICKED:String = "BUYABLE_SLOT_CLICKED";
      
      public static const DESIGN_MENU_CLICK:String = "DESIGN_MENU_ROLLOVER";
      
      public static const REPAIR_BUTTON_CLICKED:String = "REPAIR_BUTTON_CLICKED";
      
      public static const CHANGE_CPU_MODE_BUTTON_CLICKED:String = "CHANGE_CPU_MODE_BUTTON_CLICKED";
      
      public static const CHECK_INVENTORY_CONTEXT_BUTTON:String = "CHECK_INVENTORY_CONTEXT_BUTTON";
      
      public static const UPDATE_SELL_BUTTON:String = "UPDATE_SELL_BUTTON";
      
      public static const CLOSE_DESIGN_MENU:String = "CLOSE_DESIGN_MENU";
      
      public static const UPDATE_DRONES_EFFECT:String = "UPDATE_DRONES_EFFECT";
      
      public var info:Object;
      
      public function InventoryEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.info = param2;
      }
   }
}

