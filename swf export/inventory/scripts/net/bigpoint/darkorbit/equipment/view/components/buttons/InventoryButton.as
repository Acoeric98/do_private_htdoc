package net.bigpoint.darkorbit.equipment.view.components.buttons
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import net.bigpoint.darkorbit.equipment.model.AssetProxy;
   import net.bigpoint.darkorbit.equipment.view.Styles;
   
   public class InventoryButton extends AbstractButton
   {
      
      public var buttonName:String;
      
      private var buttonDisplay:MovieClip;
      
      public var currentActiveCallback:Function;
      
      public var data:Object;
      
      public function InventoryButton(param1:String, param2:String)
      {
         super();
         this.buttonName = param1;
         this.buttonDisplay = AssetProxy.getMovieClip("scrollComponents",param1);
         this.buttonDisplay.gotoAndStop(2);
         this.buttonDisplay.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.buttonDisplay.addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseClick);
         var _loc3_:TextField = this.buttonDisplay.buttonText;
         _loc3_.text = param2;
         _loc3_.embedFonts = Styles.baseEmbed;
         _loc3_.selectable = false;
         _loc3_.mouseEnabled = false;
         addChild(this.buttonDisplay);
      }
      
      public function setInactive() : void
      {
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this.buttonDisplay.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.buttonDisplay.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseClick);
         this.buttonDisplay.buttonText.textColor = 6710886;
         this.buttonDisplay.gotoAndStop(1);
      }
      
      public function setActive() : void
      {
         this.mouseEnabled = true;
         this.mouseChildren = true;
         this.buttonDisplay.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.buttonDisplay.addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseClick);
         this.buttonDisplay.buttonText.textColor = 16777215;
         this.buttonDisplay.gotoAndStop(2);
      }
      
      public function changeButtonText(param1:String) : void
      {
         this.buttonDisplay.buttonText.text = param1;
      }
      
      private function handleMouseClick(param1:MouseEvent) : void
      {
         this.buttonDisplay.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp);
         this.buttonDisplay.gotoAndStop(4);
         this.buttonDisplay.buttonText.alpha = 0.3;
      }
      
      private function handleMouseUp(param1:MouseEvent) : void
      {
         this.buttonDisplay.removeEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp);
         this.buttonDisplay.gotoAndStop(3);
         this.buttonDisplay.buttonText.alpha = 1;
      }
      
      private function handleMouseOver(param1:MouseEvent) : void
      {
         this.buttonDisplay.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.buttonDisplay.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this.buttonDisplay.gotoAndStop(3);
         this.buttonDisplay.buttonText.alpha = 1;
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         this.buttonDisplay.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.buttonDisplay.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this.buttonDisplay.gotoAndStop(2);
         this.buttonDisplay.buttonText.alpha = 1;
      }
   }
}

