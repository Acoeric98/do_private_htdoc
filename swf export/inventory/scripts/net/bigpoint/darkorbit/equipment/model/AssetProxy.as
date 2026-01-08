package net.bigpoint.darkorbit.equipment.model
{
   import com.bigpoint.filecollection.FileCollection;
   import com.bigpoint.filecollection.event.FileCollectionEvent;
   import com.bigpoint.filecollection.finish.FileCollectionFinisher;
   import com.bigpoint.filecollection.finish.ImageFinisher;
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.lazyload.LazyLoadVO;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.media.Sound;
   import net.bigpoint.darkorbit.equipment.application.ApplicationNotificationNames;
   import org.puremvc.as3.interfaces.IProxy;
   import org.puremvc.as3.patterns.proxy.Proxy;
   
   public class AssetProxy extends Proxy implements IProxy
   {
      
      public static var regularFileCollection:FileCollection;
      
      public static var itemAssetFileCollection:FileCollection;
      
      public static const PROXY_NAME:String = "AssetProxy";
      
      private static const NEEDED_RESOURCE_COUNT:int = 2;
      
      private static var resourcesLoadCounter:int = 0;
      
      private static var lazyLoaderObjects:Array = [];
      
      private static var itemAssetlazyLoaderObjects:Array = [];
      
      public function AssetProxy(param1:String = null)
      {
         super(param1,null);
      }
      
      public static function getMovieClip(param1:String, param2:String) : MovieClip
      {
         if(SWFFinisher(regularFileCollection.getFinisher(param1)).hasEmbeddedObject(param2))
         {
            return SWFFinisher(regularFileCollection.getFinisher(param1)).getEmbededMovieClip(param2);
         }
         return null;
      }
      
      public static function getBitmap(param1:String, param2:String) : Bitmap
      {
         return SWFFinisher(regularFileCollection.getFinisher(param1)).getEmbededBitmap(param2);
      }
      
      public static function getBitmapData(param1:String, param2:String) : BitmapData
      {
         return SWFFinisher(regularFileCollection.getFinisher(param1)).getEmbededBitmapData(param2);
      }
      
      public static function getSound(param1:String, param2:String) : Sound
      {
         if(SWFFinisher(regularFileCollection.getFinisher(param1)).hasEmbeddedObject(param2))
         {
            return SWFFinisher(regularFileCollection.getFinisher(param1)).getEmbededSound(param2);
         }
         return null;
      }
      
      public static function getImage(param1:String) : DisplayObject
      {
         var _loc2_:FileCollectionFinisher = null;
         _loc2_ = regularFileCollection.getFinisher(param1);
         if(_loc2_ != null)
         {
            return ImageFinisher(_loc2_).getBitmap();
         }
         _loc2_ = itemAssetFileCollection.getFinisher(param1);
         if(_loc2_ != null)
         {
            return ImageFinisher(_loc2_).getBitmap();
         }
         return null;
      }
      
      public static function lazyGetAsset(param1:String, param2:Function, param3:Function, param4:Boolean = true) : void
      {
         var _loc6_:LazyLoadVO = null;
         if(regularFileCollection.isLoaded(param1))
         {
            param2(regularFileCollection.getFinisher(param1));
            return;
         }
         if(itemAssetFileCollection.isLoaded(param1))
         {
            param2(itemAssetFileCollection.getFinisher(param1));
            return;
         }
         var _loc5_:LazyLoadVO = lazyLoaderObjects[param1] as LazyLoadVO;
         if(_loc5_ != null)
         {
            _loc5_.addCompleteCallback(param2);
            _loc5_.addErrorCallback(param3);
         }
         else
         {
            _loc6_ = new LazyLoadVO(param1,param2,param3,param4);
            _loc6_.load();
            lazyLoaderObjects[param1] = _loc6_;
         }
      }
      
      public static function addFile(param1:String, param2:String, param3:String = "", param4:String = "item") : void
      {
         regularFileCollection.addFile(param1,param2,param3,param4);
      }
      
      public static function isLoaded(param1:String, param2:Boolean = false) : Boolean
      {
         if(param2)
         {
            return itemAssetFileCollection.isLoaded(param1);
         }
         return regularFileCollection.isLoaded(param1);
      }
      
      public static function load(param1:String, param2:Function, param3:Boolean = false) : void
      {
         if(param3)
         {
            itemAssetFileCollection.load(param1,param2);
         }
         else
         {
            regularFileCollection.load(param1,param2);
         }
      }
      
      public function init() : void
      {
         resourcesLoadCounter = 0;
         this.initializeReqgularFileCollection();
         this.initializeItemAssetFileCollection();
      }
      
      private function initializeReqgularFileCollection() : void
      {
         regularFileCollection = new FileCollection();
         regularFileCollection.addEventListener(FileCollectionEvent.RESOURCE_FILE_LOADED,this.handleConfigXMLLoaded);
         var _loc1_:String = "";
         var _loc2_:String = "";
         _loc1_ = Settings.cdnHost;
         _loc2_ = "swf_global/inventory/";
         regularFileCollection.host = _loc1_ + _loc2_;
         var _loc3_:LoadDataProxy = facade.retrieveProxy(LoadDataProxy.PROXY_NAME) as LoadDataProxy;
         var _loc4_:String = Settings.cdnHost + "/swf_global/inventory/xml/assets.xml?__cv=" + _loc3_.fileHashList.assetsConfig;
         regularFileCollection.loadResourceFile(_loc4_);
      }
      
      private function initializeItemAssetFileCollection() : void
      {
         itemAssetFileCollection = new FileCollection();
         itemAssetFileCollection.addEventListener(FileCollectionEvent.RESOURCE_FILE_LOADED,this.handleConfigXMLLoaded);
         var _loc1_:String = "";
         var _loc2_:String = "";
         _loc1_ = Settings.cdnHost;
         _loc2_ = "do_img/global/";
         var _loc3_:String = _loc1_ + _loc2_;
         var _loc4_:LoadDataProxy = facade.retrieveProxy(LoadDataProxy.PROXY_NAME) as LoadDataProxy;
         var _loc5_:String = _loc1_ + _loc2_ + "xml/resource_items.xml?__cv=" + _loc4_.fileHashList.itemsConfig;
         itemAssetFileCollection.host = _loc3_;
         itemAssetFileCollection.loadResourceFile(_loc5_);
      }
      
      private function handleConfigXMLLoaded(param1:FileCollectionEvent) : void
      {
         ++resourcesLoadCounter;
         if(resourcesLoadCounter == NEEDED_RESOURCE_COUNT)
         {
            sendNotification(ApplicationNotificationNames.ASSET_CONFIG_DEFINED);
            AssetProxy.lazyGetAsset("loadGfx",this.handleLoadingGraphicsLoaded,this.handleLoadingGraphicsError,false);
         }
      }
      
      private function handleLoadingGraphicsLoaded(param1:FileCollectionFinisher = null) : void
      {
         sendNotification(ApplicationNotificationNames.SHOW_LOAD_SCREEN_ON_INIT);
      }
      
      private function handleLoadingGraphicsError() : void
      {
      }
   }
}

