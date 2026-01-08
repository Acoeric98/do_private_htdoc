package net.bigpoint.as3toolbox.bplocale.structure
{
   import flash.utils.Dictionary;
   
   public class Item
   {
      
      private var _name:String;
      
      private var _content:Vector.<Content>;
      
      public function Item(param1:String)
      {
         super();
         this._name = param1;
         this._content = new Vector.<Content>();
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function link() : void
      {
         var _loc1_:uint = this._content.length;
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_)
         {
            this._content[_loc2_].link();
            _loc2_++;
         }
      }
      
      public function setContent(param1:String, param2:int = 0, param3:Boolean = true) : void
      {
         var _loc4_:uint = 0;
         var _loc6_:int = 0;
         var _loc9_:Content = null;
         var _loc5_:uint = this._content.length;
         var _loc7_:Content = null;
         var _loc8_:Content = null;
         var _loc10_:String = param1.replace(/<br>/g,"\n");
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_ = _loc7_ = this._content[_loc4_];
            _loc6_ = _loc7_.quantity;
            if(param2 == _loc6_)
            {
               _loc7_.setText(_loc10_);
               _loc7_.andUpwards = param3;
               return;
            }
            if(_loc6_ > param2)
            {
               _loc9_ = new Content(_loc10_,param2,param3);
               this._content.splice(_loc4_ > 0 ? _loc4_ - 1 : 0,0,_loc9_);
               return;
            }
            _loc4_++;
         }
         _loc9_ = new Content(_loc10_,param2,param3);
         this._content.push(_loc9_);
      }
      
      public function getContentObject(param1:int = 0) : Content
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = this._content.length;
         var _loc4_:int = int.MIN_VALUE;
         var _loc5_:Content = null;
         var _loc6_:Content = null;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = _loc5_;
            _loc5_ = this._content[_loc2_];
            _loc4_ = _loc5_.quantity;
            if(_loc4_ == param1)
            {
               return _loc5_;
            }
            if(_loc4_ > param1)
            {
               return _loc6_ != null && _loc6_.andUpwards ? _loc6_ : null;
            }
            _loc2_++;
         }
         return _loc5_ != null && _loc5_.andUpwards ? _loc5_ : null;
      }
      
      public function getContent(param1:Dictionary = null, param2:int = 0) : String
      {
         var _loc3_:Content = this.getContentObject(param2);
         var _loc4_:Dictionary = param1;
         if(_loc4_ == null)
         {
            _loc4_ = new Dictionary();
         }
         _loc4_[SystemPlaceholder.SYSTEM_QUANTITY] = param2;
         return _loc3_.getText(_loc4_);
      }
   }
}

