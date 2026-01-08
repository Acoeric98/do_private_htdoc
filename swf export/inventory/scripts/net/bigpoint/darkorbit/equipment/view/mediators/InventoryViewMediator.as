package net.bigpoint.darkorbit.equipment.view.mediators
{
   import com.greensock.TweenMax;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.equipment.application.ApplicationNotificationNames;
   import net.bigpoint.darkorbit.equipment.events.ActionIdentifiers;
   import net.bigpoint.darkorbit.equipment.events.InventoryEvent;
   import net.bigpoint.darkorbit.equipment.events.ItemEvent;
   import net.bigpoint.darkorbit.equipment.events.MoveItemEvent;
   import net.bigpoint.darkorbit.equipment.model.ConnectionProxy;
   import net.bigpoint.darkorbit.equipment.model.MenuProxy;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.model.VO.AccordionViewEntity;
   import net.bigpoint.darkorbit.equipment.model.VO.Config;
   import net.bigpoint.darkorbit.equipment.model.VO.Equipment;
   import net.bigpoint.darkorbit.equipment.model.VO.Inventory;
   import net.bigpoint.darkorbit.equipment.model.VO.Ship;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInfoVO;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInstanceVO;
   import net.bigpoint.darkorbit.equipment.model.VO.slot.SlotItemVO;
   import net.bigpoint.darkorbit.equipment.model.VO.slot.SlotSetVO;
   import net.bigpoint.darkorbit.equipment.model.managers.ConfigManager;
   import net.bigpoint.darkorbit.equipment.model.managers.FilterManager;
   import net.bigpoint.darkorbit.equipment.model.managers.HangarManagerProxy;
   import net.bigpoint.darkorbit.equipment.model.managers.ItemInfoManager;
   import net.bigpoint.darkorbit.equipment.model.transporter.PopUpDefiner;
   import net.bigpoint.darkorbit.equipment.view.components.InventoryView;
   import net.bigpoint.darkorbit.equipment.view.components.SuspendView;
   import net.bigpoint.darkorbit.equipment.view.components.items.DragComponent;
   import net.bigpoint.darkorbit.equipment.view.components.items.GridComponent;
   import net.bigpoint.darkorbit.equipment.view.components.items.InventoryItemComponent;
   import net.bigpoint.darkorbit.equipment.view.components.items.ItemFilter;
   import net.bigpoint.darkorbit.equipment.view.components.items.MultiSelectionComponent;
   import net.bigpoint.utils.PredefinedFilters;
   import org.puremvc.as3.interfaces.IMediator;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.mediator.Mediator;
   
   public class InventoryViewMediator extends Mediator implements IMediator
   {
      
      public static const NAME:String = "InventoryViewMediator";
      
      public var inventoryOnStage:Boolean = true;
      
      private var hangarManagerProxy:HangarManagerProxy;
      
      private var connectionProxy:ConnectionProxy;
      
      private var menuProxy:MenuProxy;
      
      public function InventoryViewMediator(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ApplicationNotificationNames.MENU_LAYOUT_DEFINED,ApplicationNotificationNames.INIT_INVENTORY,ApplicationNotificationNames.MOVE_TO_INVENTORY,ApplicationNotificationNames.KEEP_IN_INVENTORY,ApplicationNotificationNames.INVENTORY_REARRANGE,ApplicationNotificationNames.MAKE_EMPTY_IN_INVENTORY,ApplicationNotificationNames.UPDATE_UNIQUE_ITEM,ApplicationNotificationNames.ADD_NEW_ITEM,ApplicationNotificationNames.DELETE_ITEM,ApplicationNotificationNames.CHANGE_CONFIG,ApplicationNotificationNames.DELIVER_SELECTED_ITEM_INFO,ApplicationNotificationNames.CLEAR_ITEM_INFO,ApplicationNotificationNames.FILTER_INVENTORY_BY_CONTEXT,ApplicationNotificationNames.RETURN_ITEM_SALE_VALUE,ApplicationNotificationNames.RETURN_ITEM_BUY_COST,ApplicationNotificationNames.RETURN_CPU_TYPE,ApplicationNotificationNames.CHANGE_CONTEXT_BUTTON,ApplicationNotificationNames.CLOSE_SHIP_DESIGN_MENU,ApplicationNotificationNames.TAB_BUTTON_CLICKED,ApplicationNotificationNames.UPDATE_UI_AFTER_HANGAR_SLOT_CHANGED,ApplicationNotificationNames
         .ACCORDION_VIEW_ENTITY_SELECTION_CHANGED,ApplicationNotificationNames.UPDATE_UI_AFTER_CONFIGURATION_CLEARED,ApplicationNotificationNames.UPDATE_UI_AFTER_SHIP_DESIGN_CHANGED,ApplicationNotificationNames.KILL_DRONE,ApplicationNotificationNames.INVENTORY_UPDATE_ACTIONBUTTONS,ApplicationNotificationNames.INVENTORY_UPDATE_REPAIRED_MODULE];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:Object = null;
         var _loc9_:ItemInstanceVO = null;
         var _loc10_:ItemInstanceVO = null;
         var _loc11_:ItemInstanceVO = null;
         var _loc12_:Array = null;
         var _loc13_:Dictionary = null;
         var _loc14_:Boolean = false;
         var _loc15_:String = null;
         var _loc16_:Object = null;
         var _loc17_:Object = null;
         var _loc18_:Object = null;
         var _loc19_:String = null;
         var _loc20_:AccordionViewEntity = null;
         var _loc2_:FilterManager = FilterManager.getInstance();
         this.menuProxy = facade.retrieveProxy(MenuProxy.PROXY_NAME) as MenuProxy;
         this.connectionProxy = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
         this.hangarManagerProxy = facade.retrieveProxy(HangarManagerProxy.PROXY_NAME) as HangarManagerProxy;
         switch(param1.getName())
         {
            case ApplicationNotificationNames.MENU_LAYOUT_DEFINED:
               this.inventoryView.sectionList = this.menuProxy.invSection;
               break;
            case ApplicationNotificationNames.INIT_INVENTORY:
               this.inventoryView.injectHangarManager(this.hangarManagerProxy);
               this.rebuildUIElements();
               this.initializeDragComponent();
               this.addAllEventListenersToInventoryView();
               break;
            case ApplicationNotificationNames.UPDATE_UI_AFTER_HANGAR_SLOT_CHANGED:
               this.rebuildUIElements();
               break;
            case ApplicationNotificationNames.CHANGE_CONFIG:
               this.inventoryView.refreshView();
               break;
            case ApplicationNotificationNames.UPDATE_UI_AFTER_CONFIGURATION_CLEARED:
            case ApplicationNotificationNames.MOVE_TO_INVENTORY:
               _loc3_ = param1.getBody() as Array;
               this.inventoryView.addAllMovedItems(_loc3_);
               break;
            case ApplicationNotificationNames.UPDATE_UI_AFTER_SHIP_DESIGN_CHANGED:
               this.rebuildDesignListCombobox();
               break;
            case ApplicationNotificationNames.FILTER_INVENTORY_BY_CONTEXT:
               _loc4_ = param1.getBody() as Array;
               _loc5_ = _loc4_[0];
               if(_loc5_)
               {
                  this.inventoryView.filterByContext(_loc5_);
               }
               break;
            case ApplicationNotificationNames.KEEP_IN_INVENTORY:
               _loc6_ = param1.getBody() as Array;
               this.inventoryView.replaceItemsThatAlreadyExist();
               break;
            case ApplicationNotificationNames.MAKE_EMPTY_IN_INVENTORY:
               _loc7_ = param1.getBody() as Array;
               this.inventoryView.setItemsEquippedToConfig(_loc7_);
               break;
            case ApplicationNotificationNames.INVENTORY_REARRANGE:
               _loc8_ = param1.getBody() as Object;
               if(_loc8_ != null)
               {
                  this.inventoryView.swapInventoryItems(new Array(_loc8_.from.items[0],_loc8_.to.index));
               }
               break;
            case ApplicationNotificationNames.UPDATE_UNIQUE_ITEM:
               _loc9_ = param1.getBody() as ItemInstanceVO;
               this.inventoryView.updateUniqueItem(_loc9_);
               break;
            case ApplicationNotificationNames.ADD_NEW_ITEM:
               _loc10_ = param1.getBody() as ItemInstanceVO;
               this.inventoryView.addNewItem(new Array(_loc10_));
               break;
            case ApplicationNotificationNames.DELETE_ITEM:
               _loc11_ = param1.getBody() as ItemInstanceVO;
               this.inventoryView.deleteItem(_loc11_.ID);
               this.inventoryView.disableAllInventoryButtons();
               break;
            case ApplicationNotificationNames.KILL_DRONE:
               this.inventoryView.disableAllInventoryButtons();
               break;
            case ApplicationNotificationNames.DELIVER_SELECTED_ITEM_INFO:
               _loc12_ = param1.getBody() as Array;
               _loc13_ = _loc12_[0];
               _loc14_ = Boolean(_loc12_[1]);
               this.inventoryView.updateSelectedItemTextFields(_loc13_,_loc14_);
               break;
            case ApplicationNotificationNames.CLEAR_ITEM_INFO:
               this.inventoryView.clearItemTextFields();
               break;
            case ApplicationNotificationNames.INVENTORY_UPDATE_ACTIONBUTTONS:
               this.inventoryView.updateActionButtonStatus();
               break;
            case ApplicationNotificationNames.INVENTORY_UPDATE_REPAIRED_MODULE:
               _loc15_ = param1.getBody() as String;
               this.inventoryView.updateRepairedBattlestationModule(_loc15_);
               break;
            case ApplicationNotificationNames.RETURN_ITEM_SALE_VALUE:
               _loc16_ = param1.getBody() as Object;
               this.displaySellingWindow(_loc16_);
               break;
            case ApplicationNotificationNames.RETURN_ITEM_BUY_COST:
               _loc17_ = param1.getBody() as Object;
               this.displayQuickBuyPopUp(_loc17_);
               break;
            case ApplicationNotificationNames.RETURN_CPU_TYPE:
               _loc18_ = param1.getBody() as Object;
               this.displayCPUChoicePopUp(_loc18_);
               break;
            case ApplicationNotificationNames.CHANGE_CONTEXT_BUTTON:
               _loc19_ = param1.getBody() as String;
               this.inventoryView.updateContextUseBtn(_loc19_);
               break;
            case ApplicationNotificationNames.CLOSE_SHIP_DESIGN_MENU:
               this.inventoryView.closeDesignsMenu();
               this.inventoryView.disableAllInventoryButtons();
               break;
            case ApplicationNotificationNames.TAB_BUTTON_CLICKED:
               this.inventoryView.disableAllInventoryButtons();
               break;
            case ApplicationNotificationNames.ACCORDION_VIEW_ENTITY_SELECTION_CHANGED:
               _loc20_ = param1.getBody() as AccordionViewEntity;
               this.inventoryView.updateFromAccordionViewEntitySelectionChanged(_loc20_);
         }
      }
      
      private function rebuildUIElements() : void
      {
         var _loc1_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
         var _loc2_:FilterManager = FilterManager.getInstance();
         var _loc3_:Inventory = _loc1_.inventory;
         this.inventoryView.removeInventoryVisibleComponents();
         this.inventoryView.populateWithIcons(_loc3_);
         this.inventoryView.createGridFilteringMenus(_loc2_.filters);
         this.inventoryView.createButtons();
         this.rebuildDesignListCombobox();
         _loc1_.updateCurrentEquipmentTab(ActionIdentifiers.SHIP);
         var _loc4_:Boolean = this.hangarManagerProxy.isHangarFilled();
         if(_loc4_)
         {
            this.inventoryView.filters = [];
            this.inventoryView.mouseEnabled = true;
            this.inventoryView.mouseChildren = true;
            TweenMax.to(this.inventoryView,0.5,PredefinedFilters.TWEENMAX_COLORMATRIX_COLORED);
         }
         else
         {
            this.inventoryView.deactivateSellShipOrPetButton();
         }
      }
      
      private function rebuildDesignListCombobox() : void
      {
         var _loc10_:String = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:ItemInfoVO = null;
         var _loc1_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
         var _loc2_:Ship = _loc1_.equipmentManager.ship;
         var _loc3_:String = _loc2_.getShipType();
         var _loc4_:Object = this.hangarManagerProxy.getAllFreeAndAssignedDesignsForType(_loc3_);
         var _loc5_:Dictionary = new Dictionary();
         var _loc6_:Array = _loc4_.freeDesigns;
         var _loc7_:int = int(_loc6_.length);
         if(_loc7_ == 0)
         {
            _loc12_ = _loc2_.selectedDesign;
            if(_loc12_ != _loc3_ && _loc3_ != null)
            {
               _loc6_.push(_loc3_);
               _loc7_ = int(_loc6_.length);
            }
         }
         var _loc8_:ItemInfoManager = ItemInfoManager.getInstance();
         var _loc9_:int = 0;
         while(_loc9_ < _loc7_)
         {
            _loc13_ = _loc6_[_loc9_];
            _loc14_ = _loc8_.getItemInfo(_loc13_);
            _loc5_[_loc14_.name] = _loc13_;
            _loc9_++;
         }
         var _loc11_:ItemInfoVO = ItemInfoManager.getInstance().getItemInfo(_loc1_.equipmentManager.ship.selectedDesign);
         if(_loc11_)
         {
            _loc10_ = _loc11_.name.toUpperCase();
         }
         else
         {
            _loc10_ = "";
         }
         this.inventoryView.createDesignSelectionMenu(_loc10_,_loc5_);
      }
      
      private function initializeDragComponent() : void
      {
         var _loc1_:DragComponent = DragComponent.getInstance();
         _loc1_.addEventListener(MoveItemEvent.ITEMS_MOVED_TO_INVENTORY,this.attemptedItemMoveToInventory);
         _loc1_.addEventListener(MoveItemEvent.ITEM_REARRANGED_WITHIN_INVENTORY,this.attemptedInventoryRearrange);
         _loc1_.addEventListener(MoveItemEvent.STACK_MOVED_TO_EMPTY_SLOT,this.attemptedToMoveStackToEmptySlot);
         _loc1_.addEventListener(ItemEvent.ITEM_SELECTED,this.handleInventoryItemSelected);
         _loc1_.addEventListener(InventoryEvent.BUYABLE_SLOT_CLICKED,this.handleBuyableSlotClicked);
         _loc1_.addEventListener(InventoryEvent.CHECK_INVENTORY_CONTEXT_BUTTON,this.handleCheckInventoryContextButton);
         _loc1_.addEventListener(InventoryEvent.UPDATE_SELL_BUTTON,this.updateSellButton);
         _loc1_.addEventListener(ItemEvent.ITEM_MULTISELECTED,this.handleInventoryItemMultiselected);
      }
      
      private function addAllEventListenersToInventoryView() : void
      {
         this.inventoryView.addEventListener(MoveItemEvent.SELL_ITEM,this.attemptedToSellItem);
         this.inventoryView.addEventListener(MoveItemEvent.SELL_SHIP_OR_PET,this.attemptedToSellShipOrPet);
         this.inventoryView.addEventListener(MoveItemEvent.QUICK_BUY_ITEM,this.attemptedToQuickBuyItem);
         this.inventoryView.addEventListener(InventoryEvent.INVENTORY_SWITCHED,this.handleInventoryModeSwitched);
         this.inventoryView.addEventListener(InventoryEvent.DESIGN_MENU_CLICK,this.handleDesignButtonClicked);
         this.inventoryView.addEventListener(InventoryEvent.REPAIR_BUTTON_CLICKED,this.handleRepairButtonClicked);
         this.inventoryView.addEventListener(InventoryEvent.CHANGE_CPU_MODE_BUTTON_CLICKED,this.handleChangeCPUModeButtonClicked);
         this.inventoryView.addEventListener(InventoryEvent.CLOSE_DESIGN_MENU,this.handleCloseDesignNotification);
      }
      
      private function handleCloseDesignNotification(param1:InventoryEvent) : void
      {
         sendNotification(ApplicationNotificationNames.CLOSE_SHIP_DESIGN_MENU);
      }
      
      private function updateSellButton(param1:InventoryEvent) : void
      {
         sendNotification(ApplicationNotificationNames.ACCORDION_VIEW_ENTITY_CLEAR_SELECTION);
         this.inventoryView.updateActionButtonStatus();
      }
      
      private function handleCheckInventoryContextButton(param1:InventoryEvent) : void
      {
         sendNotification(ApplicationNotificationNames.CHECK_CONTEXT_BUTTON);
      }
      
      private function handleChangeCPUModeButtonClicked(param1:InventoryEvent) : void
      {
         var _loc2_:DragComponent = DragComponent.getInstance();
         sendNotification(ApplicationNotificationNames.GET_CPU_TYPE,_loc2_.selectedItem.itemID);
      }
      
      private function displayCPUChoicePopUp(param1:Object) : void
      {
         var _loc2_:PopUpDefiner = new PopUpDefiner();
         _loc2_.popUpType = PopUpDefiner.AMMO_CPU_CHOICE;
         _loc2_.transporter = param1;
         _loc2_.callback = this.askServerForChangeCPUMode;
         _loc2_.cleanUpCallback = this.removeSuspendView;
         sendNotification(ApplicationNotificationNames.SHOW_POP_UP,_loc2_);
      }
      
      public function askServerForChangeCPUMode(param1:MoveItemEvent) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.itemId = param1.transporter.itemId;
         _loc2_.action = param1.transporter.action;
         _loc2_.ammo = param1.transporter.ammo;
         sendNotification(ApplicationNotificationNames.QUERY_SERVER_FOR_CPU_MODE_CHANGE,_loc2_);
      }
      
      private function handleDesignButtonClicked(param1:InventoryEvent) : void
      {
         sendNotification(ApplicationNotificationNames.CHANGE_SELECTED_DESIGN,param1.info);
      }
      
      private function handleBuyableSlotClicked(param1:InventoryEvent) : void
      {
         var _loc2_:PopUpDefiner = new PopUpDefiner();
         _loc2_.popUpType = PopUpDefiner.BUYABLE_SLOT_POPUP;
         _loc2_.transporter = param1.info;
         _loc2_.callback = this.attemptedToBuyExtraPetSlot;
         _loc2_.cleanUpCallback = this.removeSuspendView;
         sendNotification(ApplicationNotificationNames.SHOW_POP_UP,_loc2_);
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
      }
      
      private function handleRepairButtonClicked(param1:InventoryEvent) : void
      {
         var _loc2_:PopUpDefiner = new PopUpDefiner();
         var _loc3_:Object = param1.info;
         var _loc4_:String = _loc3_.action;
         switch(_loc4_)
         {
            case ActionIdentifiers.REPAIR_DRONE:
               _loc2_.popUpType = PopUpDefiner.REPAIR_ITEM_POPUP;
               _loc2_.transporter = _loc3_;
               _loc2_.callback = this.attemptedToRepairItem;
               _loc2_.cleanUpCallback = this.removeSuspendView;
               sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
               sendNotification(ApplicationNotificationNames.SHOW_POP_UP,_loc2_);
               break;
            case ActionIdentifiers.REPAIR_MODULE:
               _loc2_.popUpType = PopUpDefiner.REPAIR_MODULE_POPUP;
               _loc2_.transporter = _loc3_;
               _loc2_.callback = this.attemptedToRepairModule;
               _loc2_.cleanUpCallback = this.removeSuspendView;
               sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
               sendNotification(ApplicationNotificationNames.SHOW_POP_UP,_loc2_);
         }
      }
      
      private function attemptedToRepairItem(param1:MoveItemEvent) : void
      {
         sendNotification(ApplicationNotificationNames.QUERY_REPAIR_ITEM,param1.transporter);
      }
      
      private function attemptedToRepairModule(param1:MoveItemEvent) : void
      {
         sendNotification(ApplicationNotificationNames.QUERY_REPAIR_MODULE,param1.transporter);
      }
      
      private function attemptedToBuyExtraPetSlot(param1:MoveItemEvent) : void
      {
         sendNotification(ApplicationNotificationNames.QUERY_BUY_EXTRA_PET_SLOT,param1.transporter);
      }
      
      private function handleInventoryModeSwitched(param1:InventoryEvent) : void
      {
         if(this.inventoryOnStage)
         {
            sendNotification(ApplicationNotificationNames.REMOVE_ACCORDION_VIEW);
            this.inventoryOnStage = false;
         }
         else
         {
            sendNotification(ApplicationNotificationNames.ADD_ACCORDION_VIEW);
            this.inventoryOnStage = true;
         }
      }
      
      private function handleInventoryItemSelected(param1:ItemEvent) : void
      {
         sendNotification(ApplicationNotificationNames.FIND_SELECTED_ITEM_INFO,param1.ID);
      }
      
      private function handleInventoryItemMultiselected(param1:ItemEvent) : void
      {
         var _loc11_:Config = null;
         var _loc12_:int = 0;
         var _loc13_:String = null;
         var _loc14_:Equipment = null;
         var _loc15_:SlotSetVO = null;
         var _loc16_:int = 0;
         var _loc17_:SlotItemVO = null;
         var _loc18_:GridComponent = null;
         var _loc19_:Array = null;
         var _loc20_:int = 0;
         var _loc21_:InventoryItemComponent = null;
         var _loc2_:DragComponent = DragComponent.getInstance();
         var _loc3_:MultiSelectionComponent = MultiSelectionComponent.getInstance();
         var _loc4_:GridComponent = _loc2_.currentSelectedItem.parent as GridComponent;
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         var _loc7_:Array = [];
         var _loc8_:Array = MultiSelectionComponent.getInstance().allGrids;
         var _loc9_:Dictionary = ConfigManager.getInstance().configs;
         var _loc10_:int = 1;
         for each(_loc11_ in _loc9_)
         {
            for(_loc13_ in _loc11_.equipments)
            {
               _loc14_ = _loc11_.equipments[_loc13_];
               for each(_loc15_ in _loc14_.slotSets)
               {
                  _loc16_ = 0;
                  while(_loc16_ < _loc15_.items.length)
                  {
                     _loc17_ = _loc15_.items[_loc16_];
                     if(_loc10_ == 1)
                     {
                        _loc6_.push(_loc17_.itemInstance.ID);
                     }
                     else
                     {
                        _loc7_.push(_loc17_.itemInstance.ID);
                     }
                     _loc16_++;
                  }
               }
            }
            _loc10_++;
         }
         _loc12_ = 0;
         while(_loc12_ < _loc8_.length)
         {
            _loc18_ = _loc8_[_loc12_];
            _loc19_ = _loc18_.iconsInThisMenu;
            _loc20_ = 0;
            while(_loc20_ < _loc19_.length)
            {
               _loc21_ = _loc19_[_loc20_];
               if(_loc4_.parent is InventoryView)
               {
                  if(param1.itemName == _loc21_.itemName && _loc3_.stage.contains(_loc21_) && _loc21_.canBeSelected && _loc21_.group != ItemFilter.EMPTY_SPACE_FILTER && !_loc21_.buyableExtraSlot)
                  {
                     if(Settings.activeConfig == 1 && this.containsNotItem(parseInt(_loc21_.itemID),_loc6_) || Settings.activeConfig == 2 && this.containsNotItem(parseInt(_loc21_.itemID),_loc7_))
                     {
                        if(this.containsNotItem(parseInt(_loc21_.itemID),_loc5_))
                        {
                           _loc5_.push(_loc21_);
                           _loc21_.setSelected();
                        }
                     }
                  }
               }
               else if(_loc18_.containsIconInThisMenu(param1.ID) && param1.itemName == _loc21_.itemName && _loc3_.stage.contains(_loc21_) && _loc21_.canBeSelected && _loc21_.group != ItemFilter.EMPTY_SPACE_FILTER && !_loc21_.buyableExtraSlot)
               {
                  if(Settings.activeConfig == 1 && !this.containsNotItem(parseInt(_loc21_.itemID),_loc6_) || Settings.activeConfig == 2 && !this.containsNotItem(parseInt(_loc21_.itemID),_loc7_))
                  {
                     if(this.containsNotItem(parseInt(_loc21_.itemID),_loc5_))
                     {
                        _loc5_.push(_loc21_);
                        _loc21_.setSelected();
                     }
                  }
               }
               _loc20_++;
            }
            _loc12_++;
         }
         _loc2_.multiSelection = [];
         _loc2_.multiSelection = _loc5_;
      }
      
      private function containsNotItem(param1:int, param2:Array) : Boolean
      {
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            if(param2[_loc3_] == param1)
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      private function attemptedToMoveStackToEmptySlot(param1:MoveItemEvent) : void
      {
         var _loc2_:PopUpDefiner = new PopUpDefiner();
         _loc2_.popUpType = PopUpDefiner.SPLIT_STACK_POPUP;
         _loc2_.transporter = param1.transporter;
         _loc2_.callback = this.attemptedInventoryItemSplit;
         _loc2_.cleanUpCallback = this.removeSuspendView;
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
         sendNotification(ApplicationNotificationNames.SHOW_POP_UP,_loc2_);
      }
      
      private function attemptedToQuickBuyItem(param1:MoveItemEvent) : void
      {
         sendNotification(ApplicationNotificationNames.GET_ITEM_COST,param1.transporter);
      }
      
      private function displayQuickBuyPopUp(param1:Object) : void
      {
         var _loc2_:PopUpDefiner = new PopUpDefiner();
         _loc2_.popUpType = PopUpDefiner.QUICK_BUY_ITEM;
         _loc2_.transporter = param1;
         _loc2_.callback = this.sendQuickBuyToServer;
         _loc2_.cleanUpCallback = this.removeSuspendView;
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
         sendNotification(ApplicationNotificationNames.SHOW_POP_UP,_loc2_);
      }
      
      private function sendQuickBuyToServer(param1:MoveItemEvent) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.quantity = param1.transporter.chosenQuantity;
         _loc2_.itemId = param1.transporter.itemId;
         _loc2_.action = param1.transporter.action;
         sendNotification(ApplicationNotificationNames.QUERY_FOR_QUICK_BUY_ITEM,_loc2_);
      }
      
      private function attemptedToSellItem(param1:MoveItemEvent) : void
      {
         if(param1.transporter.quantity > 1 || param1.transporter.quantity == 1)
         {
            sendNotification(ApplicationNotificationNames.GET_ITEM_SALE_VALUE,param1.transporter);
            return;
         }
         this.sellAmountCallback(param1,false);
      }
      
      private function attemptedToSellShipOrPet(param1:MoveItemEvent) : void
      {
         sendNotification(ApplicationNotificationNames.ACCORDION_VIEW_ENTITY_CLEAR_SELECTION);
         this.displaySellShipWindow(param1.transporter);
      }
      
      private function displaySellShipWindow(param1:Object) : void
      {
         var _loc2_:PopUpDefiner = new PopUpDefiner();
         _loc2_.popUpType = PopUpDefiner.SELL_SHIP_POPUP;
         _loc2_.transporter = param1;
         _loc2_.callback = this.sellShipConfirmationCallback;
         _loc2_.callbackParams = param1;
         _loc2_.cleanUpCallback = this.removeSuspendView;
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
         sendNotification(ApplicationNotificationNames.SHOW_POP_UP,_loc2_);
      }
      
      private function sellShipConfirmationCallback(param1:Object) : void
      {
         sendNotification(ApplicationNotificationNames.QUERY_FOR_SELLING_SHIP,param1);
      }
      
      private function displaySellingWindow(param1:Object) : void
      {
         var _loc2_:PopUpDefiner = new PopUpDefiner();
         _loc2_.popUpType = PopUpDefiner.SELL_POPUP;
         _loc2_.transporter = param1;
         _loc2_.callback = this.sellAmountCallback;
         _loc2_.cleanUpCallback = this.removeSuspendView;
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
         sendNotification(ApplicationNotificationNames.SHOW_POP_UP,_loc2_);
      }
      
      public function removeSuspendView() : void
      {
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
      }
      
      private function sellAmountCallback(param1:MoveItemEvent, param2:Boolean = true) : void
      {
         var _loc3_:Object = null;
         if(param2)
         {
            _loc3_ = new Object();
            _loc3_.quantity = param1.transporter.chosenQuantity;
            _loc3_.itemId = param1.transporter.itemId;
            _loc3_.action = param1.transporter.action;
            sendNotification(ApplicationNotificationNames.QUERY_FOR_SELLING_ITEM,_loc3_);
         }
         else
         {
            sendNotification(ApplicationNotificationNames.QUERY_FOR_SELLING_ITEM,param1.transporter);
         }
      }
      
      private function attemptedInventoryItemSplit(param1:MoveItemEvent) : void
      {
         var _loc2_:Object = new Object();
         if(param1.transporter.chosenQuantity == param1.transporter.quantity)
         {
            _loc2_.action = ActionIdentifiers.MOVE;
            _loc2_.to = param1.transporter.to;
            _loc2_.from = param1.transporter.from;
            sendNotification(ApplicationNotificationNames.QUERY_INVENTORY_ITEMS_REARRANGED,_loc2_);
         }
         else
         {
            _loc2_.action = ActionIdentifiers.SPLIT;
            _loc2_.itemId = param1.transporter.from.items[0];
            _loc2_.quantity = param1.transporter.chosenQuantity;
            _loc2_.index = param1.transporter.to.index;
            sendNotification(ApplicationNotificationNames.QUERY_INVENTORY_ITEM_SPLIT,_loc2_);
         }
      }
      
      private function attemptedInventoryRearrange(param1:MoveItemEvent) : void
      {
         sendNotification(ApplicationNotificationNames.QUERY_INVENTORY_ITEMS_REARRANGED,param1.transporter);
      }
      
      private function attemptedItemMoveToInventory(param1:MoveItemEvent) : void
      {
         sendNotification(ApplicationNotificationNames.QUERY_ITEMS_MOVED_TO_INVENTORY,param1.transporter);
      }
      
      private function handleInventoryReady(param1:Event) : void
      {
         sendNotification(ApplicationNotificationNames.INVENTORY_READY);
      }
      
      private function get inventoryView() : InventoryView
      {
         return viewComponent as InventoryView;
      }
   }
}

