package net.bigpoint.darkorbit.equipment.view.components
{
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.events.PopUpEvent;
   import net.bigpoint.darkorbit.equipment.model.ConnectionProxy;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.model.VO.Ship;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInfoVO;
   import net.bigpoint.darkorbit.equipment.model.managers.EquipmentManager;
   import net.bigpoint.darkorbit.equipment.model.managers.ItemInfoManager;
   import net.bigpoint.darkorbit.equipment.model.transporter.PopUpDefiner;
   import net.bigpoint.darkorbit.equipment.view.components.items.PopUp;
   import net.bigpoint.dataInterchange.DataInterchange;
   import net.bigpoint.utils.TextFormatter;
   
   public class PopUpView extends Sprite
   {
      
      private var activePopUps:Array = [];
      
      private var lastActivePopUp:PopUp;
      
      public function PopUpView()
      {
         super();
      }
      
      public function cleanUpPopUp() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.activePopUps.length)
         {
            delete this.activePopUps[_loc1_];
            _loc1_++;
         }
         this.activePopUps = [];
      }
      
      public function handleRemoveOverlay(param1:PopUpEvent) : void
      {
         dispatchEvent(new PopUpEvent(PopUpEvent.REMOVE_SUSPEND_VIEW));
      }
      
      public function displaySellPopUp(param1:PopUpDefiner) : void
      {
         var _loc2_:PopUp = new PopUp(param1);
         this.lastActivePopUp = _loc2_;
         _loc2_.cleanUpCallback = this.cleanUpPopUp;
         _loc2_.changeTitleText(BPLocale.getItem("popup_sell_title"));
         _loc2_.changeDisplayText(BPLocale.getItem("popup_sell_description"));
         _loc2_.createConfirmationButtons("popConfirmBtn",BPLocale.getItem("label_button_sell_confirm"),BPLocale.getItem("tooltip_button_sell_confirm"),param1.callback);
         _loc2_.createExtraOverlay();
         _loc2_.createAmountPicker();
         _loc2_.createSaleValueDisplay();
         addChild(_loc2_);
         this.positionToolTipCentrally(_loc2_);
      }
      
      public function displaySellShipPopUp(param1:PopUpDefiner) : void
      {
         var _loc2_:PopUp = new PopUp(param1);
         this.lastActivePopUp = _loc2_;
         _loc2_.cleanUpCallback = this.cleanUpPopUp;
         _loc2_.confirmFunctionCallbackParams = param1.callbackParams;
         var _loc3_:Ship = EquipmentManager.getInstance().ship;
         var _loc4_:String = _loc3_.getShipType();
         var _loc5_:String = BPLocale.getItem("popup_sell_ship_description");
         var _loc6_:ItemInfoVO = ItemInfoManager.getInstance().getItemInfo(_loc4_);
         var _loc7_:String = _loc6_.name.toUpperCase();
         var _loc8_:int = int(_loc6_.saleValuesByLevel[0]);
         var _loc9_:String = TextFormatter.roundInteger(_loc8_).toString();
         var _loc10_:String = BPLocale.getItem("pricetag_credits_compact");
         _loc10_ = _loc10_.replace("%VALUE%",_loc9_);
         _loc5_ = _loc5_.split("%SHIP_NAME%").join(_loc7_);
         _loc5_ = _loc5_.split("%PRICE%").join(_loc10_);
         _loc2_.changeDisplayText(_loc5_,true);
         _loc2_.changeTitleText(BPLocale.getItem("popup_sell_ship_title"));
         _loc2_.createConfirmationButtons("popConfirmBtn",BPLocale.getItem("label_button_sell_ship_confirm"),BPLocale.getItem("tooltip_button_sell_ship_confirm"),param1.callback);
         addChild(_loc2_);
         this.positionToolTipCentrally(_loc2_);
      }
      
      public function displayQuickBuyItemPopUp(param1:PopUpDefiner) : void
      {
         var _loc2_:PopUp = new PopUp(param1);
         this.lastActivePopUp = _loc2_;
         _loc2_.cleanUpCallback = this.cleanUpPopUp;
         _loc2_.changeTitleText(BPLocale.getItem("popup_quick_buy_title"));
         _loc2_.changeDisplayText(BPLocale.getItem("popup_quick_buy_description"));
         _loc2_.confirmationRequiresQuantity = true;
         _loc2_.createConfirmationButtons("popConfirmBtn",BPLocale.getItem("label_button_quick_buy_confirm"),BPLocale.getItem("tooltip_button_quick_buy"),param1.callback);
         _loc2_.createAmountPicker();
         _loc2_.createSaleValueDisplay();
         addChild(_loc2_);
         this.positionToolTipCentrally(_loc2_);
      }
      
      public function displayStackSplitPopUp(param1:PopUpDefiner) : void
      {
         var _loc2_:PopUp = new PopUp(param1);
         this.lastActivePopUp = _loc2_;
         _loc2_.cleanUpCallback = this.cleanUpPopUp;
         _loc2_.changeTitleText(BPLocale.getItem("popup_split_title"));
         _loc2_.changeDisplayText(BPLocale.getItem("popup_split_description"));
         _loc2_.createConfirmationButtons("popConfirmBtn",BPLocale.getItem("label_button_split_confirm"),BPLocale.getItem("tooltip_button_split_confirm"),param1.callback);
         _loc2_.createExtraOverlay();
         _loc2_.createAmountPicker();
         addChild(_loc2_);
         this.positionToolTipCentrally(_loc2_);
      }
      
      private function positionToolTipCentrally(param1:PopUp) : void
      {
         param1.x = Math.round(Settings.WINDOW_WIDTH * 0.5 - param1.backgroundSprite.width * 0.5);
         param1.y = Math.round(Settings.WINDOW_HEIGHT * 0.5 - param1.backgroundSprite.height * 0.5);
      }
      
      public function displayBuyPetSlotPopUp(param1:PopUpDefiner) : void
      {
         var _loc2_:PopUp = new PopUp(param1);
         this.activePopUps.push(_loc2_);
         _loc2_.cleanUpCallback = this.cleanUpPopUp;
         var _loc3_:String = BPLocale.getItem("popup_buy_pet_slot_title");
         _loc2_.changeTitleText(_loc3_);
         var _loc4_:String = BPLocale.getItem("popup_buy_pet_slot_description");
         var _loc5_:uint = uint(param1.transporter.slotPrice);
         _loc2_.changeDisplayText(_loc4_.replace(/%AMOUNT%/,TextFormatter.roundInteger(_loc5_)));
         _loc2_.confirmationRequiresQuantity = false;
         _loc2_.createConfirmationButtons("popConfirmBtn",BPLocale.getItem("label_button_quick_buy_confirm").toUpperCase(),BPLocale.getItem("tooltip_button_quick_buy"),param1.callback);
         addChild(_loc2_);
         this.positionToolTipCentrally(_loc2_);
      }
      
      public function displayRepairItemPopUp(param1:PopUpDefiner) : void
      {
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc2_:PopUp = new PopUp(param1);
         this.lastActivePopUp = _loc2_;
         _loc2_.cleanUpCallback = this.cleanUpPopUp;
         _loc2_.changeTitleText(BPLocale.getItem("popup_repair_title"));
         if(Settings.DRONE_REPAIR_COST == 0 && param1.transporter.repairCurrency != DataInterchange.ITEM_CREDITS_VALUE)
         {
            _loc3_ = BPLocale.getItem("popup_repair_drone_with_vouchers");
         }
         else
         {
            _loc4_ = uint(param1.transporter.repairPrice);
            _loc5_ = param1.transporter.repairCurrency;
            _loc6_ = BPLocale.getItem("popup_repair_drone");
            _loc3_ = _loc6_.replace(/%AMOUNT%/,TextFormatter.roundInteger(_loc4_));
            _loc3_ = _loc3_.replace(/%CURRENCY%/,_loc5_);
         }
         if(param1.transporter.droneLevel > 1)
         {
            _loc3_ += "\n\n" + BPLocale.getItem("popup_repair_drone_addendum").replace(/%PREVIOUS_LEVEL%/,param1.transporter.droneLevel).replace(/%LEVEL%/,param1.transporter.droneLevel - 1);
         }
         _loc2_.changeDisplayText(_loc3_);
         _loc2_.confirmationRequiresQuantity = false;
         _loc2_.createConfirmationButtons("popConfirmBtn",BPLocale.getItem("label_button_repair"),BPLocale.getItem("label_button_repair"),param1.callback);
         addChild(_loc2_);
         this.positionToolTipCentrally(_loc2_);
      }
      
      public function displayRepairModulePopUp(param1:PopUpDefiner) : void
      {
         var _loc2_:PopUp = new PopUp(param1);
         this.lastActivePopUp = _loc2_;
         _loc2_.cleanUpCallback = this.cleanUpPopUp;
         _loc2_.changeTitleText(BPLocale.getItem("popup_repair_title"));
         var _loc3_:Object = param1.transporter;
         var _loc4_:String = BPLocale.getItem("popup_repair_module");
         _loc4_ = _loc4_.replace(/%NAME%/,_loc3_.name);
         _loc4_ = _loc4_.replace(/%AMOUNT%/,TextFormatter.roundInteger(_loc3_.repairCosts));
         _loc2_.changeDisplayText(_loc4_);
         _loc2_.confirmationRequiresQuantity = false;
         _loc2_.createConfirmationButtons("popConfirmBtn",BPLocale.getItem("label_button_repair"),BPLocale.getItem("label_button_repair"),param1.callback);
         addChild(_loc2_);
         this.positionToolTipCentrally(_loc2_);
      }
      
      public function displayChangePETNamePopUp(param1:PopUpDefiner) : void
      {
         var _loc3_:* = null;
         var _loc2_:PopUp = new PopUp(param1);
         this.lastActivePopUp = _loc2_;
         _loc2_.cleanUpCallback = this.cleanUpPopUp;
         _loc2_.changeTitleText(BPLocale.getItem("popup_edit_name_title"));
         if(param1.errorMessage)
         {
            _loc3_ = BPLocale.getItem("popup_edit_name_description") + "\n" + "(" + param1.errorMessage + ")";
         }
         else
         {
            _loc3_ = BPLocale.getItem("popup_edit_name_description");
         }
         _loc2_.changeDisplayText(_loc3_);
         _loc2_.confirmationRequiresQuantity = false;
         _loc2_.createNameInputWindow(param1.callback);
         addChild(_loc2_);
         this.positionToolTipCentrally(_loc2_);
      }
      
      public function displayChangeCPUModePopUp(param1:PopUpDefiner) : void
      {
         var _loc2_:PopUp = new PopUp(param1);
         _loc2_.cleanUpCallback = this.cleanUpPopUp;
         if(param1.transporter.cpuType == ConnectionProxy.autoBuyAmmo)
         {
            _loc2_.changeTitleText(BPLocale.getItem("popup_ammo_auto_buy_cpu_title"));
            _loc2_.changeDisplayText(BPLocale.getItem("popup_ammo_auto_buy_cpu_description"));
         }
         else if(param1.transporter.cpuType == ConnectionProxy.autoBuyRocket)
         {
            _loc2_.changeTitleText(BPLocale.getItem("popup_rocket_auto_buy_cpu_title"));
            _loc2_.changeDisplayText(BPLocale.getItem("popup_rocket_auto_buy_cpu_description"));
         }
         _loc2_.confirmationRequiresQuantity = false;
         _loc2_.createCPUSelectionWindow(param1.transporter.cpuType,param1.callback);
         addChild(_loc2_);
         this.positionToolTipCentrally(_loc2_);
      }
      
      public function displayErrorMessagePopUp(param1:PopUpDefiner) : void
      {
         var _loc2_:PopUp = new PopUp(param1);
         this.lastActivePopUp = _loc2_;
         _loc2_.cleanUpCallback = this.cleanUpPopUp;
         _loc2_.confirmFunctionCallback = param1.callback;
         _loc2_.changeTitleText(BPLocale.getItem("overlay_message_error"));
         _loc2_.changeDisplayHTMLText(param1.errorMessage);
         _loc2_.confirmationRequiresQuantity = false;
         if(param1.buttonText == null)
         {
            _loc2_.createConfirmButtonOnly();
         }
         else
         {
            _loc2_.createConfirmButtonOnly(param1.buttonText);
         }
         _loc2_.removeSuspendViewAfterClosingPopUp = true;
         _loc2_.addEventListener(PopUpEvent.REMOVE_SUSPEND_VIEW,this.handleRemoveOverlay);
         addChild(_loc2_);
         this.positionToolTipCentrally(_loc2_);
      }
      
      public function displayClearShipConfigurationPopUp(param1:PopUpDefiner) : void
      {
         var _loc2_:PopUp = new PopUp(param1);
         _loc2_.changeTitleText(BPLocale.getItem("popup_clear_config_title"));
         _loc2_.changeDisplayText(param1.errorMessage);
         _loc2_.cleanUpCallback = this.cleanUpPopUp;
         _loc2_.confirmFunctionCallback = param1.callback;
         _loc2_.confirmFunctionCallbackParams = param1.callbackParams;
         _loc2_.confirmationRequiresQuantity = false;
         _loc2_.removeSuspendViewAfterClosingPopUp = true;
         _loc2_.addEventListener(PopUpEvent.REMOVE_SUSPEND_VIEW,this.handleRemoveOverlay);
         _loc2_.createConfirmationButtons("popConfirmBtn",BPLocale.getItem("label_button_clear_config_confirm"),BPLocale.getItem("tooltip_button_clear_config_confirm"),param1.callback);
         addChild(_loc2_);
         this.positionToolTipCentrally(_loc2_);
      }
   }
}

