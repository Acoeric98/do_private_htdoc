package net.bigpoint.darkorbit.equipment.model.VO
{
   import flash.utils.Dictionary;
   
   public class Config
   {
      
      public var name:String;
      
      public var equipments:Dictionary = new Dictionary();
      
      public function Config(param1:String)
      {
         super();
         this.name = param1;
      }
      
      public function getEquipment(param1:String) : Equipment
      {
         return this.equipments[param1];
      }
      
      public function addEquipment(param1:String) : Equipment
      {
         var _loc2_:Equipment = new Equipment();
         _loc2_.name = param1;
         this.equipments[_loc2_.name] = _loc2_;
         return _loc2_;
      }
   }
}

