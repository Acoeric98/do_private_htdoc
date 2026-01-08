package net.bigpoint.darkorbit.equipment.model.VO.item
{
   public class ItemGroupVO
   {
      
      protected static const IDENTIFIER_GEAR:String = "gear";
      
      protected static const IDENTIFIER_PET:String = "pet";
      
      protected static const IDENTIFIER_AIPROTOCOL:String = "protocol";
      
      protected var _name:String;
      
      public function ItemGroupVO()
      {
         super();
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function isGear() : Boolean
      {
         var _loc1_:int = int(this._name.toLowerCase().indexOf(IDENTIFIER_GEAR));
         return _loc1_ >= 0 ? true : false;
      }
      
      public function isPet() : Boolean
      {
         var _loc1_:int = int(this._name.toLowerCase().indexOf(IDENTIFIER_PET));
         return _loc1_ >= 0 ? true : false;
      }
      
      public function isProtocol() : Boolean
      {
         var _loc1_:int = int(this._name.toLowerCase().indexOf(IDENTIFIER_AIPROTOCOL));
         return _loc1_ >= 0 ? true : false;
      }
   }
}

