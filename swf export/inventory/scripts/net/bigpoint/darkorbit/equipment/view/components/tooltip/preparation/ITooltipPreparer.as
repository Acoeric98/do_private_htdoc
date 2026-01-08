package net.bigpoint.darkorbit.equipment.view.components.tooltip.preparation
{
   public interface ITooltipPreparer
   {
      
      function getTooltipText() : String;
      
      function getShortenedText(param1:Boolean) : String;
      
      function callDirtyRelict() : void;
   }
}

