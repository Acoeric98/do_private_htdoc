package net.bigpoint.loginmodule.models
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.utils.Timer;
   import net.bigpoint.loginmodule.LoginModule;
   import net.bigpoint.loginmodule.models.vo.AccountVO;
   import net.bigpoint.loginmodule.models.vo.HashVO;
   import net.bigpoint.loginmodule.models.vo.InstanceVO;
   import net.bigpoint.shared.util.Base64;
   
   public class HashesProxy extends EventDispatcher
   {
      
      private static var _instance:HashesProxy;
      
      public static const HASHES_LOADED:String = "HASHES_LOADED";
      
      public static const SESSION_LOADED:String = "SESSION_LOADED";
      
      public static const NAME:String = "Hash";
      
      public var testmode:Boolean = false;
      
      public var loginLoader:URLLoader = new URLLoader();
      
      public var sessionLoader:URLLoader = new URLLoader();
      
      public var request:URLRequest;
      
      public var loginDataStr:String;
      
      public var loginDataXml:XML;
      
      public var sessionDataStr:String;
      
      public var accountIndexes:Vector.<int> = new Vector.<int>();
      
      public var currentAccountIndex:int;
      
      public var hashes:Vector.<HashVO>;
      
      public var delay:uint;
      
      public var repeat:uint;
      
      public function HashesProxy(param1:Function)
      {
         super();
         if(param1 !== hidden)
         {
            throw new Error("Hash is a Singleton and can only be accessed through Hash.getInstance()");
         }
         this.init();
      }
      
      public static function getInstance() : HashesProxy
      {
         if(_instance == null)
         {
            _instance = new HashesProxy(hidden);
         }
         return _instance;
      }
      
      private static function hidden() : void
      {
      }
      
      public function init() : void
      {
         this.hashes = new Vector.<HashVO>();
      }
      
      public function startTimer() : void
      {
         var _loc1_:ConfigProxy = ConfigProxy.getInstance();
         this.delay = _loc1_.timerDelay;
         this.repeat = 0;
         var _loc2_:Timer = new Timer(this.delay,this.repeat);
         _loc2_.addEventListener("timer",this.handleTimerEvent);
         this.loadHashes();
         _loc2_.start();
      }
      
      private function handleTimerEvent(param1:TimerEvent) : void
      {
         this.loadHashes();
      }
      
      public function loadHashes() : void
      {
         var _loc1_:AccountsProxy = AccountsProxy.getInstance();
         while(this.accountIndexes.length > 0)
         {
            this.accountIndexes.pop();
         }
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.accounts.length)
         {
            this.accountIndexes.push(_loc2_);
            _loc2_++;
         }
         this.loadNextAccountHashes();
      }
      
      public function loadNextAccountHashes() : void
      {
         var _loc1_:int = 0;
         if(this.accountIndexes.length > 0)
         {
            _loc1_ = int(this.accountIndexes.pop());
            this.currentAccountIndex = _loc1_;
            this.loadHashesByAccountIndex(_loc1_);
         }
         else
         {
            dispatchEvent(new Event(HASHES_LOADED));
         }
      }
      
      public function loadHashesByAccountIndex(param1:int) : void
      {
         var _loc4_:URLVariables = null;
         var _loc5_:AccountVO = null;
         if(this.loginLoader.hasEventListener(Event.COMPLETE))
         {
            this.loginLoader.close();
            this.loginLoader.removeEventListener(Event.COMPLETE,this.handleLoginLoaderComplete);
         }
         var _loc2_:ConfigProxy = ConfigProxy.getInstance();
         var _loc3_:AccountsProxy = AccountsProxy.getInstance();
         this.loginLoader.dataFormat = URLLoaderDataFormat.TEXT;
         this.loginLoader.addEventListener(Event.COMPLETE,this.handleLoginLoaderComplete);
         if(!this.testmode)
         {
            this.request = new URLRequest(_loc2_.loginUrl);
            this.request.method = URLRequestMethod.POST;
            _loc4_ = new URLVariables();
            _loc4_.loginForm_default_login_submit = "Login";
            _loc5_ = _loc3_.getAccountByIndex(param1);
            _loc4_.loginForm_default_username = _loc5_.username;
            _loc4_.loginForm_default_password = Base64.decode(_loc5_.password);
            _loc4_.lang = "en";
            this.request.data = _loc4_;
         }
         else
         {
            this.request = new URLRequest("logindata_new.html");
         }
         this.loginLoader.load(this.request);
      }
      
      private function handleLoginLoaderComplete(param1:Event = null) : void
      {
         var pattern:RegExp = null;
         var index:int = 0;
         var s1:String = null;
         var s2:String = null;
         var e:Event = param1;
         this.loginLoader.removeEventListener(Event.COMPLETE,this.handleLoginLoaderComplete);
         this.loginDataStr = this.loginLoader.data;
         pattern = /<div id=\"rahmen\">/;
         index = int(this.loginDataStr.search(pattern));
         if(index != -1)
         {
            s1 = this.loginDataStr.substring(index,this.loginDataStr.length);
            pattern = /<div id=\"chooseInstanceFooter\">/;
            index = int(s1.search(pattern));
            if(index != -1)
            {
               s2 = s1.substring(0,index);
               try
               {
                  this.loginDataXml = new XML(s2);
               }
               catch(e:TypeError)
               {
                  throw new Error("Could not convert received data to XML. " + e.message);
               }
               this.updateHashes();
               this.loadNextAccountHashes();
               return;
            }
            throw new Error("Error while parsing received login data. Please check username and password.");
         }
         throw new Error("Error while parsing received login data. Please check username and password.");
      }
      
      private function updateHashes() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:HashVO = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:RegExp = null;
         var _loc8_:int = 0;
         var _loc9_:XML = null;
         var _loc1_:InstancesProxy = InstancesProxy.getInstance();
         for each(_loc9_ in this.loginDataXml.div.div)
         {
            _loc5_ = String(_loc9_.@id);
            _loc7_ = /instance_/;
            _loc5_ = _loc5_.replace(_loc7_,"");
            _loc6_ = int(_loc5_);
            if(_loc6_ > 0)
            {
               _loc4_ = this.getHash(_loc6_,this.currentAccountIndex);
               if(_loc4_)
               {
                  _loc2_ = this.getSign(_loc9_);
                  if(_loc2_ != "error")
                  {
                     _loc4_.sign = _loc2_;
                  }
                  _loc3_ = this.getReq(_loc9_);
                  if(_loc3_ != "error")
                  {
                     _loc4_.req = _loc3_;
                  }
               }
            }
         }
      }
      
      private function getReq(param1:String) : String
      {
         var _loc2_:RegExp = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         _loc2_ = /GameAPI.php\?req=/;
         _loc3_ = int(param1.search(_loc2_));
         if(_loc3_ != -1)
         {
            _loc4_ = param1.substring(_loc3_ + 16,param1.length);
            _loc2_ = /&amp;sign=/;
            _loc3_ = int(_loc4_.search(_loc2_));
            if(_loc3_ != -1)
            {
               _loc5_ = _loc4_.substring(0,_loc3_);
               if(_loc5_ != "")
               {
                  return _loc5_;
               }
               throw new Error("error while parsing for req hash");
            }
            throw new Error("error while parsing for req hash");
         }
         throw new Error("error while parsing for req hash");
      }
      
      private function getSign(param1:String) : String
      {
         var _loc2_:RegExp = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         _loc2_ = /&amp;sign=/;
         _loc3_ = int(param1.search(_loc2_));
         if(_loc3_ != -1)
         {
            _loc4_ = param1.substring(_loc3_ + 10,param1.length);
            _loc2_ = /&amp;lang=/;
            _loc3_ = int(_loc4_.search(_loc2_));
            if(_loc3_ != -1)
            {
               _loc5_ = _loc4_.substring(0,_loc3_);
               if(_loc5_ != "")
               {
                  return _loc5_;
               }
               throw new Error("error while parsing for sign hash");
            }
            throw new Error("error while parsing for sign hash");
         }
         throw new Error("error while parsing for sign hash");
      }
      
      public function addHash(param1:int, param2:int) : Boolean
      {
         var _loc3_:HashVO = null;
         if(param1 >= 0 && param2 >= 0)
         {
            _loc3_ = new HashVO(param1,param2);
            this.hashes.push(_loc3_);
            return true;
         }
         return false;
      }
      
      public function getHash(param1:int, param2:int) : HashVO
      {
         var _loc3_:HashVO = null;
         var _loc4_:HashVO = null;
         for each(_loc4_ in this.hashes)
         {
            if(_loc4_.instance_id == param1 && _loc4_.account_id == param2)
            {
               _loc3_ = _loc4_;
               break;
            }
         }
         return _loc3_;
      }
      
      public function getLoginUrl(param1:String = "DEV") : String
      {
         var _loc7_:HashVO = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc2_:InstancesProxy = InstancesProxy.getInstance();
         var _loc3_:AccountsProxy = AccountsProxy.getInstance();
         var _loc4_:ConfigProxy = ConfigProxy.getInstance();
         var _loc5_:InstanceVO = _loc2_.getSelectedInstance();
         var _loc6_:AccountVO = _loc3_.getSelectedAccount();
         if(Boolean(_loc5_) && Boolean(_loc6_))
         {
            _loc7_ = this.getHash(_loc5_.id,_loc3_.selectedAccountIndex);
            if(param1 == LoginModule.SERVER_MODE_DEVELOPMENT || _loc7_ && _loc7_.req != "" && _loc7_.sign != "")
            {
               switch(param1)
               {
                  case LoginModule.SERVER_MODE_LIVE:
                     _loc8_ = "" + _loc4_.urlPrefix + _loc5_.name + "." + _loc4_.urlLive + "/" + _loc4_.urlSuffix + _loc4_.urlReqPrefix + _loc7_.req + _loc4_.urlSignPrefix + _loc7_.sign;
                     break;
                  default:
                     _loc8_ = "" + _loc4_.urlPrefix + _loc6_.bp_username + "-" + _loc6_.checkout + "%instanceIDSuffix%" + "." + _loc6_.machine + "/" + _loc4_.urlSuffix + _loc4_.urlUsernamePrefix + _loc6_.username;
                     _loc9_ = "";
                     if(_loc5_.id != 22)
                     {
                        _loc9_ = "-" + _loc5_.id;
                     }
                     _loc8_ = _loc8_.replace(/%instanceIDSuffix%/,_loc9_);
               }
               trace("HashesProxy->getLoginUrl",_loc8_);
               return _loc8_;
            }
            throw new Error("no req and/or sign hash set at the moment!");
         }
         throw new Error("no instance and/or account selected!");
      }
      
      public function loadSession(param1:String = "DEV") : void
      {
         var _loc4_:String = null;
         if(this.sessionLoader.hasEventListener(Event.COMPLETE))
         {
            this.sessionLoader.close();
            this.sessionLoader.removeEventListener(Event.COMPLETE,this.handleSessionLoaderComplete);
         }
         var _loc2_:ConfigProxy = ConfigProxy.getInstance();
         var _loc3_:AccountsProxy = AccountsProxy.getInstance();
         this.sessionLoader.dataFormat = URLLoaderDataFormat.TEXT;
         this.sessionLoader.addEventListener(Event.COMPLETE,this.handleSessionLoaderComplete);
         if(!this.testmode)
         {
            _loc4_ = this.getLoginUrl(param1);
            this.request = new URLRequest(_loc4_);
            this.request.method = URLRequestMethod.GET;
         }
         else
         {
            this.request = new URLRequest("sessiondata_new.html");
         }
         this.sessionLoader.load(this.request);
      }
      
      private function handleSessionLoaderComplete(param1:Event = null) : void
      {
         var _loc2_:RegExp = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         this.sessionLoader.removeEventListener(Event.COMPLETE,this.handleSessionLoaderComplete);
         this.sessionDataStr = this.sessionLoader.data;
         _loc2_ = /dosid=/;
         _loc3_ = int(this.sessionDataStr.search(_loc2_));
         if(_loc3_ != -1)
         {
            _loc4_ = this.sessionDataStr.substring(_loc3_ + 6,this.sessionDataStr.length);
            _loc2_ = /';/;
            _loc3_ = int(_loc4_.search(_loc2_));
            if(_loc3_ != -1)
            {
               _loc5_ = _loc4_.substring(0,_loc3_);
               this.updateSession(_loc5_);
               return;
            }
            throw new Error("error while parsing received session data");
         }
         throw new Error("error while parsing received session data");
      }
      
      private function updateSession(param1:String) : void
      {
         var _loc4_:HashVO = null;
         var _loc2_:InstancesProxy = InstancesProxy.getInstance();
         var _loc3_:AccountsProxy = AccountsProxy.getInstance();
         _loc4_ = this.getHash(_loc2_.selectedInstanceId,_loc3_.selectedAccountIndex);
         if(_loc4_)
         {
            if(param1 != "error")
            {
               _loc4_.sid = param1;
            }
         }
         dispatchEvent(new Event(SESSION_LOADED));
      }
      
      public function getSession() : String
      {
         var _loc4_:HashVO = null;
         var _loc1_:InstancesProxy = InstancesProxy.getInstance();
         var _loc2_:AccountsProxy = AccountsProxy.getInstance();
         var _loc3_:InstanceVO = _loc1_.getSelectedInstance();
         if(Boolean(_loc3_) && _loc2_.selectedAccountIndex >= 0)
         {
            _loc4_ = this.getHash(_loc3_.id,_loc2_.selectedAccountIndex);
            if((Boolean(_loc4_)) && _loc4_.sid != "")
            {
               return _loc4_.sid;
            }
            throw new Error("no session ID available");
         }
         throw new Error("no session ID available");
      }
   }
}

