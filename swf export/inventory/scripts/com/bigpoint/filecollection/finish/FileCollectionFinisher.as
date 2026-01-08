package com.bigpoint.filecollection.finish
{
   import com.bigpoint.filecollection.event.FileCollectionFinishEvent;
   import com.bigpoint.filecollection.vo.FileVO;
   import flash.events.EventDispatcher;
   
   public class FileCollectionFinisher extends EventDispatcher
   {
      
      public var fileVO:FileVO;
      
      public var isFinished:Boolean = false;
      
      public function FileCollectionFinisher()
      {
         super();
      }
      
      public function start(param1:FileVO) : void
      {
         this.fileVO = param1;
      }
      
      public function clear() : void
      {
         this.fileVO.data = null;
         this.fileVO.loaded = false;
         this.isFinished = false;
      }
      
      public function finish() : void
      {
         dispatchEvent(new FileCollectionFinishEvent(FileCollectionFinishEvent.FILE_FINISH,this));
      }
   }
}

