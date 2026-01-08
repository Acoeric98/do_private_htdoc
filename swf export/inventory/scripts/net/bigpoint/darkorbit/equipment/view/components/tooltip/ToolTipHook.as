package net.bigpoint.darkorbit.equipment.view.components.tooltip
{
   import com.greensock.TweenMax;
   import flash.display.DisplayObject;
   import flash.display.Stage;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.equipment.view.Styles;
   import net.bigpoint.utils.EventHandler;
   
   public class ToolTipHook
   {
      
      private static const MAX_TOOLTIP_WIDTH:int = 300;
      
      private static const SHOW_DELAY:int = 250;
      
      private static const HIDE_DELAY:int = 100;
      
      private var targetObject:DisplayObject;
      
      private var text:String;
      
      private var t:Timer;
      
      private var toolTipVisible:Boolean;
      
      private var tooltipText:TextField;
      
      private var bounds:Rectangle;
      
      private var htmlText:Boolean = false;
      
      private var actualTarget:DisplayObject;
      
      private var itemQuantity:int;
      
      private var textPart0:String;
      
      private var textPart1:String;
      
      public function ToolTipHook(param1:DisplayObject, param2:String, param3:Boolean = false, param4:int = 0)
      {
         super();
         this.targetObject = param1;
         this.itemQuantity = param4;
         if(param1 is EventHandler)
         {
            this.actualTarget = EventHandler(param1).dispatcher;
         }
         else
         {
            this.actualTarget = param1;
         }
         this.setText(param2);
         this.htmlText = param3;
         this.targetObject.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         this.targetObject.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this.targetObject.addEventListener(MouseEvent.MOUSE_DOWN,this.onRollOut);
      }
      
      public function removeListeners() : void
      {
         this.targetObject.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         this.targetObject.removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this.targetObject.removeEventListener(MouseEvent.MOUSE_DOWN,this.onRollOut);
      }
      
      public function addListeners() : void
      {
         this.targetObject.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         this.targetObject.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this.targetObject.addEventListener(MouseEvent.MOUSE_DOWN,this.onRollOut);
      }
      
      private function setText(param1:String = "") : void
      {
         var _loc2_:Array = param1.split(TooltipControl.WILDCARD);
         if(_loc2_.length > 1)
         {
            this.textPart0 = _loc2_[0] as String;
            this.textPart1 = _loc2_[1] as String;
            this.text = this.textPart0 + String(this.itemQuantity) + this.textPart1;
         }
         else
         {
            this.text = param1;
         }
      }
      
      public function updateText(param1:String = "") : void
      {
         if(param1 == "")
         {
            if(this.textPart0 != null && this.textPart1 != null)
            {
               this.text = this.textPart0 + String(this.itemQuantity) + this.textPart1;
            }
         }
         if(this.toolTipVisible && this.tooltipText != null)
         {
            if(!this.htmlText)
            {
               this.tooltipText.text = this.text;
            }
            else
            {
               this.tooltipText.htmlText = this.text;
            }
         }
      }
      
      public function setQuantity(param1:int) : void
      {
         this.itemQuantity = param1;
      }
      
      public function getToolTipText() : String
      {
         return this.text;
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         this.t = new Timer(SHOW_DELAY,1);
         this.t.addEventListener(TimerEvent.TIMER_COMPLETE,this.showTooltip);
         this.t.start();
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         if(this.t != null)
         {
            this.t.removeEventListener(TimerEvent.TIMER_COMPLETE,this.showTooltip);
            this.t.stop();
            this.t = null;
         }
         if(this.toolTipVisible)
         {
            this.t = new Timer(HIDE_DELAY,1);
            this.t.addEventListener(TimerEvent.TIMER_COMPLETE,this.hideTooltip);
            this.t.start();
         }
      }
      
      public function setBounds(param1:Rectangle) : void
      {
         this.bounds = param1;
      }
      
      private function showTooltip(param1:TimerEvent) : void
      {
         if(this.tooltipText == null)
         {
            this.createToolTipTextField();
         }
         this.toolTipVisible = true;
         this.updateText(this.text);
         this.updateTextFieldWidth();
         this.tooltipText.x = this.actualTarget.stage.mouseX + 10;
         this.tooltipText.y = this.actualTarget.stage.mouseY + 10;
         if(this.tooltipText.x + this.tooltipText.width > this.bounds.width)
         {
            this.tooltipText.x = this.actualTarget.stage.mouseX - this.tooltipText.width - 10;
         }
         if(this.tooltipText.y + this.tooltipText.height > this.bounds.height)
         {
            this.tooltipText.y = this.actualTarget.stage.mouseY - this.tooltipText.height - 10;
         }
         try
         {
            this.actualTarget.stage.addChild(this.tooltipText);
            this.targetObject.addEventListener(MouseEvent.MOUSE_MOVE,this.moveToolTipWithMouse);
            this.tooltipText.alpha = 0;
            TweenMax.to(this.tooltipText,0.2,{"alpha":1});
         }
         catch(e:Error)
         {
         }
      }
      
      private function moveToolTipWithMouse(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Stage = null;
         if(this.tooltipText != null && this.targetObject != null)
         {
            _loc4_ = this.tooltipText.stage;
            if(_loc4_ != null)
            {
               if(this.tooltipText.x < _loc4_.mouseX)
               {
                  _loc2_ = _loc4_.mouseX - this.tooltipText.width - 10;
                  if(_loc2_ >= 0)
                  {
                     this.tooltipText.x = _loc2_;
                  }
               }
               else
               {
                  _loc2_ = _loc4_.mouseX + 10;
                  if(_loc2_ + this.tooltipText.width <= this.bounds.width)
                  {
                     this.tooltipText.x = _loc2_;
                  }
               }
               if(this.tooltipText.y < _loc4_.mouseY)
               {
                  _loc3_ = _loc4_.mouseY - this.tooltipText.height - 10;
                  if(_loc3_ >= 0)
                  {
                     this.tooltipText.y = _loc3_;
                  }
               }
               else
               {
                  _loc3_ = _loc4_.mouseY + 10;
                  if(_loc3_ + this.tooltipText.height <= this.bounds.height)
                  {
                     this.tooltipText.y = _loc3_;
                  }
               }
            }
         }
      }
      
      public function hideTooltip(param1:TimerEvent = null) : void
      {
         this.toolTipVisible = false;
         if(this.t != null)
         {
            this.t.stop();
            this.t.removeEventListener(TimerEvent.TIMER_COMPLETE,this.hideTooltip);
            this.t.removeEventListener(TimerEvent.TIMER_COMPLETE,this.showTooltip);
            this.t = null;
         }
         try
         {
            this.actualTarget.stage.removeChild(this.tooltipText);
         }
         catch(e:Error)
         {
         }
      }
      
      public function hide2() : void
      {
         try
         {
            this.actualTarget.stage.removeChild(this.tooltipText);
         }
         catch(e:Error)
         {
         }
         this.toolTipVisible = false;
      }
      
      public function getTargetObject() : DisplayObject
      {
         return this.targetObject;
      }
      
      internal function suicide() : void
      {
         try
         {
            this.targetObject.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
            this.targetObject.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOut);
            this.targetObject.removeEventListener(MouseEvent.MOUSE_DOWN,this.onRollOut);
            this.hideTooltip(null);
         }
         catch(e:Error)
         {
         }
      }
      
      public function removeFromStageOnly() : void
      {
         this.targetObject.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         this.targetObject.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOut);
         this.targetObject.removeEventListener(MouseEvent.MOUSE_DOWN,this.onRollOut);
         this.hideTooltip(null);
         this.targetObject = null;
         this.actualTarget = null;
      }
      
      private function createToolTipTextField() : DisplayObject
      {
         this.tooltipText = new TextField();
         if(Styles.baseEmbed)
         {
            this.tooltipText.defaultTextFormat = Styles.tooltipFmt;
         }
         else
         {
            this.tooltipText.defaultTextFormat = Styles.tooltipFmtDeviceFonts;
         }
         this.tooltipText.embedFonts = false;
         this.tooltipText.autoSize = TextFieldAutoSize.LEFT;
         this.tooltipText.textColor = 13421772;
         this.tooltipText.backgroundColor = 0;
         this.tooltipText.background = true;
         this.tooltipText.border = true;
         this.tooltipText.borderColor = 1873341;
         this.tooltipText.antiAliasType = AntiAliasType.ADVANCED;
         this.tooltipText.selectable = false;
         this.tooltipText.mouseEnabled = false;
         this.tooltipText.multiline = true;
         this.updateText(this.text);
         return this.tooltipText;
      }
      
      private function updateTextFieldWidth() : void
      {
         this.tooltipText.wordWrap = false;
         this.tooltipText.multiline = false;
         this.tooltipText.autoSize = TextFieldAutoSize.LEFT;
         if(this.tooltipText.width > MAX_TOOLTIP_WIDTH)
         {
            this.tooltipText.width = MAX_TOOLTIP_WIDTH;
            this.tooltipText.wordWrap = true;
            this.tooltipText.multiline = true;
         }
      }
   }
}

