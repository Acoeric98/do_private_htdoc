package net.bigpoint.darkorbit.equipment.model.VO
{
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInfoVO;
   
   public class Drone extends EquippableObject
   {
      
      public var ID:String;
      
      public var index:int;
      
      public var itemInfo:ItemInfoVO;
      
      public var hitPoints:String;
      
      public var damage:int;
      
      public var effect:String;
      
      public var design:String;
      
      public var damageLevel:int = 1;
      
      public var shieldLevel:int = 1;
      
      public var repairCurrency:String;
      
      public var repairValue:uint;
      
      public function Drone()
      {
         super();
      }
   }
}

