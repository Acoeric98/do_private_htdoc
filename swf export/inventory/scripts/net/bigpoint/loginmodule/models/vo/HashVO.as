package net.bigpoint.loginmodule.models.vo
{
   public class HashVO
   {
      
      public var instance_id:int;
      
      public var account_id:int;
      
      public var sign:String = "";
      
      public var req:String = "";
      
      public var sid:String = "";
      
      public function HashVO(param1:int, param2:int, param3:String = "", param4:String = "")
      {
         super();
         this.instance_id = param1;
         this.account_id = param2;
         this.req = param3;
         this.sign = param4;
      }
   }
}

