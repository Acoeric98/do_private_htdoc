package net.bigpoint.darkorbit.equipment.model.VO
{
   public class User
   {
      
      private static const FACTION_MMO:String = "mmo";
      
      private static const FACTION_EIC:String = "eic";
      
      private static const FACTION_VRU:String = "vru";
      
      private var _faction:String;
      
      public function User()
      {
         super();
      }
      
      public function get faction() : String
      {
         return this._faction;
      }
      
      public function set faction(param1:String) : void
      {
         switch(param1)
         {
            case FACTION_MMO:
            case FACTION_EIC:
            case FACTION_VRU:
               this._faction = param1;
         }
      }
   }
}

