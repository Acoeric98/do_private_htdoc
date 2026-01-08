package net.bigpoint.loginmodule.models.vo
{
   public class InstanceVO
   {
      
      public var id:int;
      
      public var name:String;
      
      public function InstanceVO(param1:int, param2:String = "")
      {
         super();
         this.id = param1;
         this.name = param2;
      }
   }
}

