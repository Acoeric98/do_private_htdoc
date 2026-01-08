package net.bigpoint.as3toolbox.bplocale.structure
{
   import flash.utils.Dictionary;
   
   internal class Content
   {
      
      private var _contentElements:Vector.<ContentElement>;
      
      private var _quantity:int;
      
      private var _andUpwards:Boolean;
      
      public function Content(param1:String, param2:int = 0, param3:Boolean = false)
      {
         super();
         this._contentElements = this.disassembleText(param1);
         this._quantity = param2;
         this._andUpwards = param3;
      }
      
      public function get quantity() : int
      {
         return this._quantity;
      }
      
      public function set quantity(param1:int) : void
      {
         this._quantity = param1;
      }
      
      public function get andUpwards() : Boolean
      {
         return this._andUpwards;
      }
      
      public function set andUpwards(param1:Boolean) : void
      {
         this._andUpwards = param1;
      }
      
      public function link() : void
      {
         var _loc2_:Placeholder = null;
         var _loc1_:uint = this._contentElements.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = this._contentElements[_loc3_] as Placeholder;
            if(_loc2_ != null)
            {
               _loc2_.link();
            }
            _loc3_++;
         }
      }
      
      public function setText(param1:String) : void
      {
         this._contentElements = this.disassembleText(param1);
      }
      
      public function getText(param1:Dictionary) : String
      {
         var _loc2_:uint = this._contentElements.length;
         var _loc3_:String = "";
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ += this._contentElements[_loc4_].getText(param1);
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function disassembleText(param1:String) : Vector.<ContentElement>
      {
         var _loc4_:ContentElement = null;
         var _loc5_:String = null;
         var _loc8_:StringElement = null;
         var _loc2_:Vector.<ContentElement> = new Vector.<ContentElement>();
         var _loc3_:Array = Placeholder.splitByPlaceholders(param1);
         var _loc6_:uint = _loc3_.length;
         var _loc7_:uint = 0;
         while(_loc7_ < _loc6_)
         {
            _loc4_ = null;
            _loc5_ = _loc3_[_loc7_];
            if(Placeholder.isPlaceholder(_loc5_))
            {
               _loc4_ = Placeholder.convertToPlaceholder(_loc5_);
            }
            else
            {
               _loc8_ = new StringElement();
               _loc8_.text = _loc3_[_loc7_];
               _loc4_ = _loc8_;
            }
            if(_loc4_ == null)
            {
               throw new Error("Trying to add a null reference as element to content vector in content string \'" + param1 + "\'");
            }
            _loc2_.push(_loc4_);
            _loc7_++;
         }
         return _loc2_;
      }
   }
}

