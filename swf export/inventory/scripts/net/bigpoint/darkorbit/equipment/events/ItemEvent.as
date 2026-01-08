package net.bigpoint.darkorbit.equipment.events
{
   import flash.events.Event;
   
   public class ItemEvent extends Event
   {
      
      public static const ITEM_SELECTED:String = "ITEM_SELECTED";
      
      public static const ITEM_MULTISELECTED:String = "ITEM_MULTISELECTED";
      
      public var ID:String;
      
      public var itemName:String;
      
      public function ItemEvent(param1:String, param2:String, param3:String = null, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param4,param5);
         this.ID = param2;
         this.itemName = param3;
      }
   }
}

