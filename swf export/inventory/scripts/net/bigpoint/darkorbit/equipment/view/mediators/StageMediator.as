package net.bigpoint.darkorbit.equipment.view.mediators
{
   import flash.display.DisplayObject;
   import flash.display.Stage;
   import flash.display.StageAlign;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.equipment.application.ApplicationNotificationNames;
   import net.bigpoint.darkorbit.equipment.model.AssetProxy;
   import net.bigpoint.darkorbit.equipment.model.ConnectionProxy;
   import net.bigpoint.darkorbit.equipment.model.LoadDataProxy;
   import net.bigpoint.darkorbit.equipment.model.LoginProxy;
   import net.bigpoint.darkorbit.equipment.model.MenuProxy;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.model.managers.HangarManagerProxy;
   import net.bigpoint.darkorbit.equipment.view.components.AccordionView;
   import net.bigpoint.darkorbit.equipment.view.components.DetailView;
   import net.bigpoint.darkorbit.equipment.view.components.IconURLView;
   import net.bigpoint.darkorbit.equipment.view.components.IconView;
   import net.bigpoint.darkorbit.equipment.view.components.InventoryView;
   import net.bigpoint.darkorbit.equipment.view.components.PopUpView;
   import net.bigpoint.darkorbit.equipment.view.components.SuspendView;
   import net.bigpoint.darkorbit.equipment.view.components.TabView;
   import net.bigpoint.darkorbit.equipment.view.components.items.MultiSelectionComponent;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.TooltipControl;
   import net.bigpoint.darkorbit.equipment.view.managers.FocusManager;
   import org.puremvc.as3.interfaces.IMediator;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.mediator.Mediator;
   
   public class StageMediator extends Mediator implements IMediator
   {
      
      public static const NAME:String = "StageMediator";
      
      private var inventoryViewComponent:InventoryView;
      
      private var tabViewComponent:TabView;
      
      private var suspendView:SuspendView;
      
      private var toolTipView:PopUpView;
      
      public function StageMediator(param1:DisplayObject)
      {
         super(NAME,param1);
         this.stage.align = StageAlign.TOP_LEFT;
         this.stage.addEventListener(MouseEvent.CLICK,this.handleStageMouseDown);
      }
      
      private function handleStageMouseDown(param1:MouseEvent) : void
      {
         var _loc3_:Boolean = false;
         var _loc2_:DisplayObject = FocusManager.getInstance().getFocus() as DisplayObject;
         if(_loc2_)
         {
            _loc3_ = _loc2_.hitTestPoint(param1.stageX,param1.stageY);
            if(!_loc3_)
            {
               FocusManager.getInstance().clearFocus();
            }
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ApplicationNotificationNames.INIT_APPLICATION,ApplicationNotificationNames.INIT_DEBUG_CONFIGURATIONS,ApplicationNotificationNames.MENU_LAYOUT_DEFINED,ApplicationNotificationNames.BP_LOCALE_LOADED,ApplicationNotificationNames.ASSET_CONFIG_DEFINED,ApplicationNotificationNames.BOOTSTRAP_FINISHED,ApplicationNotificationNames.LOG_IN_SUCCESSFUL,ApplicationNotificationNames.ASSETS_LOADED,ApplicationNotificationNames.ACCORDIONS_READY,ApplicationNotificationNames.SHOW_LOAD_SCREEN_ON_INIT,ApplicationNotificationNames.UPDATE_UI_AFTER_HANGAR_SLOT_CHANGED];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:LoadDataProxy = null;
         var _loc3_:ConnectionProxy = null;
         var _loc4_:TooltipControl = null;
         var _loc5_:IconView = null;
         var _loc6_:DetailView = null;
         var _loc7_:IconURLView = null;
         var _loc8_:AccordionView = null;
         var _loc9_:AssetProxy = null;
         var _loc10_:MenuProxy = null;
         var _loc11_:LoginProxy = null;
         var _loc12_:MultiSelectionComponent = null;
         var _loc13_:ConnectionProxy = null;
         switch(param1.getName())
         {
            case ApplicationNotificationNames.INIT_DEBUG_CONFIGURATIONS:
               _loc2_ = facade.retrieveProxy(LoadDataProxy.PROXY_NAME) as LoadDataProxy;
               _loc2_.loadLocalConfig(this.stage);
               break;
            case ApplicationNotificationNames.INIT_APPLICATION:
               _loc4_ = TooltipControl.getInstance();
               _loc4_.setBounds(new Rectangle(0,0,Settings.WINDOW_WIDTH,Settings.WINDOW_HEIGHT - 80));
               _loc5_ = new IconView();
               facade.registerMediator(new IconViewMediator(IconViewMediator.NAME,_loc5_));
               _loc6_ = new DetailView();
               _loc6_.y = IconView.COMPONENT_HEIGHT;
               facade.registerMediator(new DetailViewMediator(DetailViewMediator.NAME,_loc6_));
               _loc7_ = new IconURLView();
               _loc7_.y = IconView.COMPONENT_HEIGHT + DetailView.COMPONENT_HEIGHT;
               facade.registerMediator(new IconURLViewMediator(IconURLViewMediator.NAME,_loc7_));
               _loc8_ = new AccordionView();
               this.stage.addChild(_loc8_);
               facade.registerMediator(new AccordionViewMediator(AccordionViewMediator.NAME,_loc8_));
               this.inventoryViewComponent = new InventoryView();
               this.stage.addChild(this.inventoryViewComponent);
               facade.registerMediator(new InventoryViewMediator(InventoryViewMediator.NAME,this.inventoryViewComponent));
               this.tabViewComponent = new TabView();
               this.stage.addChild(this.tabViewComponent);
               facade.registerMediator(new TabViewMediator(TabViewMediator.NAME,this.tabViewComponent));
               this.tabViewComponent.x = 32;
               this.tabViewComponent.y = 41;
               this.stage.setChildIndex(this.inventoryViewComponent,this.stage.numChildren - 1);
               _loc2_ = facade.retrieveProxy(LoadDataProxy.PROXY_NAME) as LoadDataProxy;
               _loc2_.initBPLocale();
               break;
            case ApplicationNotificationNames.BP_LOCALE_LOADED:
               _loc9_ = facade.retrieveProxy(AssetProxy.PROXY_NAME) as AssetProxy;
               _loc9_.init();
               break;
            case ApplicationNotificationNames.ASSET_CONFIG_DEFINED:
               _loc10_ = facade.retrieveProxy(MenuProxy.PROXY_NAME) as MenuProxy;
               _loc10_.loadMenuLayoutXML();
               break;
            case ApplicationNotificationNames.MENU_LAYOUT_DEFINED:
               _loc2_ = facade.retrieveProxy(LoadDataProxy.PROXY_NAME) as LoadDataProxy;
               _loc2_.loadAssets();
               break;
            case ApplicationNotificationNames.SHOW_LOAD_SCREEN_ON_INIT:
               this.suspendView = new SuspendView();
               facade.registerMediator(new SuspendMediator(SuspendMediator.NAME,this.suspendView));
               this.stage.addChild(this.suspendView);
               this.stage.setChildIndex(this.suspendView,this.stage.numChildren - 1);
               sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.CLIENT_INITIALISING]);
               break;
            case ApplicationNotificationNames.ASSETS_LOADED:
               this.toolTipView = new PopUpView();
               facade.registerMediator(new PopUpViewMediator(PopUpViewMediator.NAME,this.toolTipView));
               this.stage.addChild(this.toolTipView);
               this.stage.setChildIndex(this.toolTipView,this.stage.numChildren - 1);
               _loc11_ = facade.retrieveProxy(LoginProxy.PROXY_NAME) as LoginProxy;
               _loc11_.beginLogin();
               break;
            case ApplicationNotificationNames.LOG_IN_SUCCESSFUL:
               _loc3_ = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
               _loc3_.beginConnection();
               break;
            case ApplicationNotificationNames.BOOTSTRAP_FINISHED:
               _loc12_ = MultiSelectionComponent.getInstance();
               this.stage.addChild(_loc12_);
               _loc12_.addListeners();
               this.checkMultiSelectorActivation();
               break;
            case ApplicationNotificationNames.ACCORDIONS_READY:
               _loc13_ = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
               _loc13_.accordionsReadyBeginFullInit();
               break;
            case ApplicationNotificationNames.UPDATE_UI_AFTER_HANGAR_SLOT_CHANGED:
         }
      }
      
      private function checkMultiSelectorActivation() : void
      {
         var _loc1_:HangarManagerProxy = facade.retrieveProxy(HangarManagerProxy.PROXY_NAME) as HangarManagerProxy;
         var _loc2_:MultiSelectionComponent = MultiSelectionComponent.getInstance();
         if(_loc1_.isHangarEmpty())
         {
            _loc2_.disable();
         }
         else
         {
            _loc2_.enable();
         }
      }
      
      protected function get stage() : Stage
      {
         return viewComponent as Stage;
      }
   }
}

