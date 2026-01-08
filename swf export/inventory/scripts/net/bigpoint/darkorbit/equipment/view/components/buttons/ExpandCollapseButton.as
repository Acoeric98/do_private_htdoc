package net.bigpoint.darkorbit.equipment.view.components.buttons
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.equipment.model.AssetProxy;
   
   public class ExpandCollapseButton extends MovieClip
   {
      
      public static const EXPAND_MODE:String = "EXPAND_MODE";
      
      public static const COLLAPSE_MODE:String = "COLLAPSE_MODE";
      
      public var buttonGraphic:MovieClip;
      
      public var mode:String = "EXPAND_MODE";
      
      private var normalFrame:int;
      
      private var overFrame:int;
      
      private var clickFrame:int;
      
      public function ExpandCollapseButton()
      {
         super();
         this.buttonGraphic = AssetProxy.getMovieClip("scrollComponents","expandCollapse");
         addChild(this.buttonGraphic);
         this.buttonGraphic.gotoAndStop(1);
         this.switchToCollapseButton();
      }
      
      private function switchToCollapseButton() : void
      {
         this.normalFrame = 1;
         this.overFrame = 2;
         this.clickFrame = 3;
         this.buttonGraphic.gotoAndStop(this.normalFrame);
      }
      
      private function switchToExpandButton() : void
      {
         this.normalFrame = 4;
         this.overFrame = 5;
         this.clickFrame = 6;
         this.buttonGraphic.gotoAndStop(this.normalFrame);
      }
      
      public function addListeners() : void
      {
         this.buttonGraphic.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
      }
      
      public function addClickListener() : void
      {
         this.buttonGraphic.addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseClick);
      }
      
      public function removeListeners() : void
      {
         this.buttonGraphic.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.buttonGraphic.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
      }
      
      public function removeClickListener() : void
      {
         this.buttonGraphic.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseClick);
      }
      
      private function handleMouseOver(param1:MouseEvent) : void
      {
         this.buttonGraphic.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.buttonGraphic.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this.buttonGraphic.gotoAndStop(this.overFrame);
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         this.buttonGraphic.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.buttonGraphic.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this.buttonGraphic.gotoAndStop(this.normalFrame);
      }
      
      private function handleMouseClick(param1:MouseEvent) : void
      {
         this.buttonGraphic.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp);
         this.buttonGraphic.gotoAndStop(this.clickFrame);
      }
      
      private function handleMouseUp(param1:MouseEvent) : void
      {
         this.buttonGraphic.removeEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp);
         this.buttonGraphic.gotoAndStop(this.overFrame);
      }
      
      public function switchButtonMode() : void
      {
         if(this.mode == EXPAND_MODE)
         {
            this.mode = COLLAPSE_MODE;
            this.switchToCollapseButton();
         }
         else
         {
            this.mode = EXPAND_MODE;
            this.switchToExpandButton();
         }
      }
   }
}

