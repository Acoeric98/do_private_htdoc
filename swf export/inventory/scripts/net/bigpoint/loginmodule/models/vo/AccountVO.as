package net.bigpoint.loginmodule.models.vo
{
   public class AccountVO
   {
      
      public var username:String;
      
      public var password:String;
      
      public var bp_username:String;
      
      public var checkout:String;
      
      public var machine:String;
      
      public var instanceIds:Vector.<int>;
      
      public function AccountVO(param1:String = "", param2:String = "")
      {
         super();
         this.username = param1;
         this.password = param2;
         this.instanceIds = new Vector.<int>();
      }
   }
}

