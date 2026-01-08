package net.bigpoint.darkorbit.equipment.view.mediators
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.equipment.application.ApplicationNotificationNames;
   import net.bigpoint.darkorbit.equipment.view.components.IconView;
   import org.puremvc.as3.interfaces.IMediator;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.mediator.Mediator;
   
   public class IconViewMediator extends Mediator implements IMediator
   {
      
      public static const NAME:String = "IconViewMediator";
      
      public var selectedIconID:int = -1;
      
      public function IconViewMediator(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ApplicationNotificationNames.END_LOADING];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         switch(param1.getName())
         {
            case ApplicationNotificationNames.END_LOADING:
         }
      }
      
      private function handleIconClicked(param1:Event) : void
      {
         this.selectedIconID = this.iconView.selectedIcon;
         sendNotification(ApplicationNotificationNames.ICON_CLICKED);
      }
      
      private function get iconView() : IconView
      {
         return viewComponent as IconView;
      }
   }
}

