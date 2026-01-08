package net.bigpoint.darkorbit.equipment.view
{
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class Styles
   {
      
      public static const boldFontName:String = "EurostileHeaFl";
      
      public static const standardFontName:String = "EurostileFl";
      
      public static var baseEmbed:Boolean = true;
      
      public static const defaultFont:String = boldFontName;
      
      public static const plainStdFontHeight:int = 24;
      
      public static var plainStdFmt:TextFormat = new TextFormat(boldFontName,plainStdFontHeight,null,null,null,null,null,null,"center");
      
      public static var plainStdEmbed:Boolean = true;
      
      public static const tooltipFontHeight:int = 12;
      
      public static var tooltipFmt:TextFormat = new TextFormat("Tahoma",tooltipFontHeight,13421772);
      
      public static const tooltipFmtDeviceFonts:TextFormat = new TextFormat(null,tooltipFontHeight,13421772);
      
      public static var tooltipEmbed:Boolean = false;
      
      public static const droneTextFontHeight:int = 9;
      
      public static var droneTextFormat:TextFormat = new TextFormat("Verdana",droneTextFontHeight,null,null,null,null,null,null,TextFormatAlign.LEFT);
      
      public static var droneTextFormaDeviceFontst:TextFormat = new TextFormat(null,droneTextFontHeight,null,null,null,null,null,null,TextFormatAlign.LEFT);
      
      public static const itemInfoFontHeight:int = 10;
      
      public static var itemInfoFormat:TextFormat = new TextFormat("Verdana",itemInfoFontHeight,null,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,5);
      
      public static var itemInfoFormatDeviceFont:TextFormat = new TextFormat(null,itemInfoFontHeight,null,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,5);
      
      public function Styles()
      {
         super();
      }
      
      public static function useDeviceFonts() : void
      {
         tooltipEmbed = plainStdEmbed = baseEmbed = false;
      }
   }
}

