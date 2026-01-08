package com.bigpoint.filecollection
{
   import com.bigpoint.filecollection.event.FileCollectionEvent;
   import com.bigpoint.filecollection.event.FileCollectionFileLoadEvent;
   import com.bigpoint.filecollection.event.FileCollectionFinishEvent;
   import com.bigpoint.filecollection.finish.FileCollectionFinisher;
   import com.bigpoint.filecollection.finish.ImageFinisher;
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.filecollection.finish.XMLFinisher;
   import com.bigpoint.filecollection.vo.FileVO;
   import com.bigpoint.filecollection.vo.LoadVO;
   import com.bigpoint.filecollection.vo.LocationVO;
   import com.greensock.TweenMax;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.getDefinitionByName;
   import net.bigpoint.darkorbit.equipment.events.ActionIdentifiers;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   
   public class FileCollection extends EventDispatcher
   {
      
      public static var logging:Boolean = false;
      
      private var xmlLoader:URLLoader;
      
      private var xml:XML;
      
      private var paramKeyList:Object;
      
      private var locationList:Object;
      
      private var fileList:Object;
      
      private var queueSize:int;
      
      private var finisherClassList:Object;
      
      private var finisherList:Object;
      
      private var fileLoaderList:Object;
      
      private var _numOfFiles:int;
      
      private var _numOfFilesLoaded:int;
      
      private var _filePrefix:String = "";
      
      private var _linearLoadList:Array = [];
      
      private var _currentLinearLoad:LoadVO;
      
      public var host:String = "";
      
      public function FileCollection()
      {
         super();
         this.paramKeyList = new Object();
         this.locationList = new Object();
         this.fileList = new Object();
         this.fileLoaderList = new Object();
         this.finisherList = new Object();
         this.finisherClassList = new Object();
         this.queueSize = 0;
         this._numOfFilesLoaded = 0;
         this._numOfFiles = 0;
         this.addDefaultFinisherClasses();
      }
      
      private function addDefaultFinisherClasses() : void
      {
         this.addFinisherClass("swf",SWFFinisher);
         this.addFinisherClass("xml",XMLFinisher);
         this.addFinisherClass("png",ImageFinisher);
      }
      
      public function addFinisherClass(param1:String, param2:Class) : void
      {
         this.finisherClassList[param1] = param2;
      }
      
      public function loadResourceFile(param1:String) : void
      {
         this.xmlLoader = new URLLoader();
         this.xmlLoader.dataFormat = URLLoaderDataFormat.TEXT;
         this.xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.handleIOError);
         this.xmlLoader.addEventListener(Event.COMPLETE,this.handleXMLLoad);
         this.xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleXMLSecurityError);
         this.xmlLoader.load(new URLRequest(param1));
      }
      
      private function handleXMLLoad(param1:Event) : void
      {
         var xmlData:String = null;
         var event:Event = param1;
         try
         {
            xmlData = event.target.data;
            this.xml = new XML(this.preParseXML(xmlData));
            this.extractLocationsFromXML();
            this.extractFilesFromXML();
            this.xml = undefined;
         }
         catch(e:TypeError)
         {
            dispatchEvent(new FileCollectionEvent(FileCollectionEvent.RESOURCE_FILE_FORMAT_ERROR));
            return;
         }
         dispatchEvent(new FileCollectionEvent(FileCollectionEvent.RESOURCE_FILE_LOADED));
      }
      
      private function extractLocationsFromXML() : void
      {
         var _loc1_:XML = null;
         for each(_loc1_ in this.xml.location)
         {
            this.locationList[_loc1_.@id] = new LocationVO(_loc1_.@id,this.host + this._filePrefix + _loc1_.@path);
         }
      }
      
      private function extractFilesFromXML() : void
      {
         var _loc1_:XML = null;
         var _loc2_:String = null;
         for each(_loc1_ in this.xml.file)
         {
            ++this._numOfFiles;
            _loc2_ = _loc1_.@id;
            this.fileList[_loc2_] = new FileVO(_loc1_.@id,this.locationList[_loc1_.@location],_loc1_.@name,_loc1_.@type,_loc1_);
            this.fileList[_loc2_].hash = _loc1_.@hash;
         }
      }
      
      public function addFile(param1:String, param2:String, param3:String = "", param4:String = "item") : void
      {
         var _loc5_:Array = param1.split("_");
         var _loc6_:String = _loc5_.pop();
         var _loc7_:String = _loc5_.pop();
         var _loc8_:String = _loc5_.join("_");
         var _loc9_:* = _loc5_.join("/") + "/";
         _loc9_ = Settings.cdnHost + "/swf_global/" + _loc9_;
         this.locationList[_loc8_] = new LocationVO(_loc8_,this._filePrefix + _loc9_);
         var _loc10_:String = _loc7_ + "_" + _loc6_;
         this.fileList[_loc10_] = new FileVO(_loc10_,this.locationList[_loc8_],_loc10_,param2,new XML());
         this.fileList[_loc10_].hash = param3;
      }
      
      private function addAllImagesForPET(param1:String, param2:String, param3:String, param4:String) : void
      {
         var _loc5_:String = param1 + ActionIdentifiers.RES_TOP;
         this.fileList[_loc5_] = new FileVO(_loc5_,this.locationList[param3],_loc5_,param4,new XML());
         this.fileList[_loc5_].hash = param2;
      }
      
      private function addAllImagesForDrones(param1:String, param2:String, param3:String, param4:String) : void
      {
         var _loc5_:String = param1 + ActionIdentifiers.RES_TOP;
         var _loc6_:String = param1 + ActionIdentifiers.RES_63;
         this.fileList[_loc5_] = new FileVO(_loc5_,this.locationList[param3],_loc5_,param4,new XML());
         this.fileList[_loc5_].hash = param2;
         this.fileList[_loc6_] = new FileVO(_loc6_,this.locationList[param3],_loc6_,param4,new XML());
         this.fileList[_loc6_].hash = param2;
      }
      
      private function addAllResolutionForIcons(param1:String, param2:String, param3:String, param4:String) : void
      {
         var _loc5_:String = param1 + ActionIdentifiers.RES_30;
         var _loc6_:String = param1 + ActionIdentifiers.RES_63;
         var _loc7_:String = param1 + ActionIdentifiers.RES_100;
         this.fileList[_loc5_] = new FileVO(_loc5_,this.locationList[param3],_loc5_,param4,new XML());
         this.fileList[_loc5_].hash = param2;
         this.fileList[_loc6_] = new FileVO(_loc6_,this.locationList[param3],_loc6_,param4,new XML());
         this.fileList[_loc6_].hash = param2;
         this.fileList[_loc7_] = new FileVO(_loc7_,this.locationList[param3],_loc7_,param4,new XML());
         this.fileList[_loc7_].hash = param2;
      }
      
      private function addAllImagesForShips(param1:String, param2:String, param3:String, param4:String) : void
      {
         var _loc5_:String = param1 + ActionIdentifiers.RES_TOP;
         var _loc6_:String = param1 + ActionIdentifiers.RES_63;
         this.fileList[_loc5_] = new FileVO(_loc5_,this.locationList[param3],_loc5_,param4,new XML());
         this.fileList[_loc5_].hash = param2;
         this.fileList[_loc6_] = new FileVO(_loc6_,this.locationList[param3],_loc6_,param4,new XML());
         this.fileList[_loc6_].hash = param2;
      }
      
      private function preParseXML(param1:String) : String
      {
         var _loc3_:String = null;
         var _loc4_:RegExp = null;
         var _loc2_:String = param1;
         for(_loc3_ in this.paramKeyList)
         {
            _loc4_ = new RegExp("%" + _loc3_ + "%","sg");
            _loc2_ = _loc2_.replace(_loc4_,this.paramKeyList[_loc3_]);
         }
         return _loc2_;
      }
      
      private function handleIOError(param1:IOErrorEvent) : void
      {
         dispatchEvent(new FileCollectionEvent(FileCollectionEvent.RESOURCE_FILE_NOT_FOUND));
      }
      
      private function handleXMLSecurityError(param1:SecurityErrorEvent) : void
      {
         dispatchEvent(new FileCollectionEvent(FileCollectionEvent.RESOURCE_FILE_SECURITY_BREACH));
      }
      
      public function clearCollection() : void
      {
         this.fileList = new Object();
         this.locationList = new Object();
         this.paramKeyList = new Object();
         this.queueSize = 0;
         this.xml = undefined;
      }
      
      public function load(param1:String = null, param2:Function = null, param3:Function = null) : void
      {
         var fileNode:FileVO = null;
         var fileLoader:FileCollectionLoader = null;
         var key:String = param1;
         var callbackComplete:Function = param2;
         var callbackError:Function = param3;
         try
         {
            if(key == null)
            {
               return;
            }
            fileNode = this.fileList[key];
            if(fileNode == null)
            {
               throw new Error("filecollection filenode not found " + key);
            }
            if(this.finisherList[key] != null && FileCollectionFinisher(this.finisherList[key]).isFinished == true)
            {
               if(callbackComplete != null)
               {
                  callbackComplete(this.finisherList[key]);
               }
               return;
            }
            fileNode.callbackComplete = callbackComplete;
            fileNode.callbackError = callbackError;
            if(this.fileLoaderList[key] != null)
            {
               FileCollectionLoader(this.fileLoaderList[key]).loadFile();
               return;
            }
            fileLoader = new FileCollectionLoader(fileNode);
            fileLoader.addEventListener(Event.COMPLETE,this.handleFileLoad);
            fileLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.httpStatusHandler);
            fileLoader.addEventListener(IOErrorEvent.IO_ERROR,this.handleFileLoadError);
            fileLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
            fileLoader.dataFormat = URLLoaderDataFormat.BINARY;
            this.fileLoaderList[key] = fileLoader;
            fileLoader.loadFile();
            ++this.queueSize;
         }
         catch(e:Error)
         {
         }
      }
      
      private function httpStatusHandler(param1:HTTPStatusEvent) : void
      {
         var _loc2_:FileVO = FileCollectionLoader(param1.target).getFileVO();
         if(param1.status == 404)
         {
         }
      }
      
      private function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
      }
      
      private function handleFileLoad(param1:Event) : void
      {
         var _loc3_:FileCollectionFinisher = null;
         var _loc2_:FileVO = FileCollectionLoader(param1.target).getFileVO();
         _loc2_.data = FileCollectionLoader(param1.target).data;
         _loc3_ = new this.finisherClassList[_loc2_.type]();
         this.addFinisher(_loc2_.id,_loc3_);
         _loc3_.addEventListener(FileCollectionFinishEvent.FILE_FINISH,this.handleFileFinish);
         _loc3_.start(_loc2_);
      }
      
      private function handleFileFinish(param1:FileCollectionFinishEvent) : void
      {
         var _loc2_:FileVO = param1.finisher.fileVO;
         _loc2_.loaded = true;
         param1.finisher.isFinished = true;
         ++this._numOfFilesLoaded;
         dispatchEvent(new FileCollectionFileLoadEvent(FileCollectionFileLoadEvent.FILE_LOADED,_loc2_));
         if(_loc2_.callbackComplete != null)
         {
            _loc2_.callbackComplete(param1.finisher);
         }
         this._currentLinearLoad = null;
         if(--this.queueSize <= 0)
         {
            if(this._linearLoadList.length == 0)
            {
               dispatchEvent(new FileCollectionEvent(FileCollectionEvent.ALL_FILES_LOADED));
            }
            else
            {
               this.load();
            }
         }
      }
      
      private function addFinisher(param1:String, param2:FileCollectionFinisher) : void
      {
         this.finisherList[param1] = param2;
      }
      
      private function handleFileLoadError(param1:IOErrorEvent) : void
      {
         var _loc2_:FileVO = FileCollectionLoader(param1.target).getFileVO();
         ++_loc2_.retries;
         if(_loc2_.retries < 4)
         {
            TweenMax.delayedCall(4,this.load,[_loc2_.id,_loc2_.callbackComplete,_loc2_.callbackError]);
         }
      }
      
      public function loadAll() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in this.fileList)
         {
            this.load(FileVO(this.fileList[_loc1_]).id);
         }
      }
      
      public function setParam(param1:String, param2:String) : void
      {
         this.paramKeyList[param1] = param2;
      }
      
      public function isLoaded(param1:String) : Boolean
      {
         var result:Boolean = false;
         var id:String = param1;
         try
         {
            result = FileCollectionFinisher(this.finisherList[id]).isFinished;
         }
         catch(e:Error)
         {
            return false;
         }
         return result;
      }
      
      public function getFinisher(param1:String) : FileCollectionFinisher
      {
         return this.finisherList[param1];
      }
      
      public function get numOfFiles() : int
      {
         return this._numOfFiles;
      }
      
      public function get numOfFilesLoaded() : int
      {
         return this._numOfFilesLoaded;
      }
      
      public function get filePrefix() : String
      {
         return this._filePrefix;
      }
      
      public function set filePrefix(param1:String) : void
      {
         this._filePrefix = param1;
      }
      
      public function get byteLoaded() : int
      {
         var _loc2_:FileCollectionLoader = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.fileLoaderList)
         {
            _loc1_ += _loc2_.bytesLoaded;
         }
         return _loc1_;
      }
   }
}

