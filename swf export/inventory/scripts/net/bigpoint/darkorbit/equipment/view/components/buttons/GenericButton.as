package net.bigpoint.darkorbit.equipment.view.components.buttons
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import net.bigpoint.darkorbit.equipment.model.AssetProxy;
   import net.bigpoint.darkorbit.equipment.view.Styles;
   import net.bigpoint.utils.EventHandler;
   
   public class GenericButton extends AbstractButton
   {
      
      public static const NO_TEXT:String = "NO_TEXT";
      
      public var buttonText:String;
      
      public var buttonGraphic:MovieClip;
      
      protected var tf:TextField;
      
      protected var buttonEventsHandler:EventHandler;
      
      public function GenericButton(param1:String, param2:String, param3:Boolean = false)
      {
         super();
         this.buttonText = param1;
         this.buttonGraphic = AssetProxy.getMovieClip("scrollComponents",param2);
         if(param1 != NO_TEXT)
         {
            if(this.buttonGraphic.btnText)
            {
               this.tf = this.buttonGraphic.btnText;
            }
            else if(this.buttonGraphic.buttonText)
            {
               this.tf = this.buttonGraphic.buttonText;
            }
            this.tf.embedFonts = Styles.baseEmbed;
            this.tf.selectable = false;
            this.tf.mouseEnabled = false;
            this.tf.text = param1;
         }
         addChild(this.buttonGraphic);
         this.buttonEventsHandler = new EventHandler(this.buttonGraphic);
         if(param3)
         {
            this.addEventListener(Event.REMOVED_FROM_STAGE,this.handleThisRemovedFromStage,false,0,true);
         }
      }
      
      private function handleThisRemovedFromStage(param1:Event) : void
      {
         this.buttonEventsHandler.RemoveEvents();
         if(contains(this.buttonGraphic))
         {
            removeChild(this.buttonGraphic);
         }
         this.buttonEventsHandler.killDispatcher();
         this.buttonText = null;
         this.buttonGraphic = null;
         this.buttonEventsHandler = null;
      }
      
      public function addListeners() : void
      {
         this.buttonEventsHandler.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
      }
      
      public function removeListeners() : void
      {
         this.buttonEventsHandler.RemoveEvent(MouseEvent.MOUSE_OVER);
         this.buttonEventsHandler.RemoveEvent(MouseEvent.MOUSE_OUT);
      }
      
      public function addClickListener() : void
      {
         this.buttonEventsHandler.addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseClick);
      }
      
      public function removeClickListener() : void
      {
         this.buttonEventsHandler.RemoveEvent(MouseEvent.MOUSE_DOWN);
      }
      
      protected function handleMouseOver(param1:MouseEvent) : void
      {
         this.buttonEventsHandler.RemoveEvent(MouseEvent.MOUSE_OVER);
         this.buttonEventsHandler.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this.buttonGraphic.gotoAndStop(2);
      }
      
      protected function handleMouseOut(param1:MouseEvent) : void
      {
         this.buttonEventsHandler.RemoveEvent(MouseEvent.MOUSE_OUT);
         this.buttonEventsHandler.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.buttonGraphic.gotoAndStop(1);
      }
      
      protected function handleMouseClick(param1:MouseEvent) : void
      {
         this.buttonEventsHandler.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp);
         this.buttonGraphic.gotoAndStop(3);
      }
      
      protected function handleMouseUp(param1:MouseEvent) : void
      {
         this.buttonEventsHandler.RemoveEvent(MouseEvent.MOUSE_UP);
         this.buttonGraphic.gotoAndStop(2);
      }
      
      public function setInactive() : void
      {
         this.buttonGraphic.gotoAndStop(4);
         this.removeListeners();
         this.removeClickListener();
      }
      
      public function setActive() : void
      {
         this.buttonGraphic.gotoAndStop(1);
         this.addListeners();
         this.addClickListener();
      }
      
      public function deactivate() : void
      {
         this.buttonGraphic.gotoAndStop(4);
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      public function activate() : void
      {
         this.buttonGraphic.gotoAndStop(1);
         this.mouseEnabled = true;
         this.mouseChildren = true;
      }
   }
}

