package net.bigpoint.darkorbit.equipment.view.components.tooltip.preparation
{
   public class AbstractTooltipPreparer
   {
      
      public static const DEFAULT_CUT_OFF_VALUE:int = 150;
      
      protected var _tooltipText:String;
      
      public function AbstractTooltipPreparer()
      {
         super();
      }
      
      public static function cutSingleLine(param1:String, param2:int = 150) : String
      {
         if(param1.length <= param2)
         {
            return param1;
         }
         return param1.substring(0,param2) + "...";
      }
      
      public function getTooltipText() : String
      {
         return this._tooltipText;
      }
      
      protected function get tooltipText() : String
      {
         return this._tooltipText;
      }
      
      protected function set tooltipText(param1:String) : void
      {
         this._tooltipText = param1;
      }
   }
}

