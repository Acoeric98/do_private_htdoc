package net.bigpoint.darkorbit.equipment.events
{
   import flash.events.Event;
   
   public class MoveItemEvent extends Event
   {
      
      public static const ITEM_REARRANGED_WITHIN_INVENTORY:String = "ITEM_REARRANGED_WITHIN_INVENTORY";
      
      public static const ITEMS_MOVED_TO_INVENTORY:String = "ITEMS_MOVED_TO_INVENTORY";
      
      public static const ITEMS_MOVED_TO_SHIP_EQUIPMENT:String = "ITEMS_MOVED_TO_SHIP_EQUIPMENT";
      
      public static const ITEMS_MOVED_TO_DRONE_EQUIPMENT:String = "ITEMS_MOVED_TO_DRONE_EQUIPMENT";
      
      public static const ITEMS_MOVED_TO_N_DRONE_EQUIPMENT:String = "ITEMS_MOVED_TO_N_DRONE_EQUIPMENT";
      
      public static const ITEMS_MOVED_TO_PET_EQUIPMENT:String = "ITEMS_MOVED_TO_PET_EQUIPMENT";
      
      public static const SELL_ITEM:String = "SELL_ITEM";
      
      public static const REMOVE_ITEM:String = "REMOVE_ITEM";
      
      public static const STACK_MOVED_TO_EMPTY_SLOT:String = "STACK_MOVED_TO_EMPTY_SLOT";
      
      public static const QUICK_BUY_ITEM:String = "QUICK_BUY_ITEM";
      
      public static const SELL_SHIP_OR_PET:String = "SELL_PET";
      
      public var transporter:Object;
      
      public function MoveItemEvent(param1:String, param2:Object, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.transporter = param2;
      }
   }
}

