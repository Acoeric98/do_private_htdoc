package com.bigpoint.filecollection.finish
{
   import com.bigpoint.filecollection.vo.FileVO;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   
   public class ImageFinisher extends FileCollectionFinisher
   {
      
      private var loader:Loader;
      
      public function ImageFinisher()
      {
         super();
      }
      
      public function getBitmap() : Bitmap
      {
         return Bitmap(this.loader.content);
      }
      
      override public function start(param1:FileVO) : void
      {
         var fileVO:FileVO = param1;
         super.start(fileVO);
         try
         {
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(Event.INIT,this.handleLoaderInit);
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.handleLoadComplete);
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.handleLoaderError);
            this.loader.loadBytes(fileVO.data);
         }
         catch(e:Error)
         {
         }
      }
      
      override public function clear() : void
      {
         super.clear();
         this.loader.contentLoaderInfo.removeEventListener(Event.INIT,this.handleLoaderInit);
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.handleLoadComplete);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.handleLoaderError);
         this.loader = null;
      }
      
      private function handleLoaderInit(param1:Event) : void
      {
      }
      
      private function handleLoaderError(param1:IOErrorEvent) : void
      {
      }
      
      protected function handleLoadComplete(param1:Event) : void
      {
         fileVO.data = null;
         finish();
      }
   }
}

