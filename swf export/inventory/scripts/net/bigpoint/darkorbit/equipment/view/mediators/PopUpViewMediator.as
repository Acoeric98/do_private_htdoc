package net.bigpoint.darkorbit.equipment.view.mediators
{
   import net.bigpoint.darkorbit.equipment.application.ApplicationNotificationNames;
   import net.bigpoint.darkorbit.equipment.events.PopUpEvent;
   import net.bigpoint.darkorbit.equipment.model.transporter.PopUpDefiner;
   import net.bigpoint.darkorbit.equipment.view.components.PopUpView;
   import org.puremvc.as3.interfaces.IMediator;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.mediator.Mediator;
   
   public class PopUpViewMediator extends Mediator implements IMediator
   {
      
      public static const NAME:String = "PopUpViewMediator";
      
      public function PopUpViewMediator(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
         this.popUpView.addEventListener(PopUpEvent.REMOVE_SUSPEND_VIEW,this.handleRemoveSuspendView);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ApplicationNotificationNames.SHOW_POP_UP];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:PopUpDefiner = null;
         switch(param1.getName())
         {
            case ApplicationNotificationNames.SHOW_POP_UP:
               _loc2_ = param1.getBody() as PopUpDefiner;
               this.handlePopUpType(_loc2_);
         }
      }
      
      private function handlePopUpType(param1:PopUpDefiner) : void
      {
         switch(param1.popUpType)
         {
            case PopUpDefiner.SELL_SHIP_POPUP:
               this.popUpView.displaySellShipPopUp(param1);
               break;
            case PopUpDefiner.SELL_POPUP:
               this.popUpView.displaySellPopUp(param1);
               break;
            case PopUpDefiner.SPLIT_STACK_POPUP:
               this.popUpView.displayStackSplitPopUp(param1);
               break;
            case PopUpDefiner.BUYABLE_SLOT_POPUP:
               this.popUpView.displayBuyPetSlotPopUp(param1);
               break;
            case PopUpDefiner.REPAIR_ITEM_POPUP:
               this.popUpView.displayRepairItemPopUp(param1);
               break;
            case PopUpDefiner.REPAIR_MODULE_POPUP:
               this.popUpView.displayRepairModulePopUp(param1);
               break;
            case PopUpDefiner.RENAME_PET:
               this.popUpView.displayChangePETNamePopUp(param1);
               break;
            case PopUpDefiner.QUICK_BUY_ITEM:
               this.popUpView.displayQuickBuyItemPopUp(param1);
               break;
            case PopUpDefiner.AMMO_CPU_CHOICE:
               this.popUpView.displayChangeCPUModePopUp(param1);
               break;
            case PopUpDefiner.ERROR_POPUP:
               this.popUpView.displayErrorMessagePopUp(param1);
               break;
            case PopUpDefiner.CLEAR_SHIP_CONFIG_CONFIRMATION_POPUP:
               this.popUpView.displayClearShipConfigurationPopUp(param1);
         }
      }
      
      private function handleRemoveSuspendView(param1:PopUpEvent) : void
      {
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
      }
      
      private function get popUpView() : PopUpView
      {
         return viewComponent as PopUpView;
      }
   }
}

