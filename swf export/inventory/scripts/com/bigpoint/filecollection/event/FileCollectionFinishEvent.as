package com.bigpoint.filecollection.event
{
   import com.bigpoint.filecollection.finish.FileCollectionFinisher;
   import flash.events.Event;
   
   public class FileCollectionFinishEvent extends Event
   {
      
      public static const FILE_FINISH:String = "FileCollectionFinishEvent.FILE_FINISH";
      
      public var finisher:FileCollectionFinisher;
      
      public function FileCollectionFinishEvent(param1:String, param2:FileCollectionFinisher)
      {
         this.finisher = param2;
         super(param1,false,false);
      }
   }
}

