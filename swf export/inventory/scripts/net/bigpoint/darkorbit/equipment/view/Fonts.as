package net.bigpoint.darkorbit.equipment.view
{
   import flash.text.Font;
   
   public class Fonts
   {
      
      private static var fontEurostileFl:Class = Fonts_fontEurostileFl;
      
      private static var fontEurostileHeaFl:Class = Fonts_fontEurostileHeaFl;
      
      public function Fonts()
      {
         super();
      }
      
      public static function initialize() : void
      {
         Font.registerFont(fontEurostileFl);
         Font.registerFont(fontEurostileHeaFl);
      }
   }
}

