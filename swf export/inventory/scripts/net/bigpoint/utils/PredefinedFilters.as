package net.bigpoint.utils
{
   import flash.filters.ColorMatrixFilter;
   
   public class PredefinedFilters
   {
      
      public static var greymatrix:Array = [0.5,0.5,0.5,0,0,0.5,0.5,0.5,0,0,0.5,0.5,0.5,0,0,0,0,0,0.65,0];
      
      public static var COLOR_MATRIX_GREY:ColorMatrixFilter = new ColorMatrixFilter(greymatrix);
      
      public static var TWEENMAX_COLORMATRIX_COLORED:Object = {"colorMatrixFilter":{
         "amount":1,
         "saturation":1,
         "brightness":1,
         "contrast":1
      }};
      
      public static var TWEENMAX_COLORMATRIX_COLORLESS:Object = {"colorMatrixFilter":{
         "amount":1,
         "saturation":0,
         "brightness":0.85,
         "contrast":0.9
      }};
      
      public static var TWEENMAX_COLORMATRIX_BLACKANDWHITE:Object = {"colorMatrixFilter":{
         "amount":1,
         "saturation":0,
         "brightness":0,
         "contrast":0.6
      }};
      
      public function PredefinedFilters()
      {
         super();
      }
   }
}

