package net.bigpoint.darkorbit.equipment.application
{
   import net.bigpoint.darkorbit.equipment.controller.ClearCurrentShipConfigCommand;
   import net.bigpoint.darkorbit.equipment.controller.ContextuallyFilterInventoryCommand;
   import net.bigpoint.darkorbit.equipment.controller.HangarSlotChangeCommand;
   import net.bigpoint.darkorbit.equipment.controller.InventoryActionCommand;
   import net.bigpoint.darkorbit.equipment.controller.InventoryTextCommand;
   import net.bigpoint.darkorbit.equipment.controller.MoveToEquipmentCommand;
   import net.bigpoint.darkorbit.equipment.controller.MoveToInventoryCommand;
   import net.bigpoint.darkorbit.equipment.controller.PetCommand;
   import net.bigpoint.darkorbit.equipment.controller.StartupCommand;
   import net.bigpoint.darkorbit.equipment.controller.SwitchConfigCommand;
   import org.puremvc.as3.interfaces.IFacade;
   import org.puremvc.as3.patterns.facade.Facade;
   import org.puremvc.as3.patterns.observer.Notification;
   
   public class ApplicationFacade extends Facade implements IFacade
   {
      
      public function ApplicationFacade()
      {
         super();
      }
      
      public static function getInstance() : ApplicationFacade
      {
         if(instance == null)
         {
            instance = new ApplicationFacade();
         }
         return instance as ApplicationFacade;
      }
      
      override protected function initializeController() : void
      {
         super.initializeController();
         registerCommand(ApplicationNotificationNames.STARTUP,StartupCommand);
         registerCommand(ApplicationNotificationNames.CONFIG_SWITCHED,SwitchConfigCommand);
         registerCommand(ApplicationNotificationNames.CLEAR_CURRENT_SHIP_CONFIG,ClearCurrentShipConfigCommand);
         registerCommand(ApplicationNotificationNames.QUERY_ITEMS_MOVED_TO_INVENTORY,MoveToInventoryCommand);
         registerCommand(ApplicationNotificationNames.QUERY_INVENTORY_ITEMS_REARRANGED,MoveToInventoryCommand);
         registerCommand(ApplicationNotificationNames.QUERY_INVENTORY_ITEM_SPLIT,MoveToInventoryCommand);
         registerCommand(ApplicationNotificationNames.QUERY_ITEMS_MOVED_TO_SHIP_EQUIPMENT,MoveToEquipmentCommand);
         registerCommand(ApplicationNotificationNames.QUERY_ITEMS_MOVED_TO_DRONE_EQUIPMENT,MoveToEquipmentCommand);
         registerCommand(ApplicationNotificationNames.QUERY_ITEMS_MOVED_TO_N_DRONE_EQUIPMENT,MoveToEquipmentCommand);
         registerCommand(ApplicationNotificationNames.QUERY_FOR_SELLING_ITEM,InventoryActionCommand);
         registerCommand(ApplicationNotificationNames.QUERY_FOR_SELLING_SHIP,InventoryActionCommand);
         registerCommand(ApplicationNotificationNames.GET_ITEM_SALE_VALUE,InventoryActionCommand);
         registerCommand(ApplicationNotificationNames.QUERY_SERVER_FOR_CPU_MODE_CHANGE,InventoryActionCommand);
         registerCommand(ApplicationNotificationNames.GET_ITEM_COST,InventoryActionCommand);
         registerCommand(ApplicationNotificationNames.GET_CPU_TYPE,InventoryActionCommand);
         registerCommand(ApplicationNotificationNames.CHECK_CONTEXT_BUTTON,InventoryActionCommand);
         registerCommand(ApplicationNotificationNames.QUERY_REPAIR_ITEM,InventoryActionCommand);
         registerCommand(ApplicationNotificationNames.QUERY_REPAIR_MODULE,InventoryActionCommand);
         registerCommand(ApplicationNotificationNames.QUERY_BUY_EXTRA_PET_SLOT,InventoryActionCommand);
         registerCommand(ApplicationNotificationNames.QUERY_FOR_QUICK_BUY_ITEM,InventoryActionCommand);
         registerCommand(ApplicationNotificationNames.FIND_SELECTED_ITEM_INFO,InventoryTextCommand);
         registerCommand(ApplicationNotificationNames.CHANGE_SELECTED_DESIGN,InventoryTextCommand);
         registerCommand(ApplicationNotificationNames.TAB_BUTTON_CLICKED,ContextuallyFilterInventoryCommand);
         registerCommand(ApplicationNotificationNames.QUERY_CHANGE_PET_NAME,PetCommand);
         registerCommand(ApplicationNotificationNames.HANGAR_SLOT_CHANGED,HangarSlotChangeCommand);
      }
      
      public function startup(param1:Object) : void
      {
         this.sendNotification(ApplicationNotificationNames.STARTUP,param1);
      }
      
      override public function sendNotification(param1:String, param2:Object = null, param3:String = null) : void
      {
         notifyObservers(new Notification(param1,param2,param3));
      }
   }
}

