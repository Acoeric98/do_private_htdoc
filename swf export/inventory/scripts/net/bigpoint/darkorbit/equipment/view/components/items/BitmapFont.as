package net.bigpoint.darkorbit.equipment.view.components.items
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.equipment.model.AssetProxy;
   
   public class BitmapFont extends Bitmap
   {
      
      public static const WHITE:String = "WHITE";
      
      public static const NORMAL:String = "NORMAL";
      
      public static const BLUE:String = "BLUE";
      
      public static const PINK:String = "PINK";
      
      public static const RED:String = "RED";
      
      public static const PURPLE:String = "PURPLE";
      
      public static const YELLOW:String = "YELLOW";
      
      public static const GREY:String = "GREY";
      
      public static const BROWN:String = "BROWN";
      
      private var source:BitmapData;
      
      private var rect:Rectangle;
      
      private var destinationPoint:Point;
      
      private var greaterThanSymbol:MovieClip;
      
      public var useGreaterThanSymbol:Boolean = false;
      
      public function BitmapFont()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.source = AssetProxy.getBitmapData("scrollComponents","whiteFont");
         this.greaterThanSymbol = AssetProxy.getMovieClip("scrollComponents","greaterThan");
         this.rect = new Rectangle();
         this.rect.width = 5;
         this.rect.height = 7;
         this.destinationPoint = new Point();
      }
      
      public function setText(param1:String) : void
      {
         var _loc4_:* = 0;
         var _loc5_:int = 0;
         if(int(param1) >= 999)
         {
            param1 = "999";
            this.useGreaterThanSymbol = true;
         }
         else
         {
            this.useGreaterThanSymbol = false;
         }
         var _loc2_:int = 0;
         var _loc3_:Array = param1.split("");
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = int(_loc3_[_loc4_]);
            _loc2_ += 5;
            _loc4_++;
         }
         this.bitmapData = new BitmapData(_loc2_,7,true,0);
         this.destinationPoint.x = _loc2_;
         var _loc6_:int = -1;
         _loc4_ = _loc3_.length - 1;
         while(_loc4_ > -1)
         {
            _loc5_ = int(_loc3_[_loc4_]);
            this.destinationPoint.x -= 5;
            this.rect.x = _loc5_ * 5;
            bitmapData.copyPixels(this.source,this.rect,this.destinationPoint);
            _loc6_ = _loc5_;
            _loc4_--;
         }
      }
      
      public function changeFontColour(param1:String) : void
      {
         switch(param1)
         {
            case WHITE:
               this.source = AssetProxy.getBitmapData("scrollComponents","whiteFont");
               break;
            case NORMAL:
               this.source = AssetProxy.getBitmapData("scrollComponents","normalFont");
               break;
            case BLUE:
               this.source = AssetProxy.getBitmapData("scrollComponents","blueFont");
               break;
            case PINK:
               this.source = AssetProxy.getBitmapData("scrollComponents","pinkFont");
               break;
            case RED:
               this.source = AssetProxy.getBitmapData("scrollComponents","redFont");
               break;
            case PURPLE:
               this.source = AssetProxy.getBitmapData("scrollComponents","purpleFont");
               break;
            case YELLOW:
               this.source = AssetProxy.getBitmapData("scrollComponents","yellowFont");
               break;
            case GREY:
               this.source = AssetProxy.getBitmapData("scrollComponents","greyFont");
               break;
            case BROWN:
               this.source = AssetProxy.getBitmapData("scrollComponents","brownFont");
         }
      }
   }
}

