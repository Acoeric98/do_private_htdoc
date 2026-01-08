package net.bigpoint.darkorbit.equipment.view.components.interfaces
{
   import net.bigpoint.darkorbit.equipment.view.components.items.GridRearrangeComponent;
   import net.bigpoint.darkorbit.equipment.view.components.items.InventoryItemComponent;
   
   public interface IMenuComponent
   {
      
      function getStartingYPosition() : Number;
      
      function getGridRearranger() : GridRearrangeComponent;
      
      function getParent() : Object;
      
      function getY() : Number;
      
      function getX() : Number;
      
      function addThisChild(param1:InventoryItemComponent) : void;
      
      function getFilterState() : String;
      
      function getObjectType() : String;
      
      function putThisItemBack(param1:InventoryItemComponent) : void;
      
      function getContainingViewID() : String;
      
      function getSlotSetName() : String;
   }
}

