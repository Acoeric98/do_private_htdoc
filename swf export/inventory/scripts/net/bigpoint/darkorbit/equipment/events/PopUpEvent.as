package net.bigpoint.darkorbit.equipment.events
{
   import flash.events.Event;
   
   public class PopUpEvent extends Event
   {
      
      public static const REMOVE_SUSPEND_VIEW:String = "REMOVE_SUSPEND_VIEW";
      
      public static const DISPLAY_PET_RENAME_POPUP:String = "DISPLAY_PET_RENAME_POPUP";
      
      public function PopUpEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

