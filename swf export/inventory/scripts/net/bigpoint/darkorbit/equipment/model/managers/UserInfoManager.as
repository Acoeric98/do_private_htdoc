package net.bigpoint.darkorbit.equipment.model.managers
{
   import net.bigpoint.darkorbit.equipment.model.VO.User;
   
   public class UserInfoManager
   {
      
      private static const USER_ATTRIBUTE_IDENTIFIER_FACTION:String = "factionRelated";
      
      private var userVO:User;
      
      public function UserInfoManager(param1:Object = null)
      {
         super();
         this.userVO = new User();
         this.parseInitData(param1);
      }
      
      public function parseInitData(param1:Object) : void
      {
         if(param1 != null)
         {
            this.userVO.faction = param1[USER_ATTRIBUTE_IDENTIFIER_FACTION];
         }
      }
      
      public function getUserData() : User
      {
         return this.userVO;
      }
   }
}

