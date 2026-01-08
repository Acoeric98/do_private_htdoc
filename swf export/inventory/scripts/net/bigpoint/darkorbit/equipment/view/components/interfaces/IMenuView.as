package net.bigpoint.darkorbit.equipment.view.components.interfaces
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.equipment.view.components.items.AccordionButtonComponent;
   import net.bigpoint.darkorbit.equipment.view.components.items.InventoryItemComponent;
   
   public interface IMenuView
   {
      
      function getViewID() : String;
      
      function getCurrentlyOpenMenu() : String;
      
      function getCurrentlyActiveSection() : Dictionary;
      
      function addToMenuItem(param1:String, param2:InventoryItemComponent, param3:AccordionButtonComponent) : void;
      
      function getActualCollisionRegion() : Object;
   }
}

