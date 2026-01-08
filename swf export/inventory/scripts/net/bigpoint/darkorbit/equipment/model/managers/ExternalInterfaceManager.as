package net.bigpoint.darkorbit.equipment.model.managers
{
   import flash.external.ExternalInterface;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   
   public class ExternalInterfaceManager
   {
      
      private static var REFER_TO_URL__JS:String = "referToURL";
      
      private static var REDIRECT_TO_EXTERNALHOME__JS:String = "redirectToExternalHome";
      
      private static var REDIRECT_TO_ITEM_UPGRADE_SYSTEM__JS:String = "redirectToItemUpgradeSystem";
      
      private static var ACTIVATE_BROWSER_SCROLLING__JS:String = "allowBrowserScroll";
      
      private static var OPEN_SHOP_CATEGORY__JS:String = "openShopCategory";
      
      private static var UPDATE_MONEY__JS:String = "updateMoneyDisplay";
      
      private static var EVAL__JS:String = "eval";
      
      private static var DEEP_LINK__BUY_PET_IN_SHOP:String = "indexInternal.es?action=internalDock&tpl=internalDockPetGear";
      
      private static var DEEP_LINK__BUY_DRONES_IN_SHOP:String = "indexInternal.es?action=internalDock&tpl=internalDockDrones";
      
      private static var ALLOW_BROWSER_SCROLLING__JS_CODE:String = "var browserScrolling;function allowBrowserScroll(value){browserScrolling=value;}function handle(delta){if(!browserScrolling){return false;}return true;}function wheel(event){var delta=0;if(!event){event=window.event;}if(event.wheelDelta){delta=event.wheelDelta/120;if(window.opera){delta=-delta;}}else if(event.detail){delta=-event.detail/3;}if(delta){handle(delta);}if(!browserScrolling){if(event.preventDefault){event.preventDefault();}event.returnValue=false;}}if(window.addEventListener){window.addEventListener(\'DOMMouseScroll\',wheel,false);}window.onmousewheel=document.onmousewheel=wheel;allowBrowserScroll(true);";
      
      public function ExternalInterfaceManager()
      {
         super();
      }
      
      public static function referToPetGearsInShop() : void
      {
         var _loc1_:String = null;
         if(ExternalInterface.available)
         {
            _loc1_ = Settings.dynamicHost + DEEP_LINK__BUY_PET_IN_SHOP;
            ExternalInterface.call(REFER_TO_URL__JS,_loc1_);
         }
         else
         {
            showUnavailableExternalInterfaceErrorMessage();
         }
      }
      
      public static function referToDronesInShop() : void
      {
         var _loc1_:String = null;
         if(ExternalInterface.available)
         {
            _loc1_ = Settings.dynamicHost + DEEP_LINK__BUY_DRONES_IN_SHOP;
            ExternalInterface.call(REFER_TO_URL__JS,_loc1_);
         }
         else
         {
            showUnavailableExternalInterfaceErrorMessage();
         }
      }
      
      public static function redirectToItemUpgradeSystem() : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call(REDIRECT_TO_ITEM_UPGRADE_SYSTEM__JS);
         }
         else
         {
            showUnavailableExternalInterfaceErrorMessage();
         }
      }
      
      public static function redirectToExternalHome() : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call(REDIRECT_TO_EXTERNALHOME__JS);
         }
         else
         {
            showUnavailableExternalInterfaceErrorMessage();
         }
      }
      
      public static function openShopCategory(param1:String) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call(OPEN_SHOP_CATEGORY__JS,param1);
         }
         else
         {
            showUnavailableExternalInterfaceErrorMessage();
         }
      }
      
      public static function activateBrowserScrolling(param1:Boolean) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call(ACTIVATE_BROWSER_SCROLLING__JS,param1);
         }
         else
         {
            showUnavailableExternalInterfaceErrorMessage();
         }
      }
      
      public static function createBrowserScrollingFunctionality() : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call(EVAL__JS,ALLOW_BROWSER_SCROLLING__JS_CODE);
         }
         else
         {
            showUnavailableExternalInterfaceErrorMessage();
         }
      }
      
      public static function redirectToEquipmentClient() : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("redirectToEquipment");
         }
         else
         {
            showUnavailableExternalInterfaceErrorMessage();
         }
      }
      
      public static function updateMoneyValue(param1:String, param2:String) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call(UPDATE_MONEY__JS,param1,param2);
         }
         else
         {
            showUnavailableExternalInterfaceErrorMessage();
         }
      }
      
      private static function showUnavailableExternalInterfaceErrorMessage() : void
      {
      }
   }
}

