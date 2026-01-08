package net.bigpoint.loginmodule.models
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class ConfigProxy extends EventDispatcher
   {
      
      private static var _instance:ConfigProxy;
      
      public static const LOADED:String = "LOADED";
      
      public static const NAME:String = "Config";
      
      public var loginUrl:String = "http://darkorbit.bigpoint.com/";
      
      public var instancesUrl:String = "instances.xml";
      
      public var urlPrefix:String = "http://";
      
      public var urlSuffix:String = "GameAPI.php";
      
      public var urlReqPrefix:String = "?req=";
      
      public var urlSignPrefix:String = "&sign=";
      
      public var urlUsernamePrefix:String = "?username=";
      
      public var urlLive:String = "darkorbit.bigpoint.com";
      
      public var timerDelay:int = 30000;
      
      public function ConfigProxy(param1:Function)
      {
         super();
         if(param1 !== hidden)
         {
            throw new Error("Config is a Singleton and can only be accessed through Config.getInstance()");
         }
         this.init();
      }
      
      public static function getInstance() : ConfigProxy
      {
         if(_instance == null)
         {
            _instance = new ConfigProxy(hidden);
         }
         return _instance;
      }
      
      private static function hidden() : void
      {
      }
      
      public function init() : void
      {
         dispatchEvent(new Event(LOADED));
      }
   }
}

