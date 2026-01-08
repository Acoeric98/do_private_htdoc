package net.bigpoint.loginmodule
{
   import flash.events.Event;
   import net.bigpoint.loginmodule.models.AccountsProxy;
   import net.bigpoint.loginmodule.models.HashesProxy;
   import net.bigpoint.loginmodule.models.InstancesProxy;
   
   public class LoginModule
   {
      
      public static const SERVER_MODE_DEVELOPMENT:String = "DEV";
      
      public static const SERVER_MODE_LIVE:String = "LIVE";
      
      public static const SERVER_MODE_IDEV:String = "IDEV";
      
      public static const READY:String = "READY";
      
      public static const COOKIE_CREATED:String = "COOKIE_CREATED";
      
      private var _verbose:Boolean;
      
      private var log:Function;
      
      public var username:String;
      
      public var password:String;
      
      public var bpUsername:String;
      
      public var checkout:String;
      
      public var machine:String;
      
      public var instance_id:int;
      
      public var serverMode:String;
      
      public var handleCookieCreated:Function;
      
      public function LoginModule()
      {
         this.log = this.logQuiet;
         super();
      }
      
      private function startLoading() : void
      {
         this.addListeners();
         var _loc1_:InstancesProxy = InstancesProxy.getInstance();
         _loc1_.loadInstances();
      }
      
      private function addListeners() : void
      {
         var _loc1_:InstancesProxy = InstancesProxy.getInstance();
         _loc1_.addEventListener(InstancesProxy.LOADED,this.handleInstancesLoaded);
         var _loc2_:HashesProxy = HashesProxy.getInstance();
         _loc2_.addEventListener(HashesProxy.HASHES_LOADED,this.handleHashesLoaded);
         _loc2_.addEventListener(HashesProxy.SESSION_LOADED,this.handleSessionLoaded);
      }
      
      private function handleInstancesLoaded(param1:Event) : void
      {
         var _loc4_:InstancesProxy = null;
         var _loc5_:HashesProxy = null;
         this.log("Loginmodule->handleInstancesLoaded");
         var _loc2_:AccountsProxy = AccountsProxy.getInstance();
         var _loc3_:Boolean = _loc2_.addAccount(this.username,this.password,this.bpUsername,this.checkout,this.machine,this.instance_id);
         if(_loc3_)
         {
            _loc2_.selectedAccountIndex = 0;
            _loc4_ = InstancesProxy.getInstance();
            _loc4_.selectedInstanceId = this.instance_id;
            switch(this.serverMode)
            {
               case SERVER_MODE_DEVELOPMENT:
                  this.handleHashesLoaded();
                  break;
               default:
                  _loc5_ = HashesProxy.getInstance();
                  _loc5_.loadHashes();
            }
            return;
         }
         throw new Error("Could not create account with received data.");
      }
      
      private function handleHashesLoaded(param1:Event = null) : void
      {
         var _loc2_:HashesProxy = HashesProxy.getInstance();
         _loc2_.loadSession(this.serverMode);
      }
      
      private function handleSessionLoaded(param1:Event) : void
      {
         var _loc2_:HashesProxy = HashesProxy.getInstance();
         var _loc3_:String = _loc2_.getSession();
         if(this.handleCookieCreated != null)
         {
            this.handleCookieCreated(_loc3_);
         }
      }
      
      public function writeCookie(param1:String, param2:String, param3:String, param4:String, param5:String, param6:int, param7:String = "DEV", param8:Function = null) : void
      {
         this.log("LoginModule->writeCookie initialized");
         this.username = param1;
         this.password = param2;
         this.bpUsername = param3;
         this.checkout = param4;
         this.machine = param5;
         this.instance_id = param6;
         this.serverMode = param7;
         this.handleCookieCreated = param8;
         this.startLoading();
      }
      
      public function get verbose() : Boolean
      {
         return this._verbose;
      }
      
      public function set verbose(param1:Boolean) : void
      {
         this._verbose = param1;
         if(this._verbose)
         {
            this.log = trace;
         }
         else
         {
            this.log = this.logQuiet;
         }
      }
      
      private function logQuiet(... rest) : void
      {
      }
   }
}

