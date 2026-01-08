package net.bigpoint.as3toolbox.bplocale.structure
{
   import flash.utils.Dictionary;
   
   public class StringElement extends ContentElement
   {
      
      private var _text:String;
      
      public function StringElement()
      {
         super();
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(param1:String) : void
      {
         this._text = param1;
      }
      
      override public function getText(param1:Dictionary) : String
      {
         return this._text;
      }
   }
}

