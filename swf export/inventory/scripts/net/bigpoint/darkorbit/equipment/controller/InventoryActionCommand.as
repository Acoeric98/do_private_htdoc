package net.bigpoint.darkorbit.equipment.controller
{
   import net.bigpoint.darkorbit.equipment.application.ApplicationNotificationNames;
   import net.bigpoint.darkorbit.equipment.events.ActionIdentifiers;
   import net.bigpoint.darkorbit.equipment.model.ConnectionProxy;
   import net.bigpoint.darkorbit.equipment.view.components.SuspendView;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.command.SimpleCommand;
   
   public class InventoryActionCommand extends SimpleCommand implements ICommand
   {
      
      public function InventoryActionCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:String = param1.getName();
         var _loc3_:Object = param1.getBody();
         var _loc4_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
         switch(_loc2_)
         {
            case ApplicationNotificationNames.QUERY_FOR_SELLING_SHIP:
               sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
               _loc4_.shipSellRequest(_loc3_);
               break;
            case ApplicationNotificationNames.QUERY_FOR_SELLING_ITEM:
               sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
               _loc4_.itemSellRequest(_loc3_,ActionIdentifiers.SELL);
               break;
            case ApplicationNotificationNames.QUERY_FOR_QUICK_BUY_ITEM:
               sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
               _loc4_.itemQuickBuyRequest(_loc3_,ActionIdentifiers.QUICK_BUY);
               break;
            case ApplicationNotificationNames.GET_ITEM_SALE_VALUE:
               sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
               _loc4_.getItemSaleValue(_loc3_);
               break;
            case ApplicationNotificationNames.GET_ITEM_COST:
               sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
               _loc4_.getItemBuyingCost(_loc3_);
               break;
            case ApplicationNotificationNames.GET_CPU_TYPE:
               sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
               _loc4_.getCPUType(String(_loc3_));
               break;
            case ApplicationNotificationNames.QUERY_REPAIR_ITEM:
               sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
               _loc4_.itemRepairRequest(_loc3_,ActionIdentifiers.REPAIR_DRONE);
               break;
            case ApplicationNotificationNames.QUERY_REPAIR_MODULE:
               sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
               _loc4_.itemRepairRequest(_loc3_,ActionIdentifiers.REPAIR_MODULE);
               break;
            case ApplicationNotificationNames.CHECK_CONTEXT_BUTTON:
               _loc4_.checkContextButton();
               break;
            case ApplicationNotificationNames.QUERY_SERVER_FOR_CPU_MODE_CHANGE:
               sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
               _loc4_.changeCPUModeRequest(_loc3_,ActionIdentifiers.CPU_MODE);
               break;
            case ApplicationNotificationNames.QUERY_BUY_EXTRA_PET_SLOT:
               sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
               _loc4_.buyExtraPetSlotRequest(_loc3_);
         }
      }
   }
}

