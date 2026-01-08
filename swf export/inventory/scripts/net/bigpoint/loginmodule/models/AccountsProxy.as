package net.bigpoint.loginmodule.models
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import net.bigpoint.loginmodule.models.vo.AccountVO;
   import net.bigpoint.loginmodule.models.vo.InstanceVO;
   
   public class AccountsProxy extends EventDispatcher
   {
      
      private static var _instance:AccountsProxy;
      
      public static const LOADED:String = "LOADED";
      
      public static const NAME:String = "Accounts";
      
      public var accounts:Vector.<AccountVO>;
      
      public var selectedAccountIndex:int = -1;
      
      public function AccountsProxy(param1:Function)
      {
         super();
         if(param1 !== hidden)
         {
            throw new Error("Accounts is a Singleton and can only be accessed through Accounts.getInstance()");
         }
         this.init();
      }
      
      public static function getInstance() : AccountsProxy
      {
         if(_instance == null)
         {
            _instance = new AccountsProxy(hidden);
         }
         return _instance;
      }
      
      private static function hidden() : void
      {
      }
      
      public function init() : void
      {
         this.accounts = new Vector.<AccountVO>();
         dispatchEvent(new Event(LOADED));
      }
      
      public function addAccount(param1:String, param2:String, param3:String, param4:String, param5:String, param6:int) : Boolean
      {
         var _loc9_:AccountVO = null;
         var _loc10_:int = 0;
         var _loc11_:HashesProxy = null;
         var _loc12_:int = 0;
         var _loc7_:InstancesProxy = InstancesProxy.getInstance();
         var _loc8_:InstanceVO = _loc7_.getInstanceById(param6);
         if(_loc8_)
         {
            _loc9_ = new AccountVO();
            _loc9_.username = param1;
            _loc9_.password = param2;
            _loc9_.bp_username = param3;
            _loc9_.checkout = param4;
            _loc9_.machine = param5;
            _loc9_.instanceIds.push(param6);
            _loc10_ = this.accounts.push(_loc9_) - 1;
            _loc11_ = HashesProxy.getInstance();
            for each(_loc12_ in _loc9_.instanceIds)
            {
               _loc11_.addHash(_loc12_,_loc10_);
            }
            return true;
         }
         throw new Error("no instance found for given instance id");
      }
      
      public function getAccountByUsername(param1:String) : AccountVO
      {
         var _loc2_:AccountVO = null;
         var _loc3_:AccountVO = null;
         for each(_loc3_ in this.accounts)
         {
            if(_loc3_.username == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         return _loc2_;
      }
      
      public function getAccountByIndex(param1:int) : AccountVO
      {
         return this.accounts[param1];
      }
      
      public function getSelectedAccount() : AccountVO
      {
         if(this.selectedAccountIndex >= 0)
         {
            return this.accounts[this.selectedAccountIndex];
         }
         return null;
      }
   }
}

