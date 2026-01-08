package net.bigpoint.darkorbit.equipment.events
{
   import flash.events.Event;
   
   public class GridEvent extends Event
   {
      
      public static const FOCUSED:String = "FOCUSED";
      
      public static const UNFOCUSED:String = "UNFOCUSED";
      
      public static const FILL_IN_GAP:String = "FILL_IN_GAP";
      
      public static const RE_ORDER_GRID:String = "RE_ORDER_GRID";
      
      public var slotID:int;
      
      public function GridEvent(param1:String, param2:int = 0, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.slotID = param2;
      }
   }
}

