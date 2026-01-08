package com.junkbyte.console.view
{
   import com.junkbyte.console.Console;
   import com.junkbyte.console.vos.GraphGroup;
   import com.junkbyte.console.vos.GraphInterest;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.events.TextEvent;
   import flash.text.TextField;
   
   public class GraphingPanel extends ConsolePanel
   {
      
      public static const FPS:String = "fpsPanel";
      
      public static const MEM:String = "memoryPanel";
      
      private var _group:GraphGroup;
      
      private var _interest:GraphInterest;
      
      private var _infoMap:Object = new Object();
      
      private var _type:String;
      
      private var _needRedraw:Boolean;
      
      private var underlay:Shape;
      
      private var graph:Shape;
      
      private var lowTxt:TextField;
      
      private var highTxt:TextField;
      
      public var startOffset:int = 5;
      
      public function GraphingPanel(param1:Console, param2:int, param3:int, param4:String = null)
      {
         super(param1);
         this._type = param4;
         registerDragger(bg);
         minWidth = 32;
         minHeight = 26;
         this.lowTxt = makeTF("lowestField",false);
         this.lowTxt.mouseEnabled = false;
         this.lowTxt.height = style.menuFontSize + 2;
         addChild(this.lowTxt);
         this.highTxt = makeTF("highestField",false);
         this.highTxt.mouseEnabled = false;
         this.highTxt.height = style.menuFontSize + 2;
         this.highTxt.y = style.menuFontSize - 4;
         addChild(this.highTxt);
         txtField = makeTF("menuField");
         txtField.height = style.menuFontSize + 4;
         txtField.y = -3;
         registerTFRoller(txtField,this.onMenuRollOver,this.linkHandler);
         registerDragger(txtField);
         addChild(txtField);
         this.underlay = new Shape();
         addChild(this.underlay);
         this.graph = new Shape();
         this.graph.name = "graph";
         this.graph.y = style.menuFontSize;
         addChild(this.graph);
         init(param2,param3,true);
      }
      
      private function stop() : void
      {
         if(this._group)
         {
            console.graphing.remove(this._group.name);
         }
      }
      
      public function get group() : GraphGroup
      {
         return this._group;
      }
      
      public function reset() : void
      {
         this._infoMap = {};
         this.graph.graphics.clear();
         if(!this._group.fixed)
         {
            this._group.low = NaN;
            this._group.hi = NaN;
         }
      }
      
      override public function set height(param1:Number) : void
      {
         super.height = param1;
         this.lowTxt.y = param1 - style.menuFontSize;
         this._needRedraw = true;
         var _loc2_:Graphics = this.underlay.graphics;
         _loc2_.clear();
         _loc2_.lineStyle(1,style.controlColor,0.6);
         _loc2_.moveTo(0,this.graph.y);
         _loc2_.lineTo(width - this.startOffset,this.graph.y);
         _loc2_.lineTo(width - this.startOffset,param1);
      }
      
      override public function set width(param1:Number) : void
      {
         super.width = param1;
         this.lowTxt.width = param1;
         this.highTxt.width = param1;
         txtField.width = param1;
         txtField.scrollH = txtField.maxScrollH;
         this.graph.graphics.clear();
         this._needRedraw = true;
      }
      
      public function update(param1:GraphGroup, param2:Boolean) : void
      {
         var _loc12_:GraphInterest = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:Array = null;
         var _loc16_:Array = null;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:* = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:Number = NaN;
         this._group = param1;
         var _loc3_:int = 1;
         if(param1.idle > 0)
         {
            _loc3_ = 0;
            if(!this._needRedraw)
            {
               return;
            }
         }
         if(this._needRedraw)
         {
            param2 = true;
         }
         this._needRedraw = false;
         var _loc4_:Array = param1.interests;
         var _loc5_:int = width - this.startOffset;
         var _loc6_:int = height - this.graph.y;
         var _loc7_:Number = param1.low;
         var _loc8_:Number = param1.hi;
         var _loc9_:Number = _loc8_ - _loc7_;
         var _loc10_:Object = {};
         var _loc11_:Boolean = false;
         if(param2)
         {
            (param1.inv ? this.highTxt : this.lowTxt).text = isNaN(param1.low) ? "" : "<low>" + param1.low + "</low>";
            (param1.inv ? this.lowTxt : this.highTxt).text = isNaN(param1.hi) ? "" : "<low>" + param1.hi + "</low>";
            this.graph.graphics.clear();
         }
         for each(_loc12_ in _loc4_)
         {
            this._interest = _loc12_;
            _loc14_ = this._interest.key;
            _loc10_[_loc14_] = true;
            _loc15_ = this._infoMap[_loc14_];
            if(_loc15_ == null)
            {
               _loc11_ = true;
               _loc15_ = new Array(this._interest.col.toString(16),new Array());
               this._infoMap[_loc14_] = _loc15_;
            }
            _loc16_ = _loc15_[1];
            if(_loc3_ == 1)
            {
               if(param1.type == GraphGroup.FPS)
               {
                  _loc19_ = Math.floor(param1.hi / this._interest.v);
                  if(_loc19_ > 30)
                  {
                     _loc19_ = 30;
                  }
                  while(_loc19_ > 0)
                  {
                     _loc16_.push(this._interest.v);
                     _loc19_--;
                  }
               }
               else
               {
                  _loc16_.push(this._interest.v);
               }
            }
            _loc17_ = int(_loc16_.length);
            _loc18_ = Math.floor(_loc5_) + 10;
            if(_loc17_ > _loc18_)
            {
               _loc16_.splice(0,_loc17_ - _loc18_);
               _loc17_ = int(_loc16_.length);
            }
            if(param2)
            {
               this.graph.graphics.lineStyle(1,this._interest.col);
               _loc20_ = _loc5_ > _loc17_ ? _loc17_ : _loc5_;
               _loc21_ = 1;
               while(_loc21_ < _loc20_)
               {
                  _loc22_ = (_loc9_ ? (_loc16_[_loc17_ - _loc21_] - _loc7_) / _loc9_ : 0.5) * _loc6_;
                  if(!param1.inv)
                  {
                     _loc22_ = _loc6_ - _loc22_;
                  }
                  if(_loc22_ < 0)
                  {
                     _loc22_ = 0;
                  }
                  if(_loc22_ > _loc6_)
                  {
                     _loc22_ = _loc6_;
                  }
                  if(_loc21_ == 1)
                  {
                     this.graph.graphics.moveTo(width,_loc22_);
                  }
                  this.graph.graphics.lineTo(_loc5_ - _loc21_,_loc22_);
                  _loc21_++;
               }
               if(isNaN(this._interest.avg) && Boolean(_loc9_))
               {
                  _loc22_ = (this._interest.avg - _loc7_) / _loc9_ * _loc6_;
                  if(!param1.inv)
                  {
                     _loc22_ = _loc6_ - _loc22_;
                  }
                  if(_loc22_ < 0)
                  {
                     _loc22_ = 0;
                  }
                  if(_loc22_ > _loc6_)
                  {
                     _loc22_ = _loc6_;
                  }
                  this.graph.graphics.lineStyle(1,this._interest.col,0.3);
                  this.graph.graphics.moveTo(0,_loc22_);
                  this.graph.graphics.lineTo(_loc5_,_loc22_);
               }
            }
         }
         for(_loc13_ in this._infoMap)
         {
            if(_loc10_[_loc13_] == undefined)
            {
               _loc11_ = true;
               delete this._infoMap[_loc13_];
            }
         }
         if(param2 && (_loc11_ || this._type))
         {
            this.updateKeyText();
         }
      }
      
      public function updateKeyText() : void
      {
         var _loc2_:String = null;
         var _loc1_:* = "<r><low>";
         if(this._type)
         {
            if(isNaN(this._interest.v))
            {
               _loc1_ += "no input<menu>";
            }
            else if(this._type == FPS)
            {
               _loc1_ += this._interest.v.toFixed(1) + " | " + this._interest.avg.toFixed(1) + " <menu><a href=\"event:reset\">R</a>";
            }
            else
            {
               _loc1_ += this._interest.v.toFixed(2) + "mb <menu><a href=\"event:gc\">G</a> <a href=\"event:reset\">R</a>";
            }
         }
         else
         {
            for(_loc2_ in this._infoMap)
            {
               _loc1_ += " <font color=\'#" + this._infoMap[_loc2_][0] + "\'>" + _loc2_ + "</font>";
            }
            _loc1_ += " | <menu><a href=\"event:reset\">R</a>";
         }
         _loc1_ += " <a href=\"event:close\">X</a></menu></low></r>";
         txtField.htmlText = _loc1_;
         txtField.scrollH = txtField.maxScrollH;
      }
      
      protected function linkHandler(param1:TextEvent) : void
      {
         TextField(param1.currentTarget).setSelection(0,0);
         if(param1.text == "reset")
         {
            this.reset();
         }
         else if(param1.text == "close")
         {
            if(this._type == FPS)
            {
               console.fpsMonitor = false;
            }
            else if(this._type == MEM)
            {
               console.memoryMonitor = false;
            }
            else
            {
               this.stop();
            }
            console.panels.removeGraph(this._group);
         }
         else if(param1.text == "gc")
         {
            console.gc();
         }
         param1.stopPropagation();
      }
      
      protected function onMenuRollOver(param1:TextEvent) : void
      {
         var _loc2_:String = param1.text ? param1.text.replace("event:","") : null;
         if(_loc2_ == "gc")
         {
            _loc2_ = "Garbage collect::Requires debugger version of flash player";
         }
         console.panels.tooltip(_loc2_,this);
      }
   }
}

