package com.bigpoint.filecollection.finish
{
   import com.bigpoint.filecollection.getDefinitionNames;
   import com.bigpoint.filecollection.vo.FileVO;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.media.Sound;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   
   public class SWFFinisher extends FileCollectionFinisher
   {
      
      protected var loader:Loader;
      
      private var readOnlyObjectCache:Dictionary = new Dictionary();
      
      public function SWFFinisher()
      {
         super();
      }
      
      override public function start(param1:FileVO) : void
      {
         var fileVO:FileVO = param1;
         super.start(fileVO);
         try
         {
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(Event.INIT,this.onInit);
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.handleLoadComplete);
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
            this.loader.loadBytes(fileVO.data);
         }
         catch(e:Error)
         {
         }
      }
      
      override public function clear() : void
      {
         super.clear();
         this.loader = null;
      }
      
      private function onInit(param1:Event) : void
      {
      }
      
      private function onError(param1:IOErrorEvent) : void
      {
      }
      
      protected function handleLoadComplete(param1:Event) : void
      {
         if(fileVO.fileNode.@debugView == "true")
         {
            this.createDebugView(this.loader.content);
         }
         fileVO.data = null;
         finish();
      }
      
      public function getDefinitions() : Array
      {
         return getDefinitionNames(this.loader.contentLoaderInfo);
      }
      
      public function getEmbededMovieClip(param1:String, param2:Boolean = false) : MovieClip
      {
         return this.getEmbededObject(param1,param2) as MovieClip;
      }
      
      public function hasEmbeddedObject(param1:String) : Boolean
      {
         var classRef:Class = null;
         var id:String = param1;
         try
         {
            classRef = this.loader.contentLoaderInfo.applicationDomain.getDefinition(id) as Class;
         }
         catch(error:Error)
         {
            return false;
         }
         return true;
      }
      
      public function getEmbededObject(param1:String, param2:Boolean = false) : Object
      {
         var cachedReadonlyObject:Object = null;
         var classRef:Class = null;
         var id:String = param1;
         var readOnly:Boolean = param2;
         if(readOnly)
         {
            cachedReadonlyObject = this.readOnlyObjectCache[id];
            if(cachedReadonlyObject != null)
            {
               return cachedReadonlyObject;
            }
         }
         try
         {
            classRef = this.loader.contentLoaderInfo.applicationDomain.getDefinition(id) as Class;
         }
         catch(error:Error)
         {
            throw new Error("embeded object \'" + id + "\' not found in \'" + fileVO.id + "\'");
         }
         if(readOnly)
         {
            cachedReadonlyObject = new classRef() as Object;
            this.readOnlyObjectCache[id] = cachedReadonlyObject;
         }
         else
         {
            cachedReadonlyObject = new classRef() as Object;
         }
         return cachedReadonlyObject;
      }
      
      public function getEmbededBitmapData(param1:String, param2:Boolean = false) : BitmapData
      {
         var cachedReadonlyObject:Object = null;
         var classRef:Class = null;
         var id:String = param1;
         var readOnly:Boolean = param2;
         if(readOnly)
         {
            cachedReadonlyObject = this.readOnlyObjectCache[id];
            if(cachedReadonlyObject != null)
            {
               return BitmapData(cachedReadonlyObject);
            }
         }
         try
         {
            classRef = this.loader.contentLoaderInfo.applicationDomain.getDefinition(id) as Class;
         }
         catch(error:Error)
         {
            throw new Error("embeded object \'" + id + "\' not found in \'" + fileVO.id + "\'");
         }
         if(readOnly)
         {
            cachedReadonlyObject = new classRef(0,0);
            this.readOnlyObjectCache[id] = cachedReadonlyObject;
         }
         else
         {
            cachedReadonlyObject = new classRef(0,0);
         }
         return BitmapData(cachedReadonlyObject);
      }
      
      public function getEmbededSound(param1:String) : Sound
      {
         var classRef:Class = null;
         var id:String = param1;
         try
         {
            classRef = this.loader.contentLoaderInfo.applicationDomain.getDefinition(id) as Class;
         }
         catch(error:Error)
         {
            throw new Error("embedded object \'" + id + "\' not found in \'" + fileVO.id + "\'");
         }
         return new classRef();
      }
      
      public function getAsDisplayObject() : DisplayObject
      {
         return this.loader.content;
      }
      
      public function getEmbededBitmap(param1:String, param2:Boolean = false) : Bitmap
      {
         return new Bitmap(this.getEmbededBitmapData(param1,param2));
      }
      
      private function createDebugView(param1:DisplayObject) : void
      {
         var _loc2_:TextField = new TextField();
         _loc2_.selectable = false;
         _loc2_.background = true;
         _loc2_.backgroundColor = 7829367;
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         _loc2_.multiline = false;
         _loc2_.text = fileVO.id + ":" + fileVO.hash;
         _loc2_.setTextFormat(new TextFormat("Verdana",10,16777215,true));
         _loc2_.y = DisplayObjectContainer(param1).height;
         DisplayObjectContainer(param1).addChild(_loc2_);
      }
   }
}

