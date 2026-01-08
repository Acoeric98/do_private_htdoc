package net.bigpoint.darkorbit.equipment.view.components
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Quart;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.events.ActionIdentifiers;
   import net.bigpoint.darkorbit.equipment.events.GridEvent;
   import net.bigpoint.darkorbit.equipment.events.InventoryEvent;
   import net.bigpoint.darkorbit.equipment.events.MoveItemEvent;
   import net.bigpoint.darkorbit.equipment.model.AssetProxy;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.model.UILayoutProxy;
   import net.bigpoint.darkorbit.equipment.model.VO.AccordionViewEntity;
   import net.bigpoint.darkorbit.equipment.model.VO.Drone;
   import net.bigpoint.darkorbit.equipment.model.VO.HangarSlotEntity;
   import net.bigpoint.darkorbit.equipment.model.VO.Inventory;
   import net.bigpoint.darkorbit.equipment.model.VO.Ship;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInfoVO;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInstanceVO;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemLocalisationKeys;
   import net.bigpoint.darkorbit.equipment.model.managers.EquipmentManager;
   import net.bigpoint.darkorbit.equipment.model.managers.ExternalInterfaceManager;
   import net.bigpoint.darkorbit.equipment.model.managers.HangarManagerProxy;
   import net.bigpoint.darkorbit.equipment.model.managers.ItemInfoManager;
   import net.bigpoint.darkorbit.equipment.view.Styles;
   import net.bigpoint.darkorbit.equipment.view.components.buttons.DropDownButton;
   import net.bigpoint.darkorbit.equipment.view.components.buttons.GenericButton;
   import net.bigpoint.darkorbit.equipment.view.components.buttons.InventoryButton;
   import net.bigpoint.darkorbit.equipment.view.components.interfaces.IMenuView;
   import net.bigpoint.darkorbit.equipment.view.components.items.AccordionButtonComponent;
   import net.bigpoint.darkorbit.equipment.view.components.items.DragComponent;
   import net.bigpoint.darkorbit.equipment.view.components.items.GridComponent;
   import net.bigpoint.darkorbit.equipment.view.components.items.InventoryItemComponent;
   import net.bigpoint.darkorbit.equipment.view.components.items.InventoryLargeItemComponent;
   import net.bigpoint.darkorbit.equipment.view.components.items.ItemFilter;
   import net.bigpoint.darkorbit.equipment.view.components.items.ItemInfoField;
   import net.bigpoint.darkorbit.equipment.view.components.items.MenuSection;
   import net.bigpoint.darkorbit.equipment.view.components.menus.DropDownMenu;
   import net.bigpoint.darkorbit.equipment.view.components.scroller.ScrollBar;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.TooltipControl;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.preparation.AbstractTooltipPreparer;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.preparation.ITooltipPreparer;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.preparation.TooltipPreparerFactory;
   import net.bigpoint.darkorbit.equipment.view.managers.FocusManager;
   import net.bigpoint.utils.DisplayObjectHelper;
   import net.bigpoint.utils.TextFormatter;
   
   public class InventoryView extends Sprite implements IMenuView
   {
      
      public static const INVENTORY_TWEEN_SPEED:Number = 0.5;
      
      private static const TWEEN_SPEED:Number = 0.3;
      
      public static const FULL_MODE_INVENTORY:int = 0;
      
      public static const MINI_MODE_INVENTORY:int = 1;
      
      public static const INVENTORY_READY:String = "INVENTORY_READY";
      
      private static const INVENTORY_Y:Number = 69;
      
      private static const INVENTORY_X:Number = Settings.WINDOW_WIDTH - 156;
      
      public var currentInventoryState:int;
      
      public var currentContextFilterGroup:Array;
      
      private var hangarManager:HangarManagerProxy;
      
      private var currentContextBtnContext:String;
      
      public var sectionList:MenuSection;
      
      private var viewID:String = "inventory";
      
      private var backgroundSprite:Sprite;
      
      private var blueSprite:Sprite;
      
      private var maskSprite:Sprite;
      
      private var grid:GridComponent;
      
      private var dragComp:DragComponent;
      
      private var inventoryOpenBtn:GenericButton;
      
      private var inventoryCloseBtn:GenericButton;
      
      private var inventoryScroller:ScrollBar;
      
      private var itemFiltersMenu:DropDownMenu;
      
      private var hangarFiltersMenu:DropDownMenu;
      
      private var designSelectionMenu:DropDownMenu;
      
      private var actionsMenu:Sprite = new Sprite();
      
      private var backgroundTopBarSprite:Sprite;
      
      private var inventoryBtnsBg:MovieClip;
      
      private var itemDescriptionField:ItemInfoField;
      
      private var itemDetailsField:ItemInfoField;
      
      private var largeItemGraphic:InventoryLargeItemComponent;
      
      private var contextUseBtn:InventoryButton;
      
      private var toolTipControl:TooltipControl;
      
      private var sellBtn:InventoryButton;
      
      private var sellShipOrPetBtn:InventoryButton;
      
      private var quickBuyBtn:InventoryButton;
      
      private var moduleUpgradeBtn:InventoryButton;
      
      private var currentHangarSlotEntityAsFilter:HangarSlotEntity;
      
      private var inventoryTabButton:Sprite;
      
      private var inventoryTabButtonTextField:TextField;
      
      public function InventoryView()
      {
         super();
         if(this.dragComp == null)
         {
            this.dragComp = DragComponent.getInstance();
         }
         this.toolTipControl = TooltipControl.getInstance();
      }
      
      public function injectHangarManager(param1:HangarManagerProxy) : void
      {
         this.hangarManager = param1;
      }
      
      public function buildInventory(param1:int) : void
      {
         this.createBackground();
         this.createInventoryButtons();
         this.populateInventoryScreens(param1);
         this.createInventoryMask();
         stage.addChild(this.dragComp);
         this.dragComp.addCollisionView(this);
         this.createScrollbar();
         this.createItemInfoFields();
      }
      
      public function createBackground() : void
      {
         this.backgroundSprite = new Sprite();
         var _loc1_:Sprite = AssetProxy.getMovieClip("scrollComponents","inventory");
         this.inventoryTabButton = AssetProxy.getMovieClip("scrollComponents","inventoryTab");
         this.inventoryTabButtonTextField = this.inventoryTabButton["btnText"];
         this.inventoryTabButtonTextField.text = BPLocale.getItem("label_ui_inventory");
         this.inventoryTabButtonTextField.selectable = false;
         this.inventoryTabButtonTextField.embedFonts = Styles.baseEmbed;
         this.inventoryTabButton.buttonMode = true;
         this.inventoryTabButton.useHandCursor = true;
         this.inventoryTabButton.mouseChildren = false;
         this.inventoryTabButton.addEventListener(MouseEvent.MOUSE_OVER,this.handleInventoryTabButtonMouseOverEvent);
         this.inventoryTabButton.addEventListener(MouseEvent.MOUSE_OUT,this.handleInventoryTabButtonMouseOutEvent);
         this.inventoryTabButton.addEventListener(MouseEvent.CLICK,this.handleInventoryTabButtonMouseClickEvent);
         this.toolTipControl.addToolTip(this.inventoryTabButton,BPLocale.getItem("tooltip_button_open_inventory"));
         var _loc2_:Sprite = AssetProxy.getMovieClip("scrollComponents","inventoryTabTop");
         this.inventoryBtnsBg = AssetProxy.getMovieClip("scrollComponents","inventoryBtnsBg");
         var _loc3_:BitmapData = AssetProxy.getBitmapData("scrollComponents","inventoryTitleBar");
         this.backgroundTopBarSprite = new Sprite();
         this.backgroundTopBarSprite.graphics.beginBitmapFill(_loc3_);
         this.backgroundTopBarSprite.graphics.drawRect(0,0,_loc1_.width,_loc3_.height);
         this.backgroundTopBarSprite.graphics.endFill();
         this.backgroundSprite.addChild(this.backgroundTopBarSprite);
         this.backgroundSprite.addChild(_loc2_);
         this.backgroundSprite.addChild(_loc1_);
         this.backgroundSprite.addChild(this.inventoryTabButton);
         this.inventoryTabButton.x = UILayoutProxy.INVENTORY_TAB_DISPLAY_X;
         this.inventoryTabButton.y = UILayoutProxy.INVENTORY_TAB_DISPLAY_Y;
         _loc1_.y = UILayoutProxy.INVENTORY_BG_GRAPHIC_Y;
         addChild(this.backgroundSprite);
         addChild(this.inventoryBtnsBg);
         this.inventoryBtnsBg.x = UILayoutProxy.INVENTORY_BUTTON_BG_X;
         this.inventoryBtnsBg.y = UILayoutProxy.INVENTORY_BUTTON_BG_Y;
         this.backgroundSprite.x = UILayoutProxy.INVENTORY_BACKGROUND_X;
      }
      
      public function createButtons() : void
      {
         this.sellBtn = new InventoryButton("sell",BPLocale.getItem("label_button_sell"));
         this.sellShipOrPetBtn = new InventoryButton("sell",BPLocale.getItem("label_button_sell"));
         this.sellShipOrPetBtn.visible = false;
         this.sellShipOrPetBtn.addEventListener(MouseEvent.CLICK,this.askServerForShipOrPetSell);
         this.quickBuyBtn = new InventoryButton("quickBuy",BPLocale.getItem("label_button_quick_buy"));
         this.moduleUpgradeBtn = new InventoryButton("quickBuy",BPLocale.getItem("label_button_upgrade"));
         this.contextUseBtn = new InventoryButton("contextUse",BPLocale.getItem("label_button_repair"));
         var _loc1_:TooltipControl = TooltipControl.getInstance();
         _loc1_.addToolTip(this.sellBtn,BPLocale.getItem("tooltip_button_sell"));
         _loc1_.addToolTip(this.contextUseBtn,BPLocale.getItem("tooltip_button_repair"));
         _loc1_.addToolTip(this.quickBuyBtn,BPLocale.getItem("tooltip_button_quick_buy"));
         this.actionsMenu.addChild(this.sellBtn);
         this.actionsMenu.addChild(this.sellShipOrPetBtn);
         this.actionsMenu.addChild(this.quickBuyBtn);
         this.actionsMenu.addChild(this.moduleUpgradeBtn);
         this.actionsMenu.addChild(this.contextUseBtn);
         this.addActionButtonEventListener(this.sellBtn);
         this.addActionButtonEventListener(this.contextUseBtn);
         this.addActionButtonEventListener(this.quickBuyBtn);
         this.moduleUpgradeBtn.addEventListener(MouseEvent.CLICK,this.handleModuleUpgradeButtonClickEvent);
         this.sellBtn.y = this.sellBtn.height * 0;
         this.sellShipOrPetBtn.y = this.sellBtn.y;
         this.quickBuyBtn.y = this.quickBuyBtn.height * 1;
         this.moduleUpgradeBtn.y = this.quickBuyBtn.y;
         this.contextUseBtn.y = this.contextUseBtn.height * 2;
         this.actionsMenu.x = this.maskSprite.x + 13;
         this.actionsMenu.y = this.maskSprite.y + (this.maskSprite.height + 4) + 55;
         addChild(this.actionsMenu);
         this.disableAllInventoryButtons();
      }
      
      private function createInventoryButtons() : void
      {
         this.inventoryOpenBtn = new GenericButton(GenericButton.NO_TEXT,"openInventory");
         this.inventoryOpenBtn.addListeners();
         this.toolTipControl.addToolTip(this.inventoryOpenBtn,BPLocale.getItem("tooltip_button_open_inventory"));
         this.inventoryCloseBtn = new GenericButton(GenericButton.NO_TEXT,"closeInventory");
         this.backgroundSprite.addChild(this.inventoryOpenBtn);
         this.inventoryOpenBtn.x = UILayoutProxy.INVENTORY_OPEN_BTN_X;
         this.inventoryOpenBtn.y = UILayoutProxy.INVENTORY_OPEN_BTN_Y;
         this.backgroundSprite.addChild(this.inventoryCloseBtn);
         this.inventoryCloseBtn.x = UILayoutProxy.INVENTORY_CLOSE_BTN_X;
         this.inventoryCloseBtn.y = UILayoutProxy.INVENTORY_CLOSE_BTN_Y;
         this.toolTipControl.addToolTip(this.inventoryCloseBtn,BPLocale.getItem("tooltip_button_close_inventory"));
         this.backgroundSprite.setChildIndex(this.inventoryOpenBtn,0);
         this.backgroundSprite.setChildIndex(this.inventoryCloseBtn,0);
         this.backgroundSprite.setChildIndex(this.backgroundTopBarSprite,0);
         this.inventoryCloseBtn.buttonGraphic.gotoAndStop(3);
         this.inventoryOpenBtn.addEventListener(MouseEvent.CLICK,this.openFullInventory);
         this.inventoryCloseBtn.addEventListener(MouseEvent.CLICK,this.closeFullInventory);
      }
      
      private function createInventoryMask() : void
      {
         this.maskSprite = new Sprite();
         this.maskSprite.graphics.beginFill(16711680,1);
         this.maskSprite.graphics.drawRect(0,0,this.grid.width,205);
         this.maskSprite.graphics.endFill();
         addChild(this.maskSprite);
         this.maskSprite.x = UILayoutProxy.INVENTORY_GRID_X;
         this.maskSprite.y = UILayoutProxy.INVENTORY_GRID_Y;
         this.grid.mask = this.maskSprite;
         this.blueSprite = new Sprite();
         this.blueSprite.graphics.beginFill(1974821,1);
         this.blueSprite.graphics.drawRect(0,0,this.grid.width,205);
         this.blueSprite.graphics.endFill();
         addChild(this.blueSprite);
         var _loc1_:int = getChildIndex(this.backgroundSprite);
         setChildIndex(this.blueSprite,_loc1_ + 1);
         this.blueSprite.x = UILayoutProxy.INVENTORY_GRID_X;
         this.blueSprite.y = UILayoutProxy.INVENTORY_GRID_Y;
      }
      
      private function createScrollbar() : void
      {
         this.inventoryScroller = new ScrollBar(this.grid.y,0,this.grid.x,this.grid.y + this.maskSprite.height,this.grid,true);
         this.addChild(this.inventoryScroller);
      }
      
      private function createItemInfoFields() : void
      {
         this.itemDescriptionField = new ItemInfoField();
         this.itemDescriptionField.addTextToMainField(BPLocale.getItem("inventory_item_details_none_selected"));
         this.itemDescriptionField.alpha = 0;
         this.itemDescriptionField.x = UILayoutProxy.INVENTORY_ITEM_DESCRIPTION_X;
         this.itemDescriptionField.y = UILayoutProxy.INVENTORY_ITEM_DESCRIPTION_Y;
         this.itemDescriptionField.mainText.width = 318;
         this.largeItemGraphic = new InventoryLargeItemComponent();
         this.largeItemGraphic.x = UILayoutProxy.INVENTORY_ITEM_SELECTED_GRAPHIC_X;
         this.largeItemGraphic.y = UILayoutProxy.INVENTORY_ITEM_SELECTED_GRAPHIC_Y;
         this.largeItemGraphic.alpha = 0;
         this.itemDetailsField = new ItemInfoField();
         this.itemDetailsField.addTextToMainField("");
         this.itemDetailsField.mainText.width = 318;
         this.itemDetailsField.mainText.height = 190;
         this.itemDetailsField.mainText.addEventListener(TextEvent.LINK,this.handleItemUpgradeLinkClick);
         this.itemDetailsField.x = UILayoutProxy.INVENTORY_ITEM_DETAILS_X;
         this.itemDetailsField.y = UILayoutProxy.INVENTORY_ITEM_DETAILS_Y;
         this.itemDetailsField.alpha = 0;
      }
      
      public function createDesignSelectionMenu(param1:String, param2:Dictionary) : void
      {
         this.removeDesignSelectionMenu();
         this.designSelectionMenu = new DropDownMenu();
         this.designSelectionMenu.createDropDownFromDictionary(param2);
         this.designSelectionMenu.changeCurrentlySelectedItem(param1);
         this.designSelectionMenu.addButtonCallbackFunction(this.changeDesignCallback);
         this.designSelectionMenu.createPopUpDisplay();
         this.designSelectionMenu.addRollOverFunction();
         if(this.designSelectionMenu.numberOfButtons >= 1)
         {
            addChild(this.designSelectionMenu);
            this.toolTipControl.addToolTip(this.designSelectionMenu,BPLocale.getItem("tooltip_ship_design_menu"));
         }
         this.designSelectionMenu.x = 386;
         this.designSelectionMenu.y = 9;
         FocusManager.getInstance().add(this.designSelectionMenu);
      }
      
      public function createGridFilteringMenus(param1:Dictionary) : void
      {
         var _loc8_:HangarSlotEntity = null;
         var _loc9_:HangarSlotEntity = null;
         var _loc10_:String = null;
         this.itemFiltersMenu = new DropDownMenu();
         this.itemFiltersMenu.x = UILayoutProxy.INVENTORY_FILTER_MENU_X;
         this.itemFiltersMenu.y = UILayoutProxy.INVENTORY_FILTER_MENU_Y;
         this.itemFiltersMenu.alpha = 0;
         this.itemFiltersMenu.createDropDownFromDictionary(param1,ItemFilter.USER_FILTER,true);
         this.itemFiltersMenu.addButtonCallbackFunction(this.grid.filterGridOnMouseEvent);
         this.toolTipControl.addToolTip(this.itemFiltersMenu,BPLocale.getItem("tooltip_filter_menu"));
         var _loc2_:Dictionary = this.hangarManager.getAllHangarSlotVOs();
         var _loc3_:Dictionary = new Dictionary();
         var _loc4_:String = BPLocale.getItem("combobox_hangar_name");
         var _loc5_:String = BPLocale.getItem("combobox_all_hangars_name");
         var _loc6_:HangarSlotEntity = new HangarSlotEntity();
         var _loc7_:uint = 0;
         _loc6_.slotID = 0;
         for each(_loc8_ in _loc2_)
         {
            _loc9_ = _loc2_[_loc7_];
            _loc7_++;
            if(_loc8_.name)
            {
               _loc10_ = _loc8_.name;
            }
            else
            {
               _loc10_ = _loc4_.split("%HANGARSLOTID%").join(_loc7_);
            }
            _loc3_[_loc10_] = _loc9_;
         }
         _loc3_[_loc5_] = _loc5_;
         this.hangarFiltersMenu = new DropDownMenu();
         this.hangarFiltersMenu.alpha = 0;
         this.hangarFiltersMenu.x = UILayoutProxy.INVENTORY_FILTER_MENU_X - 220;
         this.hangarFiltersMenu.y = UILayoutProxy.INVENTORY_FILTER_MENU_Y;
         this.hangarFiltersMenu.createDropDownFromDictionary(_loc3_,_loc5_);
         this.hangarFiltersMenu.addButtonCallbackFunction(this.handleHangarFiltersMenuSelectionChangedOnMouseClick);
         this.hangarFiltersMenu.addEventListener(DropDownMenu.EVENT_SELECTION_CHANGED,this.handleHangarFiltersMenuSelectionChanged);
         this.toolTipControl.addToolTip(this.hangarFiltersMenu,BPLocale.getItem("tooltip_filter_hangar_menu"));
         FocusManager.getInstance().add(this.hangarFiltersMenu);
         FocusManager.getInstance().add(this.itemFiltersMenu);
         this.hangarFiltersMenu.deactivate();
         this.itemFiltersMenu.deactivate();
         addChild(this.itemFiltersMenu);
         addChild(this.hangarFiltersMenu);
      }
      
      public function removeDesignSelectionMenu() : void
      {
         var _loc1_:Boolean = false;
         if(this.designSelectionMenu)
         {
            _loc1_ = this.contains(this.designSelectionMenu);
            if(_loc1_)
            {
               removeChild(this.designSelectionMenu);
            }
            _loc1_ = this.contains(this.designSelectionMenu);
            this.designSelectionMenu = null;
            FocusManager.getInstance().remove(this.designSelectionMenu);
         }
      }
      
      public function removeInventoryVisibleComponents() : void
      {
         FocusManager.getInstance().remove(this.itemFiltersMenu);
         FocusManager.getInstance().remove(this.hangarFiltersMenu);
         FocusManager.getInstance().remove(this.designSelectionMenu);
         DisplayObjectHelper.removeDisplayObject(this.grid);
         DisplayObjectHelper.removeDisplayObject(this.maskSprite);
         DisplayObjectHelper.removeDisplayObject(this.blueSprite);
         DisplayObjectHelper.removeDisplayObject(this.inventoryScroller);
         DisplayObjectHelper.removeDisplayObject(this.backgroundSprite);
         DisplayObjectHelper.removeDisplayObject(this.inventoryBtnsBg);
         DisplayObjectHelper.removeDisplayObject(this.designSelectionMenu);
         DisplayObjectHelper.removeDisplayObject(this.itemFiltersMenu);
         DisplayObjectHelper.removeDisplayObject(this.hangarFiltersMenu);
         DisplayObjectHelper.removeDisplayObject(this.itemDescriptionField);
         DisplayObjectHelper.removeDisplayObject(this.largeItemGraphic);
         DisplayObjectHelper.removeDisplayObject(this.itemDetailsField);
      }
      
      private function addActionButtonEventListener(param1:InventoryButton) : void
      {
         switch(param1.buttonName)
         {
            case "sell":
               param1.addEventListener(MouseEvent.CLICK,this.askServerForItemSell);
               break;
            case "contextUse":
               param1.addEventListener(MouseEvent.CLICK,this.askServerForItemRepair);
               param1.currentActiveCallback = this.askServerForItemRepair;
               break;
            case "quickBuy":
               param1.addEventListener(MouseEvent.CLICK,this.askServerForItemQuickBuy);
         }
      }
      
      private function handleItemUpgradeLinkClick(param1:TextEvent) : void
      {
         ExternalInterfaceManager.redirectToItemUpgradeSystem();
      }
      
      protected function handleHangarFiltersMenuSelectionChangedOnMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:DropDownButton = param1.currentTarget as DropDownButton;
         this.currentHangarSlotEntityAsFilter = _loc2_.data as HangarSlotEntity;
         this.filterGridByHangarSlotVO(this.currentHangarSlotEntityAsFilter);
      }
      
      protected function handleHangarFiltersMenuSelectionChanged(param1:Event) : void
      {
         var _loc2_:HangarSlotEntity = this.hangarManager.getCurrentHangarSlotVO();
         this.currentHangarSlotEntityAsFilter = _loc2_;
         this.filterGridByHangarSlotVO(_loc2_);
      }
      
      private function changeDesignCallback(param1:MouseEvent) : void
      {
         var _loc2_:DropDownButton = DropDownButton(param1.currentTarget);
         var _loc3_:String = _loc2_.buttonKey;
         dispatchEvent(new InventoryEvent(InventoryEvent.DESIGN_MENU_CLICK,_loc3_));
      }
      
      protected function handleInventoryTabButtonMouseOverEvent(param1:MouseEvent) : void
      {
         var _loc2_:Array = new Array();
         _loc2_ = _loc2_.concat([0.9,0.9,0.9,0,0]);
         _loc2_ = _loc2_.concat([0.9,0.9,0.9,0,0]);
         _loc2_ = _loc2_.concat([0.9,0.9,0.9,0,0]);
         _loc2_ = _loc2_.concat([0,0,0,1,0]);
         var _loc3_:ColorMatrixFilter = new ColorMatrixFilter(_loc2_);
         this.inventoryTabButtonTextField.filters = [_loc3_];
      }
      
      protected function handleInventoryTabButtonMouseOutEvent(param1:MouseEvent) : void
      {
         this.inventoryTabButtonTextField.filters = [];
      }
      
      protected function handleInventoryTabButtonMouseClickEvent(param1:MouseEvent) : void
      {
         this.setInventoryViewmode(!Settings.inventoryOpen);
      }
      
      private function handleModuleUpgradeButtonClickEvent(param1:Event) : void
      {
         ExternalInterfaceManager.redirectToItemUpgradeSystem();
      }
      
      private function handleGridFocused(param1:GridEvent) : void
      {
         this.inventoryScroller.isMouseWheelActivcated = true;
      }
      
      private function handleGridUnFocused(param1:GridEvent) : void
      {
         this.inventoryScroller.isMouseWheelActivcated = false;
      }
      
      public function refreshView() : void
      {
         var _loc1_:Boolean = false;
         _loc1_ = true;
         if(this.grid.currentFilter == ItemFilter.CONTEXT_FILTER)
         {
            this.filterGridAndMarkEquipedItems();
            this.updateSpecificScrollbar();
            return;
         }
         if(this.grid.currentFilter != ItemFilter.USER_FILTER)
         {
            this.updateFilteredGrid();
         }
      }
      
      public function updateContextUseBtn(param1:String) : void
      {
         if(param1 == ActionIdentifiers.CONTEXT_BTN_REPAIR_MODE)
         {
            this.currentContextBtnContext = param1;
            this.contextUseBtn.removeEventListener(MouseEvent.CLICK,this.askServerForChangeCPUMode);
            this.contextUseBtn.addEventListener(MouseEvent.CLICK,this.askServerForItemRepair);
            this.contextUseBtn.currentActiveCallback = this.askServerForItemRepair;
            this.contextUseBtn.changeButtonText(BPLocale.getItem("label_button_repair"));
            this.toolTipControl.removeToolTip(this.contextUseBtn);
            this.toolTipControl.addToolTip(this.contextUseBtn,BPLocale.getItem("tooltip_button_repair"));
         }
         else if(param1 == ActionIdentifiers.CONTEXT_BTN_CPU_MODE)
         {
            this.currentContextBtnContext = param1;
            this.contextUseBtn.removeEventListener(MouseEvent.CLICK,this.askServerForItemRepair);
            this.contextUseBtn.addEventListener(MouseEvent.CLICK,this.askServerForChangeCPUMode);
            this.contextUseBtn.currentActiveCallback = this.askServerForChangeCPUMode;
            this.contextUseBtn.changeButtonText(BPLocale.getItem("label_button_use"));
            this.toolTipControl.removeToolTip(this.contextUseBtn);
            this.toolTipControl.addToolTip(this.contextUseBtn,BPLocale.getItem("tooltip_button_use"));
         }
      }
      
      public function updateSaleValue(param1:int) : void
      {
         this.inventoryBtnsBg.btnText.text = BPLocale.getItem("pricetag_credits_compact").replace("%VALUE%",TextFormatter.round(param1));
      }
      
      public function disableAllInventoryButtons() : void
      {
         this.sellBtn.setInactive();
         this.sellShipOrPetBtn.visible = false;
         this.sellShipOrPetBtn.setInactive();
         this.quickBuyBtn.setInactive();
         this.quickBuyBtn.removeEventListener(MouseEvent.CLICK,this.askServerForItemQuickBuy);
         this.moduleUpgradeBtn.visible = false;
         this.contextUseBtn.setInactive();
         if(this.contextUseBtn.hasEventListener(MouseEvent.CLICK))
         {
            this.contextUseBtn.removeEventListener(MouseEvent.CLICK,this.contextUseBtn.currentActiveCallback);
         }
      }
      
      public function updateFromAccordionViewEntitySelectionChanged(param1:AccordionViewEntity) : void
      {
         var _loc4_:Ship = null;
         var _loc5_:String = null;
         var _loc6_:ItemInfoVO = null;
         var _loc7_:String = null;
         var _loc8_:Object = null;
         var _loc2_:Boolean = param1.isSelected;
         var _loc3_:int = param1.type;
         if(_loc2_)
         {
            this.sellBtn.setInactive();
            this.sellShipOrPetBtn.visible = true;
            this.sellShipOrPetBtn.setActive();
            switch(_loc3_)
            {
               case AccordionViewEntity.SHIP:
                  _loc4_ = EquipmentManager.getInstance().ship;
                  _loc5_ = _loc4_.getShipType();
                  _loc6_ = ItemInfoManager.getInstance().getItemInfo(_loc5_);
                  _loc7_ = _loc6_.saleValuesByLevel[0];
                  this.updateSaleValue(int(_loc7_));
                  _loc8_ = {
                     "ID":_loc4_.ID,
                     "action":ActionIdentifiers.SELL_SHIP
                  };
                  this.sellShipOrPetBtn.data = _loc8_;
                  break;
               case AccordionViewEntity.PET:
            }
         }
         else
         {
            this.deactivateSellShipOrPetButton();
         }
         this.quickBuyBtn.setInactive();
         this.contextUseBtn.setInactive();
      }
      
      public function deactivateSellShipOrPetButton() : void
      {
         this.sellShipOrPetBtn.visible = false;
         this.sellShipOrPetBtn.setInactive();
         this.sellBtn.setInactive();
         this.updateSaleValue(0);
      }
      
      public function updateActionButtonStatus() : void
      {
         this.updateSellButtonStatus();
         this.updateQuickBuyButtonStatus();
         this.updateContextButtonStatus();
      }
      
      private function updateSellButtonStatus() : void
      {
         var _loc3_:Boolean = false;
         var _loc1_:InventoryItemComponent = this.dragComp.selectedItem;
         var _loc2_:ItemInfoVO = ItemInfoManager.getInstance().getItemInfo(_loc1_.lootID);
         if(_loc2_)
         {
            _loc3_ = _loc2_.sellable;
         }
         else
         {
            _loc3_ = _loc1_.sellable;
         }
         if(_loc3_)
         {
            if(_loc1_.isModuleInstalled() || _loc1_.isLF4Laser() || _loc1_.isDroneDesign())
            {
               this.sellBtn.setInactive();
            }
            else
            {
               this.sellBtn.setActive();
            }
         }
         else
         {
            this.sellBtn.setInactive();
         }
         this.sellShipOrPetBtn.visible = false;
         this.sellShipOrPetBtn.setInactive();
      }
      
      public function updateQuickBuyButtonStatus() : void
      {
         var _loc1_:InventoryItemComponent = this.dragComp.selectedItem;
         if(_loc1_.group != null)
         {
            if(_loc1_.isModule())
            {
               this.moduleUpgradeBtn.visible = true;
               this.quickBuyBtn.visible = false;
            }
            else
            {
               this.moduleUpgradeBtn.visible = false;
               this.quickBuyBtn.visible = true;
            }
            if(_loc1_.isResource() || _loc1_.isDroneDesignClassItem() || _loc1_.isLotteryItem() || _loc1_.isWordPuzzleItem() || _loc1_.isResourceDronePart())
            {
               this.quickBuyBtn.setInactive();
               this.quickBuyBtn.removeEventListener(MouseEvent.CLICK,this.askServerForItemQuickBuy);
               return;
            }
         }
         if(_loc1_.isDrone || _loc1_.itemName == ActionIdentifiers.LF4)
         {
            this.quickBuyBtn.setInactive();
            this.quickBuyBtn.removeEventListener(MouseEvent.CLICK,this.askServerForItemQuickBuy);
         }
         else
         {
            this.quickBuyBtn.setActive();
            this.quickBuyBtn.addEventListener(MouseEvent.CLICK,this.askServerForItemQuickBuy);
         }
      }
      
      public function updateContextButtonStatus() : void
      {
         var _loc2_:int = 0;
         var _loc1_:InventoryItemComponent = this.dragComp.selectedItem;
         if(!_loc1_.buyableExtraSlot)
         {
            if(_loc1_.isDrone)
            {
               if(_loc1_.repairable)
               {
                  this.contextUseBtn.setActive();
                  this.contextUseBtn.addEventListener(MouseEvent.CLICK,this.contextUseBtn.currentActiveCallback);
               }
               else
               {
                  this.contextUseBtn.setInactive();
                  this.contextUseBtn.removeEventListener(MouseEvent.CLICK,this.contextUseBtn.currentActiveCallback);
               }
            }
            else if(this.currentContextBtnContext == ActionIdentifiers.CONTEXT_BTN_CPU_MODE)
            {
               this.contextUseBtn.setActive();
               this.contextUseBtn.addEventListener(MouseEvent.CLICK,this.contextUseBtn.currentActiveCallback);
            }
            else if(_loc1_.isModule())
            {
               _loc2_ = _loc1_.getItemInstanceData().repairCosts;
               if(_loc2_ > 0)
               {
                  this.contextUseBtn.setActive();
                  this.contextUseBtn.addEventListener(MouseEvent.CLICK,this.contextUseBtn.currentActiveCallback);
               }
               else
               {
                  this.contextUseBtn.setInactive();
               }
            }
            else
            {
               this.contextUseBtn.setInactive();
               this.contextUseBtn.removeEventListener(MouseEvent.CLICK,this.contextUseBtn.currentActiveCallback);
            }
         }
      }
      
      public function updateSelectedItemTextFields(param1:Dictionary, param2:Boolean = false) : void
      {
         var _loc11_:StyleSheet = null;
         var _loc12_:String = null;
         this.updateSaleValue(param1[ActionIdentifiers.SALE_VALUE]);
         if(param2)
         {
            return;
         }
         this.toolTipControl.removeToolTip(this.itemDetailsField);
         this.toolTipControl.removeToolTip(this.itemDescriptionField);
         var _loc3_:String = param1[ActionIdentifiers.ICON_PATH];
         this.largeItemGraphic.changeLargeGraphic(_loc3_);
         var _loc4_:ITooltipPreparer = TooltipPreparerFactory.create(this.dragComp.selectedItem);
         _loc4_.callDirtyRelict();
         var _loc5_:String = _loc4_.getTooltipText();
         var _loc6_:String = _loc4_.getShortenedText(true);
         var _loc7_:TextField = this.itemDetailsField.mainText;
         _loc7_.width = 165;
         _loc7_.multiline = true;
         _loc7_.htmlText = "";
         _loc7_.htmlText += _loc6_;
         var _loc8_:Boolean = false;
         if(_loc8_)
         {
            _loc11_ = new StyleSheet();
            _loc12_ = BPLocale.getItem("label_button_item_upgrade");
            _loc7_.htmlText += "<a href=\'event:myEvent\'>" + _loc12_ + "</a>";
            _loc11_.setStyle("a:link",{
               "color":"#CCCCCC",
               "display":"inline",
               "textDecoration":"underline"
            });
            _loc11_.setStyle("a:hover",{
               "color":"#999999",
               "display":"inline"
            });
            _loc7_.styleSheet = _loc11_;
         }
         else
         {
            _loc7_.styleSheet = null;
         }
         this.toolTipControl.addToolTip(this.itemDetailsField,_loc5_);
         var _loc9_:String = param1[ItemLocalisationKeys.LOCA_DESC_REPLACE];
         var _loc10_:String = AbstractTooltipPreparer.cutSingleLine(_loc9_);
         this.itemDescriptionField.mainText.htmlText = _loc10_;
         this.toolTipControl.addToolTip(this.itemDescriptionField,_loc9_,true);
      }
      
      private function updateSpecificScrollbar() : void
      {
         var _loc1_:Number = NaN;
         if(this.grid.lowestOfSortedItems != null)
         {
            _loc1_ = this.grid.height;
            this.inventoryScroller.setScrollBarConditions(_loc1_);
            this.inventoryScroller.checkScrollBarWithinBounds();
         }
      }
      
      public function closeDesignsMenu() : void
      {
         this.designSelectionMenu.closeMenuOnly();
      }
      
      public function clearItemTextFields() : void
      {
         this.toolTipControl.removeToolTip(this.itemDetailsField);
         this.toolTipControl.removeToolTip(this.itemDescriptionField);
         this.itemDescriptionField.mainText.htmlText = "";
         this.itemDetailsField.mainText.htmlText = "";
         this.largeItemGraphic.removeItemSprite();
      }
      
      protected function setInventoryViewmode(param1:Boolean) : void
      {
         if(param1)
         {
            this.openFullInventory(null);
         }
         else
         {
            this.closeFullInventory(null);
         }
      }
      
      private function openFullInventory(param1:MouseEvent) : void
      {
         var _loc4_:String = null;
         Settings.inventoryOpen = true;
         dispatchEvent(new InventoryEvent(InventoryEvent.CLOSE_DESIGN_MENU));
         this.toolTipControl.addToolTip(this.inventoryTabButton,BPLocale.getItem("tooltip_button_close_inventory"));
         this.inventoryOpenBtn.removeListeners();
         this.inventoryOpenBtn.removeEventListener(MouseEvent.CLICK,this.openFullInventory);
         this.inventoryOpenBtn.buttonGraphic.gotoAndStop(3);
         this.inventoryCloseBtn.addListeners();
         this.inventoryCloseBtn.addEventListener(MouseEvent.CLICK,this.closeFullInventory);
         this.inventoryCloseBtn.buttonGraphic.gotoAndStop(1);
         if(contains(this.designSelectionMenu))
         {
            removeChild(this.designSelectionMenu);
         }
         this.itemFiltersMenu.mainDropDownButton.buttonGraphic.btnText.text = this.itemFiltersMenu.defaultButtonText.toUpperCase();
         this.itemFiltersMenu.activate();
         var _loc2_:String = BPLocale.getItem("combobox_all_hangars_name");
         var _loc3_:DropDownButton = this.hangarFiltersMenu.getCurrentSelectedDropDownButton();
         if(_loc3_)
         {
            _loc2_ = _loc3_.buttonText;
         }
         this.hangarFiltersMenu.mainDropDownButton.buttonGraphic.btnText.text = this.hangarFiltersMenu.defaultButtonText.toUpperCase();
         this.hangarFiltersMenu.activate();
         this.grid.currentFilter = ItemFilter.USER_FILTER;
         this.grid.BLOCKS_ACROSS = 4;
         this.grid.changeVisibleState(true,this.grid.iconsInThisMenu);
         this.grid.addAllEquippedOverlays(this.grid.iconsInThisMenu);
         this.grid.addDragListeners(this.grid.iconsInThisMenu);
         this.grid.gridArranger.rearrangeActive = true;
         this.grid.reDrawGrid_TheSecondComing();
         this.currentHangarSlotEntityAsFilter = null;
         this.disableAllInventoryButtons();
         if(this.dragComp.selectedItem != null)
         {
            _loc4_ = this.dragComp.selectedItem.itemID;
            this.grid.selectItem(_loc4_);
         }
         else
         {
            this.clearItemTextFields();
         }
         TweenMax.to(this.grid,INVENTORY_TWEEN_SPEED,{
            "x":UILayoutProxy.INVENTORY_GRID_EXTENDED_X,
            "ease":Quart.easeOut
         });
         TweenMax.to(this.backgroundSprite,INVENTORY_TWEEN_SPEED,{
            "x":0,
            "ease":Quart.easeOut,
            "onComplete":this.inventoryOpeningComplete
         });
         TweenMax.to(this.inventoryOpenBtn,INVENTORY_TWEEN_SPEED,{
            "x":UILayoutProxy.INVENTORY_OPEN_BTN_EXTENDED_X,
            "ease":Quart.easeOut
         });
         TweenMax.to(this.inventoryCloseBtn,INVENTORY_TWEEN_SPEED,{
            "x":UILayoutProxy.INVENTORY_CLOSE_BTN_EXTENDED_X,
            "ease":Quart.easeOut
         });
         TweenMax.to(this.maskSprite,INVENTORY_TWEEN_SPEED,{
            "x":UILayoutProxy.INVENTORY_GRID_MASK_EXTENDED_X,
            "width":UILayoutProxy.INVENTORY_GRID_MASK_EXTENDED_WIDTH,
            "ease":Quart.easeOut
         });
         TweenMax.to(this.blueSprite,INVENTORY_TWEEN_SPEED,{"alpha":0});
         TweenMax.to(this.hangarFiltersMenu,INVENTORY_TWEEN_SPEED,{"alpha":1});
         TweenMax.to(this.itemFiltersMenu,INVENTORY_TWEEN_SPEED,{"alpha":1});
         this.currentInventoryState = FULL_MODE_INVENTORY;
      }
      
      private function inventoryOpeningComplete() : void
      {
         this.itemDescriptionField.alpha = 0;
         this.itemDetailsField.alpha = 0;
         this.largeItemGraphic.alpha = 0;
         addChild(this.itemDescriptionField);
         addChild(this.itemDetailsField);
         addChild(this.largeItemGraphic);
         TweenMax.to(this.itemDescriptionField,INVENTORY_TWEEN_SPEED,{"alpha":1});
         TweenMax.to(this.itemDetailsField,INVENTORY_TWEEN_SPEED,{"alpha":1});
         TweenMax.to(this.largeItemGraphic,INVENTORY_TWEEN_SPEED,{"alpha":1});
         dispatchEvent(new InventoryEvent(InventoryEvent.INVENTORY_SWITCHED));
         this.inventoryScroller.setScrollBarConditions();
         this.inventoryScroller.resetAllElementsToStartingPositions();
      }
      
      private function closeFullInventory(param1:MouseEvent) : void
      {
         Settings.inventoryOpen = false;
         dispatchEvent(new InventoryEvent(InventoryEvent.INVENTORY_SWITCHED));
         this.toolTipControl.addToolTip(this.inventoryTabButton,BPLocale.getItem("tooltip_button_open_inventory"));
         this.inventoryOpenBtn.addListeners();
         this.inventoryOpenBtn.addEventListener(MouseEvent.CLICK,this.openFullInventory);
         this.inventoryOpenBtn.buttonGraphic.gotoAndStop(1);
         this.inventoryCloseBtn.removeListeners();
         this.inventoryCloseBtn.removeEventListener(MouseEvent.CLICK,this.closeFullInventory);
         this.inventoryCloseBtn.buttonGraphic.gotoAndStop(3);
         TweenMax.to(this.backgroundSprite,INVENTORY_TWEEN_SPEED,{
            "x":UILayoutProxy.INVENTORY_BACKGROUND_X,
            "onComplete":this.inventoryClosingComplete,
            "ease":Quart.easeOut
         });
         TweenMax.to(this.inventoryOpenBtn,INVENTORY_TWEEN_SPEED,{
            "x":UILayoutProxy.INVENTORY_OPEN_BTN_X,
            "ease":Quart.easeOut
         });
         TweenMax.to(this.inventoryCloseBtn,INVENTORY_TWEEN_SPEED,{
            "x":UILayoutProxy.INVENTORY_CLOSE_BTN_X,
            "ease":Quart.easeOut
         });
         TweenMax.to(this.maskSprite,INVENTORY_TWEEN_SPEED,{
            "x":UILayoutProxy.INVENTORY_GRID_X,
            "width":UILayoutProxy.INVENTORY_GRID_MASK_WIDTH,
            "ease":Quart.easeOut
         });
         TweenMax.to(this.grid,INVENTORY_TWEEN_SPEED,{
            "x":UILayoutProxy.INVENTORY_GRID_X,
            "ease":Quart.easeOut
         });
         TweenMax.to(this.blueSprite,INVENTORY_TWEEN_SPEED,{"alpha":1});
         TweenMax.to(this.itemFiltersMenu,INVENTORY_TWEEN_SPEED,{"alpha":0});
         TweenMax.to(this.hangarFiltersMenu,INVENTORY_TWEEN_SPEED,{"alpha":0});
         if(contains(this.itemDescriptionField))
         {
            removeChild(this.itemDescriptionField);
         }
         if(contains(this.itemDetailsField))
         {
            removeChild(this.itemDetailsField);
         }
         if(contains(this.largeItemGraphic))
         {
            removeChild(this.largeItemGraphic);
         }
         this.grid.BLOCKS_ACROSS = 1;
         this.filterGridAndMarkEquipedItems();
         this.currentInventoryState = MINI_MODE_INVENTORY;
         if(this.dragComp.selectedItem != null)
         {
            this.dragComp.selectedItem.setDeselected();
            this.dragComp.selectedItem = null;
         }
         this.itemFiltersMenu.deactivate();
         this.hangarFiltersMenu.deactivate();
         this.disableAllInventoryButtons();
      }
      
      private function inventoryClosingComplete() : void
      {
         this.updateSpecificScrollbar();
         this.inventoryScroller.resetAllElementsToStartingPositions();
         if(this.designSelectionMenu.numberOfButtons >= 1)
         {
            addChild(this.designSelectionMenu);
         }
         TweenMax.to(this.designSelectionMenu,INVENTORY_TWEEN_SPEED,{"alpha":1});
      }
      
      private function filterGridByHangarSlotVO(param1:HangarSlotEntity) : void
      {
         if(param1)
         {
            this.filterGridByHangarID(param1.hangarID);
         }
         else
         {
            this.filterGridByHangarID();
         }
      }
      
      private function filterGridByHangarID(param1:int = 0) : void
      {
         this.grid.setHangarIDasFilter(param1);
         var _loc2_:DropDownButton = this.itemFiltersMenu.getCurrentSelectedDropDownButton();
         this.grid.filterGridByButton(_loc2_);
      }
      
      public function filterByContext(param1:Array) : void
      {
         this.currentContextFilterGroup = param1;
         this.filterGridAndMarkEquipedItems();
         this.updateSpecificScrollbar();
      }
      
      private function filterGridAndMarkEquipedItems() : void
      {
         var _loc1_:int = Settings.inactiveConfig;
         var _loc2_:Array = this.hangarManager.getAllEquippedItemIDsHangarWideExceptTheCurrentHangarFor();
         var _loc3_:Array = this.hangarManager.getAllEquippedItemIDsForCurrentHangarConfiguration(_loc1_);
         this.grid.filterByContext(this.currentContextFilterGroup,_loc2_,_loc3_);
      }
      
      public function updateFilteredGrid() : void
      {
         var _loc1_:HangarSlotEntity = null;
         _loc1_ = this.currentHangarSlotEntityAsFilter;
         this.filterGridByHangarSlotVO(_loc1_);
      }
      
      public function addAllMovedItems(param1:Array) : void
      {
         var _loc3_:ItemInstanceVO = null;
         var _loc4_:InventoryItemComponent = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = new InventoryItemComponent();
            _loc4_.init();
            _loc4_.itemName = _loc3_.itemInfo.graphicKey;
            _loc4_.group = _loc3_.itemInfo.group.name;
            _loc4_.itemID = _loc3_.ID;
            _loc4_.sellable = _loc3_.itemInfo.sellable;
            DragComponent.getInstance().selectedItem = _loc4_;
            this.grid.placeDroppedItemFromEquipment(_loc4_,this.currentContextFilterGroup);
            _loc2_++;
         }
         if(this.grid.currentFilter == ItemFilter.CONTEXT_FILTER)
         {
            this.filterGridAndMarkEquipedItems();
         }
         else
         {
            this.grid.fillEmptyGridSquares();
         }
         this.updateSpecificScrollbar();
      }
      
      public function setItemsEquippedToConfig(param1:Array) : void
      {
         var _loc3_:ItemInstanceVO = null;
         var _loc4_:int = 0;
         var _loc5_:InventoryItemComponent = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = 0;
            while(_loc4_ < this.grid.iconsInThisMenu.length)
            {
               _loc5_ = this.grid.iconsInThisMenu[_loc4_];
               if(_loc3_.ID == _loc5_.itemID)
               {
                  _loc5_.equippedInConfigs[Settings.activeConfig] = true;
                  _loc5_.checkEquippedStatus();
               }
               _loc4_++;
            }
            _loc2_++;
         }
         this.refreshView();
      }
      
      public function addNewItem(param1:Array) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this.grid.placeSingleItem(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      public function addToMenuItem(param1:String, param2:InventoryItemComponent, param3:AccordionButtonComponent) : void
      {
         this.grid.placeDroppedItemFromEquipment(param2,this.currentContextFilterGroup);
         param2.equippedInConfigs[Settings.activeConfig] = false;
         param2.checkEquippedStatus();
      }
      
      public function swapInventoryItems(param1:Array) : void
      {
         this.grid.gridArranger.swapItemPositions(param1[0],param1[1]);
      }
      
      public function updateUniqueItem(param1:ItemInstanceVO) : void
      {
         this.grid.updateStackQuantity(param1);
         this.refreshView();
      }
      
      public function deleteItem(param1:String) : void
      {
         this.grid.deleteItem(param1);
         this.refreshView();
      }
      
      public function replaceItemsThatAlreadyExist() : void
      {
         this.refreshView();
      }
      
      public function updateRepairedBattlestationModule(param1:String) : void
      {
         var _loc2_:ItemInstanceVO = Inventory.getInstance().getItem(param1);
         _loc2_.repairCosts = 0;
         _loc2_.hitPoints = _loc2_.maxHitPoints;
         this.grid.placeSingleItem(_loc2_);
      }
      
      private function askServerForItemSell(param1:MouseEvent) : void
      {
         if(this.dragComp.selectedItem == null || this.dragComp.selectedItem.buyableExtraSlot || this.dragComp.selectedItem.group == ItemFilter.EMPTY_SPACE_FILTER)
         {
            return;
         }
         var _loc2_:Object = new Object();
         if(this.dragComp.selectedItem.isDrone)
         {
            _loc2_.action = ActionIdentifiers.SELL_DRONE;
         }
         else
         {
            _loc2_.action = ActionIdentifiers.SELL;
         }
         _loc2_.itemId = this.dragComp.selectedItem.itemID;
         _loc2_.quantity = this.dragComp.selectedItem.quantity;
         dispatchEvent(new MoveItemEvent(MoveItemEvent.SELL_ITEM,_loc2_));
      }
      
      private function askServerForShipOrPetSell(param1:MouseEvent) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Object = this.sellShipOrPetBtn.data;
         if(_loc2_)
         {
            _loc3_ = new Object();
            _loc3_.action = _loc2_.action;
            _loc3_.itemId = _loc2_.ID;
            _loc3_.quantity = 1;
            dispatchEvent(new MoveItemEvent(MoveItemEvent.SELL_SHIP_OR_PET,_loc3_));
         }
      }
      
      private function askServerForItemRepair(param1:MouseEvent) : void
      {
         var _loc4_:String = null;
         var _loc5_:Drone = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc2_:InventoryItemComponent = this.dragComp.selectedItem;
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.buyableExtraSlot)
         {
            return;
         }
         var _loc3_:ItemInstanceVO = _loc2_.getItemInstanceData();
         if(_loc2_.isDrone)
         {
            _loc4_ = _loc2_.itemID.toString();
            _loc5_ = EquipmentManager.getInstance().drones[_loc4_];
            _loc6_ = new Object();
            _loc6_.action = ActionIdentifiers.REPAIR_DRONE;
            _loc6_.itemId = _loc2_.itemID;
            _loc6_.quantity = _loc2_.quantity;
            _loc6_.repairPrice = _loc5_.repairValue;
            _loc6_.repairCurrency = _loc5_.repairCurrency;
            _loc6_.lootId = _loc5_.lootID;
            _loc6_.droneLevel = _loc2_.droneLevel;
            dispatchEvent(new InventoryEvent(InventoryEvent.REPAIR_BUTTON_CLICKED,_loc6_));
         }
         if(_loc2_.isModule())
         {
            if(_loc3_.repairCosts > 0)
            {
               _loc7_ = new Object();
               _loc7_.repairCosts = _loc3_.repairCosts;
               _loc7_.action = ActionIdentifiers.REPAIR_MODULE;
               _loc7_.itemId = _loc2_.itemID;
               _loc7_.name = _loc3_.itemInfo.name;
               _loc7_.repairLevel = _loc3_.repairLevel;
               dispatchEvent(new InventoryEvent(InventoryEvent.REPAIR_BUTTON_CLICKED,_loc7_));
            }
         }
      }
      
      private function askServerForChangeCPUMode(param1:MouseEvent) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.action = ActionIdentifiers.CPU_MODE;
         _loc2_.itemId = this.dragComp.selectedItem.itemID;
         dispatchEvent(new InventoryEvent(InventoryEvent.CHANGE_CPU_MODE_BUTTON_CLICKED,_loc2_));
      }
      
      private function askServerForItemQuickBuy(param1:MouseEvent) : void
      {
         if(this.dragComp.selectedItem == null || this.dragComp.selectedItem.isDrone || this.dragComp.selectedItem.buyableExtraSlot)
         {
            return;
         }
         var _loc2_:Object = new Object();
         _loc2_.action = ActionIdentifiers.QUICK_BUY;
         _loc2_.itemId = this.dragComp.selectedItem.itemID;
         dispatchEvent(new MoveItemEvent(MoveItemEvent.QUICK_BUY_ITEM,_loc2_));
      }
      
      public function populateWithIcons(param1:Inventory) : void
      {
         var _loc3_:String = null;
         var _loc4_:ItemFilter = null;
         var _loc5_:Array = null;
         var _loc6_:ItemInstanceVO = null;
         var _loc2_:int = param1.getItemInHighestSlot();
         this.buildInventory(_loc2_);
         for(_loc3_ in param1.items)
         {
            _loc6_ = param1.items[_loc3_];
            this.grid.placeSingleItem(_loc6_);
         }
         _loc4_ = new ItemFilter();
         _loc5_ = _loc4_.filterBySpecificGroup(ItemFilter.EMPTY_SPACE_FILTER,this.grid.gridArranger.allIcons);
         this.grid.removeDragListeners(_loc5_);
      }
      
      private function populateInventoryScreens(param1:int) : void
      {
         if(this.grid != null)
         {
            if(contains(this.grid))
            {
               removeChild(this.grid);
            }
         }
         var _loc2_:int = this.getNumberOfInventorySlotsToCreate(param1);
         this.grid = new GridComponent(true,this);
         this.grid.injectHangarManager(this.hangarManager);
         this.grid.sectionName = this.viewID;
         this.grid.createGridMenu(_loc2_);
         this.grid.x = UILayoutProxy.INVENTORY_GRID_X;
         this.grid.y = UILayoutProxy.INVENTORY_GRID_Y;
         this.grid.addEventListener(GridEvent.FOCUSED,this.handleGridFocused);
         this.grid.addEventListener(GridEvent.UNFOCUSED,this.handleGridUnFocused);
         addChild(this.grid);
         FocusManager.getInstance().add(this.grid);
         this.currentInventoryState = MINI_MODE_INVENTORY;
      }
      
      private function getNumberOfInventorySlotsToCreate(param1:int) : int
      {
         var _loc2_:int = 4 * 24;
         if(param1 < _loc2_)
         {
            return _loc2_ * 2;
         }
         var _loc3_:Number = this.findNextInSequenceAboveValue(param1,_loc2_);
         if(param1 < _loc3_ - (_loc2_ - _loc2_ / 4))
         {
            return _loc3_;
         }
         return _loc3_ + _loc2_;
      }
      
      private function findNextInSequenceAboveValue(param1:int, param2:int) : int
      {
         var _loc3_:int = param2;
         var _loc4_:int = 1;
         while(param1 > _loc3_)
         {
            _loc3_ = param2 * _loc4_;
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function getActualCollisionRegion() : Object
      {
         return this.backgroundSprite;
      }
      
      public function getViewID() : String
      {
         return this.viewID;
      }
      
      public function getCurrentlyOpenMenu() : String
      {
         return null;
      }
      
      public function getCurrentlyActiveSection() : Dictionary
      {
         return null;
      }
   }
}

