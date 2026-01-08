package com.bigpoint.filecollection.vo
{
   public class FileVO
   {
      
      public var id:String;
      
      public var location:LocationVO;
      
      public var name:String;
      
      public var type:String;
      
      public var hash:String;
      
      public var loaded:Boolean;
      
      public var data:*;
      
      public var fileNode:XML;
      
      public var callbackComplete:Function;
      
      public var callbackError:Function;
      
      public var params:Object;
      
      public var retries:uint = 0;
      
      public function FileVO(param1:String, param2:LocationVO, param3:String, param4:String, param5:XML)
      {
         super();
         this.loaded = false;
         this.id = param1;
         this.location = param2;
         this.name = param3;
         this.type = param4;
         this.fileNode = param5;
      }
      
      public function getFileName() : String
      {
         return this.location.path + this.name + "." + this.type + "?__cv=" + this.hash;
      }
      
      private function extractParams() : void
      {
         var _loc1_:XML = null;
         this.params = new Object();
         for each(_loc1_ in this.fileNode.param)
         {
            this.params[_loc1_.@name] = _loc1_.@value;
         }
      }
   }
}

