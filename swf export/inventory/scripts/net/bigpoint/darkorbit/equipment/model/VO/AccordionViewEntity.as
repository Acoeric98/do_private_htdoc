package net.bigpoint.darkorbit.equipment.model.VO
{
   import net.bigpoint.darkorbit.equipment.view.components.items.InventoryItemComponent;
   
   public class AccordionViewEntity
   {
      
      public static var SHIP:int = 1;
      
      public static var DRONES:int = 2;
      
      public static var PET:int = 3;
      
      public var isSelected:Boolean;
      
      public var type:int = 0;
      
      public var instance:InventoryItemComponent;
      
      public function AccordionViewEntity()
      {
         super();
      }
   }
}

