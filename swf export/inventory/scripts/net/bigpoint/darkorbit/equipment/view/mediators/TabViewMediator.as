package net.bigpoint.darkorbit.equipment.view.mediators
{
   import flash.events.Event;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.application.ApplicationNotificationNames;
   import net.bigpoint.darkorbit.equipment.events.InventoryEvent;
   import net.bigpoint.darkorbit.equipment.events.MenuEvent;
   import net.bigpoint.darkorbit.equipment.model.LoadDataProxy;
   import net.bigpoint.darkorbit.equipment.model.MenuProxy;
   import net.bigpoint.darkorbit.equipment.model.managers.HangarManagerProxy;
   import net.bigpoint.darkorbit.equipment.model.transporter.PopUpDefiner;
   import net.bigpoint.darkorbit.equipment.view.components.SuspendView;
   import net.bigpoint.darkorbit.equipment.view.components.TabView;
   import net.bigpoint.darkorbit.equipment.view.components.items.DragComponent;
   import org.puremvc.as3.interfaces.IMediator;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.mediator.Mediator;
   
   public class TabViewMediator extends Mediator implements IMediator
   {
      
      public static const NAME:String = "TabViewMediator";
      
      public var selectedTabID:String = "none";
      
      private var hangarManagerProxy:HangarManagerProxy;
      
      private var dataProxy:LoadDataProxy;
      
      private var accordionProxy:MenuProxy;
      
      public function TabViewMediator(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ApplicationNotificationNames.BOOTSTRAP_FINISHED,ApplicationNotificationNames.MENU_LAYOUT_DEFINED,ApplicationNotificationNames.HANGAR_SLOTS_INIT_COMPLETE,ApplicationNotificationNames.UPDATE_UI_AFTER_HANGAR_SLOT_CHANGED];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Vector.<int> = null;
         var _loc3_:Array = null;
         this.hangarManagerProxy = facade.retrieveProxy(HangarManagerProxy.PROXY_NAME) as HangarManagerProxy;
         this.dataProxy = facade.retrieveProxy(LoadDataProxy.PROXY_NAME) as LoadDataProxy;
         this.accordionProxy = facade.retrieveProxy(MenuProxy.PROXY_NAME) as MenuProxy;
         switch(param1.getName())
         {
            case ApplicationNotificationNames.MENU_LAYOUT_DEFINED:
               this.tabView.sectionList = this.accordionProxy.tabMenuList;
               this.tabView.addEventListener(MenuEvent.EVENT_CONFIG_BUTTON_CLICKED,this.handleConfigButtonClicked);
               this.tabView.addEventListener(MenuEvent.EVENT_CONFIG_CLEAR_BUTTON_CLICKED,this.handleConfigClearButtonClicked);
               break;
            case ApplicationNotificationNames.HANGAR_SLOTS_INIT_COMPLETE:
               _loc2_ = param1.getBody() as Vector.<int>;
               this.tabView.buildHangarSlotButtons(_loc2_);
               this.tabView.addEventListener(MenuEvent.EVENT_HANGAR_SLOT_BUTTON_CLICKED,this.handleHangarSlotButtonClicked);
               break;
            case ApplicationNotificationNames.BOOTSTRAP_FINISHED:
               _loc3_ = this.dataProxy.assetLib;
               this.tabView.buildMenu(_loc3_);
               this.tabView.addEventListener(TabView.TAB_BUTTON_CLICKED,this.handleTabButtonClicked);
               this.tabView.addEventListener(InventoryEvent.CLOSE_DESIGN_MENU,this.handleCloseDesignMenu);
               this.updateTabViewActivation();
               break;
            case ApplicationNotificationNames.UPDATE_UI_AFTER_HANGAR_SLOT_CHANGED:
               this.tabView.resetUI();
               this.updateTabViewActivation();
         }
      }
      
      private function updateTabViewActivation() : void
      {
         if(this.hangarManagerProxy.isHangarFilled())
         {
            this.tabView.reactivateShipTabButton();
         }
         else
         {
            this.tabView.deactivateShipTabButton();
         }
      }
      
      private function handleCloseDesignMenu(param1:InventoryEvent) : void
      {
         sendNotification(ApplicationNotificationNames.CLOSE_SHIP_DESIGN_MENU);
      }
      
      private function handleConfigButtonClicked(param1:MenuEvent) : void
      {
         var _loc2_:int = int(param1.ID);
         var _loc3_:DragComponent = DragComponent.getInstance();
         if(_loc3_.selectedItem != null)
         {
            _loc3_.selectedItem.setDeselected();
            _loc3_.selectedItem = null;
         }
         sendNotification(ApplicationNotificationNames.CONFIG_SWITCHED,_loc2_);
      }
      
      private function handleConfigClearButtonClicked(param1:MenuEvent) : void
      {
         var _loc2_:int = int(param1.ID);
         var _loc3_:PopUpDefiner = new PopUpDefiner();
         _loc3_.popUpType = PopUpDefiner.CLEAR_SHIP_CONFIG_CONFIRMATION_POPUP;
         _loc3_.callback = this.handleConfigClearConfirmationButtonClicked;
         _loc3_.callbackParams = _loc2_;
         _loc3_.cleanUpCallback = null;
         _loc3_.errorMessage = BPLocale.getItem("popup_clear_config_description");
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
         sendNotification(ApplicationNotificationNames.SHOW_POP_UP,_loc3_);
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
      }
      
      public function handleConfigClearConfirmationButtonClicked(param1:int) : void
      {
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
         sendNotification(ApplicationNotificationNames.CLEAR_CURRENT_SHIP_CONFIG,param1);
      }
      
      public function handleHangarSlotButtonClicked(param1:MenuEvent) : void
      {
         sendNotification(ApplicationNotificationNames.HANGAR_SLOT_CHANGED,param1.ID);
      }
      
      private function handleTabButtonClicked(param1:Event) : void
      {
         var _loc2_:DragComponent = DragComponent.getInstance();
         if(_loc2_.selectedItem != null)
         {
            _loc2_.selectedItem.setDeselected();
            _loc2_.selectedItem = null;
         }
         this.selectedTabID = this.tabView.selectedTab;
         sendNotification(ApplicationNotificationNames.TAB_BUTTON_CLICKED,this.selectedTabID);
      }
      
      private function get tabView() : TabView
      {
         return viewComponent as TabView;
      }
   }
}

