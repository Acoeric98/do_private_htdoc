package net.bigpoint.darkorbit.equipment.model
{
   import com.bigpoint.filecollection.finish.FileCollectionFinisher;
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import flash.display.Stage;
   import flash.system.Security;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.bplocale.BPLocaleEvent;
   import net.bigpoint.as3toolbox.bplocale.parser.IBPLocaleParser;
   import net.bigpoint.darkorbit.equipment.application.ApplicationNotificationNames;
   import net.bigpoint.darkorbit.equipment.events.ActionIdentifiers;
   import net.bigpoint.darkorbit.equipment.model.VO.FileHashList;
   import net.bigpoint.darkorbit.equipment.model.VO.Ship;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInfoVO;
   import net.bigpoint.darkorbit.equipment.model.deprecated.AvatarVO;
   import net.bigpoint.darkorbit.equipment.model.managers.EquipmentManager;
   import net.bigpoint.darkorbit.equipment.model.managers.HangarManagerProxy;
   import net.bigpoint.darkorbit.equipment.model.managers.ItemInfoManager;
   import net.bigpoint.darkorbit.equipment.view.Fonts;
   import net.bigpoint.darkorbit.equipment.view.Styles;
   import net.bigpoint.utils.BPlocaleParser4Equipment;
   import net.bigpoint.utils.DebugSession;
   import net.bigpoint.utils.TextFormatter;
   import org.puremvc.as3.interfaces.IProxy;
   import org.puremvc.as3.patterns.proxy.Proxy;
   
   public class LoadDataProxy extends Proxy implements IProxy
   {
      
      public static const PROXY_NAME:String = "LoadDataProxy";
      
      public var entries:Array;
      
      private var loadedEventName:String = "Nothing";
      
      private var entry:AvatarVO;
      
      public var thumbsBmp:Array;
      
      public var assetLib:Array = [];
      
      private var neededAssetsCount:uint;
      
      private var loadingItemIndex:int = 0;
      
      public var fileHashList:FileHashList = new FileHashList();
      
      public const PRE_PATH:String = "inventory_item-icons_global_items_";
      
      public function LoadDataProxy(param1:String, param2:String)
      {
         super(param1,null);
      }
      
      public function prepareOnTheFlyIconLoading() : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc1_:ItemInfoManager = ItemInfoManager.getInstance();
         var _loc2_:Dictionary = _loc1_.items;
         for(_loc3_ in _loc2_)
         {
            _loc5_ = _loc3_.split("_");
            _loc6_ = _loc5_.pop();
            _loc4_ = "inventory_item-icons_global_items_" + _loc3_;
            if(_loc5_[0] == ActionIdentifiers.SHIP)
            {
               this.getAllShipModelInformation();
            }
            else if(_loc5_[0] == ActionIdentifiers.PET)
            {
               this.getAllPetImages(_loc4_,_loc3_);
            }
            else if(_loc5_[0] == ActionIdentifiers.DRONES && _loc5_.length < 2)
            {
               this.getAllDroneImages(_loc4_,_loc3_);
            }
            else
            {
               this.getIconImages(_loc6_);
            }
         }
      }
      
      private function getAllDroneImages(param1:String, param2:String) : void
      {
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc3_:ItemInfoManager = ItemInfoManager.getInstance();
         var _loc4_:int = 0;
         while(_loc4_ < 6)
         {
            _loc5_ = param2.split("_");
            _loc6_ = _loc5_.pop();
            _loc7_ = _loc6_ + "-" + _loc4_ + ActionIdentifiers.RES_TOP;
            _loc8_ = _loc6_ + "-" + _loc4_ + ActionIdentifiers.RES_63;
            AssetProxy.lazyGetAsset(_loc7_,this.lazyLoadCallback,this.lazyLoadCallbackError);
            AssetProxy.lazyGetAsset(_loc8_,this.lazyLoadCallback,this.lazyLoadCallbackError);
            _loc4_++;
         }
      }
      
      private function getAllPetImages(param1:String, param2:String) : void
      {
         var _loc10_:int = 0;
         var _loc11_:String = null;
         var _loc3_:ItemInfoManager = ItemInfoManager.getInstance();
         var _loc4_:EquipmentManager = EquipmentManager.getInstance();
         var _loc5_:Array = param2.split("_");
         var _loc6_:String = _loc5_.pop();
         var _loc7_:String = _loc5_.pop();
         var _loc8_:String = _loc7_ + "_" + _loc6_;
         var _loc9_:ItemInfoVO = _loc3_.getItemInfo(_loc8_);
         if(_loc4_.pet)
         {
            _loc10_ = _loc4_.pet.level;
            _loc11_ = _loc6_ + "-" + _loc10_ + ActionIdentifiers.RES_TOP;
            AssetProxy.lazyGetAsset(_loc11_,this.lazyLoadCallback,this.lazyLoadCallbackError);
         }
      }
      
      private function getIconImages(param1:String) : void
      {
         var _loc2_:String = param1 + ActionIdentifiers.RES_30;
         var _loc3_:String = param1 + ActionIdentifiers.RES_63;
         AssetProxy.lazyGetAsset(_loc2_,this.lazyLoadCallback,this.lazyLoadCallbackError);
         AssetProxy.lazyGetAsset(_loc3_,this.lazyLoadCallback,this.lazyLoadCallbackError);
      }
      
      private function getAllShipModelInformation() : void
      {
         var _loc4_:String = null;
         var _loc9_:String = null;
         var _loc10_:Array = null;
         var _loc11_:String = null;
         var _loc12_:ItemInfoVO = null;
         var _loc13_:String = null;
         var _loc14_:Dictionary = null;
         var _loc1_:EquipmentManager = EquipmentManager.getInstance();
         var _loc2_:ItemInfoManager = ItemInfoManager.getInstance();
         var _loc3_:Ship = _loc1_.ship;
         var _loc5_:* = _loc3_.availableDesignsList.length > 1;
         var _loc6_:HangarManagerProxy = facade.retrieveProxy(HangarManagerProxy.PROXY_NAME) as HangarManagerProxy;
         var _loc7_:String = _loc6_.getUserFaction();
         var _loc8_:int = 0;
         while(_loc8_ < _loc3_.availableDesignsList.length)
         {
            _loc9_ = _loc3_.availableDesignsList[_loc8_];
            _loc10_ = _loc9_.split("_");
            _loc11_ = _loc10_.pop();
            _loc4_ = "inventory_item-icons_global_items_" + _loc9_;
            _loc12_ = _loc2_.getItemInfo(_loc9_);
            if(_loc12_ != null)
            {
               _loc13_ = "";
               _loc14_ = _loc12_.cdnHashesByLevel[0];
               if(_loc14_ != null)
               {
                  if(_loc12_.factionDepended == "1")
                  {
                     _loc13_ = "-" + _loc7_;
                     _loc11_ += _loc13_;
                  }
                  AssetProxy.addFile(_loc4_ + _loc13_ + ActionIdentifiers.RES_TOP,"png",_loc14_[ActionIdentifiers.CDN_TOP],ActionIdentifiers.SHIP);
                  if(_loc5_)
                  {
                     AssetProxy.addFile(_loc4_ + _loc13_ + ActionIdentifiers.RES_63,"png",_loc14_[ActionIdentifiers.CDN_63],ActionIdentifiers.SHIP);
                  }
               }
            }
            this.getShipSpecificImages(_loc11_,_loc5_);
            _loc8_++;
         }
      }
      
      private function getShipSpecificImages(param1:String, param2:Boolean = false) : void
      {
         var _loc4_:String = null;
         var _loc3_:String = param1;
         _loc3_ += ActionIdentifiers.RES_TOP;
         AssetProxy.lazyGetAsset(_loc3_,this.lazyLoadCallback,this.lazyLoadCallbackError);
         if(param2)
         {
            _loc4_ = param1 + ActionIdentifiers.RES_63;
            AssetProxy.lazyGetAsset(_loc4_,this.lazyLoadCallback,this.lazyLoadCallbackError);
         }
      }
      
      private function lazyLoadCallback(param1:FileCollectionFinisher = null) : void
      {
      }
      
      private function lazyLoadCallbackError() : void
      {
      }
      
      public function loadImageFiles() : void
      {
         var _loc1_:Array = ["arrow_down","arrow_up","arrow_down_active","arrow_up_active","bar","bar_down","bar_top","bg"];
         this.loadingItemIndex = 0;
         this.neededAssetsCount = _loc1_.length;
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            AssetProxy.load(_loc1_[_loc3_],null);
            _loc3_++;
         }
      }
      
      public function loadAssets() : void
      {
         var _loc1_:Array = ["accordionBtn","scrollComponents","inventoryItems"];
         this.neededAssetsCount = _loc1_.length;
         var _loc2_:int = 0;
         while(_loc2_ < this.neededAssetsCount)
         {
            AssetProxy.load(_loc1_[_loc2_],this.handleAssetLoaded);
            _loc2_++;
         }
      }
      
      private function handleAssetLoaded(param1:SWFFinisher = null) : void
      {
         if(++this.loadingItemIndex == this.neededAssetsCount)
         {
            sendNotification(ApplicationNotificationNames.ASSETS_LOADED);
         }
      }
      
      public function loadLocalConfig(param1:Stage) : void
      {
         this.parseFlashVars(param1.loaderInfo.parameters);
         sendNotification(ApplicationNotificationNames.INIT_APPLICATION);
      }
      
      private function updateSettingsFromDebugSettings() : void
      {
         DebugSession.initUserSession();
         Settings.username = DebugSession.username;
         Settings.userID = DebugSession.userID;
         Settings.password = DebugSession.password;
         Settings.employeeID = DebugSession.employeeID;
         Settings.projectID = DebugSession.projectID;
         Settings.baseServerName = DebugSession.host;
         Settings.instance = DebugSession.instance;
         Settings.language = DebugSession.lang;
         Settings.baseServerName = DebugSession.baseServerName;
         Settings.cdnHost = "http://" + DebugSession.cdnHost + "/";
         Settings.dynamicHost = "http://" + DebugSession.host + "/";
      }
      
      private function parseFlashVars(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         try
         {
            for(_loc3_ in param1)
            {
               _loc2_ = param1[_loc3_];
               switch(_loc3_)
               {
                  case "lang":
                     Settings.language = _loc2_.split("_")[0];
                     break;
                  case "dynamicHost":
                     Settings.dynamicHost = "http://" + _loc2_ + "/";
                     break;
                  case "cdn":
                     Settings.cdnHost = _loc2_;
                     break;
                  case "locale_hash":
                     this.fileHashList.locale = _loc2_;
                     break;
                  case "assets_config_hash":
                     this.fileHashList.assetsConfig = _loc2_;
                     break;
                  case "items_config_hash":
                     this.fileHashList.itemsConfig = _loc2_;
                     break;
                  case "menu_layout_config_hash":
                     this.fileHashList.menuLayoutConfig = _loc2_;
                     break;
                  case "useDeviceFonts":
                     Settings.useEmbeddedFonts = _loc2_ != "1";
               }
            }
            if(Settings.useEmbeddedFonts)
            {
               Fonts.initialize();
            }
            else
            {
               Styles.useDeviceFonts();
            }
            if(Settings.cdnHost != null && Settings.cdnHost.length > 0)
            {
               Security.allowDomain(Settings.cdnHost);
            }
            else
            {
               Settings.cdnHost = Settings.dynamicHost;
            }
            Security.allowDomain(Settings.dynamicHost);
         }
         catch(error:Error)
         {
         }
      }
      
      public function initBPLocale() : void
      {
         var _loc1_:String = Settings.dynamicHost;
         var _loc2_:String = Settings.language;
         var _loc3_:String = _loc1_ + "flashinput/translationItems.php?lang=" + _loc2_;
         var _loc4_:String = _loc1_ + "flashinput/translationEquipment.php?lang=" + _loc2_;
         var _loc5_:IBPLocaleParser = new BPlocaleParser4Equipment();
         BPLocale.setParser(_loc5_);
         BPLocale.addEventListener(BPLocaleEvent.NO_LANGUAGES_LEFT_TO_LOAD,this.handleBPLocaleLanguageLoaded);
         BPLocale.addEventListener(BPLocaleEvent.LANGUAGE_LOADING_ERROR,this.handleBPLocaleLanguageLoadingError);
         BPLocale.onFailMode = BPLocale.ON_FAIL_NOTHING;
         BPLocale.load(_loc3_,_loc4_);
      }
      
      private function handleBPLocaleLanguageLoaded(param1:BPLocaleEvent) : void
      {
         TextFormatter.setNumberSeparators();
         sendNotification(ApplicationNotificationNames.BP_LOCALE_LOADED);
      }
      
      private function handleBPLocaleLanguageLoadingError(param1:BPLocaleEvent) : void
      {
      }
      
      private function handleBPLocaleKeyNotFound(param1:BPLocaleEvent) : void
      {
      }
      
      private function handleBPLocaleCategoryNotFound(param1:BPLocaleEvent) : void
      {
      }
   }
}

