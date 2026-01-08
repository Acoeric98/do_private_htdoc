package net.bigpoint.darkorbit.equipment.view.components.buttons
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import net.bigpoint.darkorbit.equipment.model.AssetProxy;
   import net.bigpoint.darkorbit.equipment.view.Styles;
   
   public class DropDownButton extends AbstractButton
   {
      
      public var buttonKey:String;
      
      public var buttonGraphic:MovieClip;
      
      public var buttonText:String;
      
      protected var buttonBackground:DisplayObject;
      
      public var filterKey:String = "filter_user";
      
      public var data:Object;
      
      private var buttonTextfield:TextField;
      
      public function DropDownButton(param1:String, param2:String)
      {
         super();
         this.buttonText = param1;
         this.buttonGraphic = AssetProxy.getMovieClip("scrollComponents",param2);
         this.buttonBackground = this.buttonGraphic.background;
         this.buttonTextfield = this.buttonGraphic.btnText;
         this.buttonTextfield.text = param1.toUpperCase();
         this.buttonTextfield.selectable = false;
         this.buttonTextfield.embedFonts = Styles.baseEmbed;
         this.buttonTextfield.mouseEnabled = false;
         addChild(this.buttonGraphic);
         this.setOutState();
      }
      
      public function setOverState() : void
      {
         this.buttonGraphic.gotoAndStop(2);
         if(this.buttonBackground)
         {
            this.buttonBackground.alpha = 1;
         }
      }
      
      public function setOutState() : void
      {
         this.buttonGraphic.gotoAndStop(1);
         if(this.buttonBackground)
         {
            this.buttonBackground.alpha = 0;
         }
      }
      
      public function setHeight(param1:uint) : void
      {
         if(this.buttonBackground)
         {
            this.buttonBackground.height = param1;
         }
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
         if(this.buttonGraphic.btnText != null)
         {
            this.buttonGraphic.btnText.textColor = 16777215;
         }
         this.setOverState();
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         this.buttonGraphic.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.buttonGraphic.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         if(this.buttonGraphic.btnText != null)
         {
            this.buttonGraphic.btnText.textColor = 8421504;
         }
         this.setOutState();
      }
      
      private function handleMouseClick(param1:MouseEvent) : void
      {
         this.buttonGraphic.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp);
         this.buttonGraphic.gotoAndStop(3);
      }
      
      private function handleMouseUp(param1:MouseEvent) : void
      {
         this.buttonGraphic.removeEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp);
         this.buttonGraphic.gotoAndStop(2);
      }
   }
}

