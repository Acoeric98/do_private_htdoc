package net.bigpoint.utils
{
   import flash.utils.ByteArray;
   
   public class DebugSession
   {
      
      public static var userID:int;
      
      public static var host:String;
      
      public static var cdnHost:String;
      
      public static var lang:String;
      
      public static const DebugConfigXml:Class = DebugSession_DebugConfigXml;
      
      public static var username:String = "";
      
      public static var password:String = "";
      
      public static var employeeID:String = "";
      
      public static var projectID:String = "";
      
      public static var baseServerName:String = "";
      
      public static var instance:int = 0;
      
      public function DebugSession()
      {
         super();
      }
      
      public static function initUserSession() : void
      {
         var byteArray:ByteArray = null;
         var configXml:XML = null;
         var language:String = null;
         byteArray = new DebugConfigXml() as ByteArray;
         configXml = new XML(byteArray.readUTFBytes(byteArray.length));
         username = String(configXml.param.(@name == "user").*);
         userID = int(configXml.param.(@name == "userID").@value);
         password = String(configXml.param.(@name == "password").*);
         employeeID = String(configXml.param.(@name == "employee").@value);
         projectID = String(configXml.param.(@name == "project").@value);
         baseServerName = String(configXml.param.(@name == "server").@value);
         instance = int(configXml.param.(@name == "instance").@value);
         host = String(configXml.param.(@name == "host").@value);
         cdnHost = host;
         language = String(configXml.param.(@name == "lang").@value);
         lang = language;
      }
   }
}

