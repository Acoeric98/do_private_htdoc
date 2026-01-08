package net.bigpoint.darkorbit.equipment.view.components.buttons
{
   import flash.events.Event;
   
   public class SelectableGenericButtonEvent extends Event
   {
      
      public static const EVENT_SELECTION_CHANGED:String = "selectionChanged";
      
      private var state:Boolean;
      
      public function SelectableGenericButtonEvent(param1:String, param2:Boolean)
      {
         super(param1);
         this.state = param2;
      }
      
      public function isSelected() : Boolean
      {
         return this.state;
      }
   }
}

