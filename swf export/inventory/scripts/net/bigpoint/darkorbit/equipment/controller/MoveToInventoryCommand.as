package net.bigpoint.darkorbit.equipment.controller
{
   import net.bigpoint.darkorbit.equipment.application.ApplicationNotificationNames;
   import net.bigpoint.darkorbit.equipment.events.ActionIdentifiers;
   import net.bigpoint.darkorbit.equipment.model.ConnectionProxy;
   import net.bigpoint.darkorbit.equipment.view.components.SuspendView;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.command.SimpleCommand;
   
   public class MoveToInventoryCommand extends SimpleCommand implements ICommand
   {
      
      public function MoveToInventoryCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:String = param1.getName();
         var _loc3_:Object = param1.getBody() as Object;
         var _loc4_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
         switch(_loc2_)
         {
            case ApplicationNotificationNames.QUERY_ITEMS_MOVED_TO_INVENTORY:
               _loc4_.itemMoveRequest(_loc3_,ActionIdentifiers.MOVE_TO_INVENTORY);
               break;
            case ApplicationNotificationNames.QUERY_INVENTORY_ITEMS_REARRANGED:
               _loc4_.rearrangeInventoryRequest(_loc3_,ActionIdentifiers.INVENTORY_REARRANGE);
               break;
            case ApplicationNotificationNames.QUERY_INVENTORY_ITEM_SPLIT:
               _loc4_.splitInventoryItemRequest(_loc3_,ActionIdentifiers.INVENTORY_ITEM_SPLIT);
         }
      }
   }
}

