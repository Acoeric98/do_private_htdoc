package com.bigpoint.TextFieldColor
{
   import flash.filters.ColorMatrixFilter;
   import flash.text.TextField;
   
   public class TextFieldColor
   {
      
      private static const byteToPerc:Number = 1 / 255;
      
      private var $textField:TextField;
      
      private var $textColor:uint;
      
      private var $selectedColor:uint;
      
      private var $selectionColor:uint;
      
      private var colorMatrixFilter:ColorMatrixFilter;
      
      public function TextFieldColor(param1:TextField, param2:uint = 0, param3:uint = 0, param4:uint = 0)
      {
         super();
         this.$textField = param1;
         this.colorMatrixFilter = new ColorMatrixFilter();
         this.$textColor = param2;
         this.$selectionColor = param3;
         this.$selectedColor = param4;
         this.updateFilter();
      }
      
      private static function splitRGB(param1:uint) : Array
      {
         return [param1 >> 16 & 0xFF,param1 >> 8 & 0xFF,param1 & 0xFF];
      }
      
      public function set textField(param1:TextField) : void
      {
         this.$textField = param1;
      }
      
      public function get textField() : TextField
      {
         return this.$textField;
      }
      
      public function set textColor(param1:uint) : void
      {
         this.$textColor = param1;
         this.updateFilter();
      }
      
      public function get textColor() : uint
      {
         return this.$textColor;
      }
      
      public function set selectionColor(param1:uint) : void
      {
         this.$selectionColor = param1;
         this.updateFilter();
      }
      
      public function get selectionColor() : uint
      {
         return this.$selectionColor;
      }
      
      public function set selectedColor(param1:uint) : void
      {
         this.$selectedColor = param1;
         this.updateFilter();
      }
      
      public function get selectedColor() : uint
      {
         return this.$selectedColor;
      }
      
      private function updateFilter() : void
      {
         this.$textField.textColor = 16711680;
         var _loc1_:Array = splitRGB(this.$selectionColor);
         var _loc2_:Array = splitRGB(this.$textColor);
         var _loc3_:Array = splitRGB(this.$selectedColor);
         var _loc4_:int = int(_loc1_[0]);
         var _loc5_:int = int(_loc1_[1]);
         var _loc6_:int = int(_loc1_[2]);
         var _loc7_:Number = (_loc2_[0] - 255 - _loc1_[0]) * byteToPerc + 1;
         var _loc8_:Number = (_loc2_[1] - 255 - _loc1_[1]) * byteToPerc + 1;
         var _loc9_:Number = (_loc2_[2] - 255 - _loc1_[2]) * byteToPerc + 1;
         var _loc10_:Number = (_loc3_[0] - 255 - _loc1_[0]) * byteToPerc + 1 - _loc7_;
         var _loc11_:Number = (_loc3_[1] - 255 - _loc1_[1]) * byteToPerc + 1 - _loc8_;
         var _loc12_:Number = (_loc3_[2] - 255 - _loc1_[2]) * byteToPerc + 1 - _loc9_;
         this.colorMatrixFilter.matrix = [_loc7_,_loc10_,0,0,_loc4_,_loc8_,_loc11_,0,0,_loc5_,_loc9_,_loc12_,0,0,_loc6_,0,0,0,1,0];
         this.$textField.filters = [this.colorMatrixFilter];
      }
   }
}

