package net.bigpoint.darkorbit.equipment.controller
{
   import net.bigpoint.darkorbit.equipment.application.ApplicationNotificationNames;
   import net.bigpoint.darkorbit.equipment.events.ActionIdentifiers;
   import net.bigpoint.darkorbit.equipment.model.ConnectionProxy;
   import net.bigpoint.darkorbit.equipment.model.transporter.Transporter;
   import net.bigpoint.darkorbit.equipment.view.components.SuspendView;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.command.SimpleCommand;
   
   public class MoveToEquipmentCommand extends SimpleCommand implements ICommand
   {
      
      public function MoveToEquipmentCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:String = param1.getName();
         var _loc3_:Transporter = param1.getBody() as Transporter;
         var _loc4_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
         switch(_loc2_)
         {
            case ApplicationNotificationNames.QUERY_ITEMS_MOVED_TO_SHIP_EQUIPMENT:
               _loc4_.itemMoveRequest(_loc3_,ActionIdentifiers.EQUIPMENT_SHIP_MOVE);
               break;
            case ApplicationNotificationNames.QUERY_ITEMS_MOVED_TO_DRONE_EQUIPMENT:
               _loc4_.itemMoveRequest(_loc3_,ActionIdentifiers.EQUIPMENT_DRONE_MOVE);
               break;
            case ApplicationNotificationNames.QUERY_ITEMS_MOVED_TO_N_DRONE_EQUIPMENT:
               _loc4_.equipItemsToNDronesRequest(_loc3_,ActionIdentifiers.EQUIPMENT_NDRONE_MOVE);
         }
      }
   }
}

