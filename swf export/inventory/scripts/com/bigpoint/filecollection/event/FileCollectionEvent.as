package com.bigpoint.filecollection.event
{
   import flash.events.Event;
   
   public class FileCollectionEvent extends Event
   {
      
      public static const RESOURCE_FILE_LOADED:String = "FileCollectionEvent.RESOURCE_FILE_LOADED";
      
      public static const RESOURCE_FILE_NOT_FOUND:String = "FileCollectionEvent.RESOURCE_FILE_NOT_FOUND";
      
      public static const RESOURCE_FILE_SECURITY_BREACH:String = "FileCollectionEvent.RESOURCE_FILE_SECURITY_BREACH";
      
      public static const RESOURCE_FILE_FORMAT_ERROR:String = "FileCollectionEvent.RESOURCE_FILE_SECURITY_BREACH";
      
      public static const ALL_FILES_LOADED:String = "FileCollectionEvent.ALL_FILES_LOADED";
      
      public function FileCollectionEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

