package net.bigpoint.darkorbit.equipment.view.components.buttons
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import net.bigpoint.darkorbit.equipment.model.AssetProxy;
   import net.bigpoint.darkorbit.equipment.view.Styles;
   
   public class ConfigButton extends AbstractButton
   {
      
      private static const FRAME_NORMAL:int = 1;
      
      private static const FRAME_OVER:int = 2;
      
      private static const FRAME_CLICK:int = 3;
      
      private static const FRAME_DEACTIVE:int = 4;
      
      public var clip:MovieClip;
      
      public var configNumber:int;
      
      private var currentFrame:int;
      
      public function ConfigButton(param1:int)
      {
         super();
         this.configNumber = param1;
         this.clip = AssetProxy.getMovieClip("scrollComponents","config");
         this.clip.useHandCursor = true;
         this.clip.buttonMode = true;
         var _loc2_:TextField = this.clip.btnText;
         _loc2_.embedFonts = Styles.baseEmbed;
         _loc2_.selectable = false;
         _loc2_.mouseEnabled = false;
         _loc2_.text = String(param1);
         _loc2_.textColor = 11646391;
         _loc2_.x = this.clip.btnText.x - 1;
         addChild(this.clip);
         this.currentFrame = FRAME_NORMAL;
         this.clip.gotoAndStop(this.currentFrame);
      }
      
      public function addHoverListener() : void
      {
         this.clip.addEventListener(MouseEvent.ROLL_OVER,this.handleHoverState);
      }
      
      private function handleHoverState(param1:MouseEvent) : void
      {
         this.clip.addEventListener(MouseEvent.ROLL_OUT,this.handleRollOutState);
         this.clip.gotoAndStop(FRAME_OVER);
      }
      
      private function handleRollOutState(param1:MouseEvent) : void
      {
         this.clip.removeEventListener(MouseEvent.ROLL_OUT,this.handleRollOutState);
         this.clip.gotoAndStop(this.currentFrame);
      }
      
      public function setActive() : void
      {
         this.currentFrame = FRAME_CLICK;
         this.clip.gotoAndStop(this.currentFrame);
         this.clip.removeEventListener(MouseEvent.ROLL_OVER,this.handleHoverState);
         this.clip.removeEventListener(MouseEvent.ROLL_OUT,this.handleRollOutState);
         this.clip.btnText.textColor = 16763904;
      }
      
      public function setInActive() : void
      {
         this.currentFrame = FRAME_NORMAL;
         this.clip.gotoAndStop(this.currentFrame);
         this.clip.addEventListener(MouseEvent.ROLL_OVER,this.handleHoverState);
         this.clip.btnText.textColor = 11646391;
      }
      
      public function deactivate() : void
      {
         this.clip.btnText.textColor = 7829367;
         this.currentFrame = FRAME_DEACTIVE;
         this.clip.gotoAndStop(this.currentFrame);
      }
   }
}

