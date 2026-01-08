package net.bigpoint.darkorbit.equipment.view.components.buttons
{
   import flash.events.MouseEvent;
   
   public class SelectableGenericButton extends GenericButton
   {
      
      public var normalTextColorValue:int = 6737151;
      
      public var hoverTextColorValue:int = 16777215;
      
      public var clickTextColorValue:int = 16777215;
      
      public var selectTextColorValue:int = 0;
      
      private var selected:Boolean;
      
      public function SelectableGenericButton(param1:String, param2:String, param3:Boolean = false)
      {
         super(param1,param2,param3);
         this.addListeners();
         addClickListener();
         tf.textColor = this.normalTextColorValue;
      }
      
      override public function addListeners() : void
      {
         super.addListeners();
         buttonEventsHandler.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
      }
      
      override public function removeListeners() : void
      {
      }
      
      override protected function handleMouseOver(param1:MouseEvent) : void
      {
         if(!this.selected)
         {
            buttonGraphic.gotoAndStop(2);
            tf.textColor = this.hoverTextColorValue;
         }
      }
      
      override protected function handleMouseOut(param1:MouseEvent) : void
      {
         if(!this.selected)
         {
            buttonGraphic.gotoAndStop(1);
            tf.textColor = this.normalTextColorValue;
         }
      }
      
      override protected function handleMouseClick(param1:MouseEvent) : void
      {
         this.setSelected(!this.selected);
      }
      
      public function setSelected(param1:Boolean) : void
      {
         if(param1 != this.selected)
         {
            this.selected = param1;
            if(param1)
            {
               buttonGraphic.gotoAndStop(4);
               tf.textColor = this.selectTextColorValue;
            }
            else
            {
               buttonGraphic.gotoAndStop(3);
               tf.textColor = this.clickTextColorValue;
            }
            dispatchEvent(new SelectableGenericButtonEvent(SelectableGenericButtonEvent.EVENT_SELECTION_CHANGED,this.selected));
         }
      }
   }
}

