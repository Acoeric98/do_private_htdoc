package net.bigpoint.dataInterchange
{
   public class Request
   {
      
      protected var _action:String = "";
      
      protected var _params:Object = null;
      
      protected var _serializedParameters:String = "";
      
      public function Request()
      {
         super();
         this._params = new Object();
      }
      
      public function set serializedParameters(param1:String) : void
      {
         this._serializedParameters = param1;
      }
      
      public function get serializedParameters() : String
      {
         return this._serializedParameters;
      }
      
      public function set action(param1:String) : void
      {
         this._action = param1;
      }
      
      public function get action() : String
      {
         return this._action;
      }
      
      public function set parameters(param1:Object) : void
      {
         this._params = param1;
      }
      
      public function get parameters() : Object
      {
         return this._params;
      }
   }
}

