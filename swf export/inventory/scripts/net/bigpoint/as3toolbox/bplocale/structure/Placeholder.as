package net.bigpoint.as3toolbox.bplocale.structure
{
   import flash.utils.Dictionary;
   
   public class Placeholder extends ContentElement
   {
      
      private static const REGEXP_KEYNAME:RegExp = /\w+(?:\.\w+)*/;
      
      public static const REGEXP_INTEGER:RegExp = /-?\d/;
      
      private static const REGEXP_PLACEHOLDER:RegExp = new RegExp("\\{\\$?" + REGEXP_KEYNAME.source + "(?:\\|(?:" + REGEXP_KEYNAME.source + "|" + REGEXP_INTEGER.source + "|\\{" + REGEXP_KEYNAME.source + "\\})+)*\\}");
      
      private static const REGEXP_SPLIT:RegExp = new RegExp("(" + REGEXP_PLACEHOLDER.source + ")","g");
      
      private static const PARAMETER_SEPARATOR:String = "|";
      
      private static const USER_PLACEHOLDER_CHARACTER:String = "$";
      
      private static const TYPE_NUMBER:String = "Number";
      
      private static const TYPE_DATETIME:String = "DateTime";
      
      private static const TYPE_PRICE:String = "Price";
      
      private static const TYPE_TIMESPAN:String = "Timespan";
      
      private var _name:String;
      
      public function Placeholder()
      {
         super();
      }
      
      public static function parseIntParameter(param1:*) : *
      {
         var _loc2_:String = null;
         if(param1 is int || param1 is Placeholder)
         {
            return param1;
         }
         if(param1 is String)
         {
            _loc2_ = param1 as String;
            if(REGEXP_INTEGER.test(param1))
            {
               return param1;
            }
            return Placeholder.convertToPlaceholder(_loc2_);
         }
      }
      
      public static function retrieveIntParameter(param1:*, param2:Dictionary) : int
      {
         var _loc3_:int = 0;
         var _loc4_:Placeholder = null;
         if(param1 is Placeholder)
         {
            _loc4_ = param1 as Placeholder;
            _loc3_ = int(_loc4_.getText(param2));
         }
         else if(param1 is String || param1 is uint || param1 is Number)
         {
            _loc3_ = int(param1);
         }
         else
         {
            if(!(param1 is int))
            {
               throw new Error("Could not retrieve integer parameter " + param1 + ".");
            }
            _loc3_ = param1;
         }
         return _loc3_;
      }
      
      public static function splitByPlaceholders(param1:String) : Array
      {
         return param1.split(REGEXP_SPLIT);
      }
      
      public static function isPlaceholder(param1:String) : Boolean
      {
         return Boolean(REGEXP_PLACEHOLDER.test(param1));
      }
      
      public static function convertToPlaceholder(param1:String) : Placeholder
      {
         var _loc7_:String = null;
         var _loc8_:Placeholder = null;
         var _loc9_:NumberPlaceholder = null;
         var _loc10_:TimespanPlaceholder = null;
         var _loc11_:PricePlaceholder = null;
         var _loc12_:DatePlaceholder = null;
         var _loc13_:SystemPlaceholder = null;
         var _loc2_:String = param1;
         if(isPlaceholder(_loc2_))
         {
            _loc2_ = _loc2_.substring(1,_loc2_.length - 1);
         }
         var _loc3_:Array = _loc2_.split(PARAMETER_SEPARATOR);
         var _loc4_:String = _loc3_[0] as String;
         var _loc5_:* = _loc4_.charAt(0) == USER_PLACEHOLDER_CHARACTER;
         if(!_loc5_)
         {
            if(SystemPlaceholder.isSystemPlaceholder(_loc4_))
            {
               _loc13_ = new SystemPlaceholder();
               _loc13_.name = _loc4_;
               return _loc13_;
            }
            var _loc6_:ReferencePlaceholder = new ReferencePlaceholder();
            _loc6_.name = _loc4_;
            _loc6_.reference = _loc4_;
            _loc6_.quantity = _loc3_[1];
            return _loc6_;
         }
         _loc7_ = _loc3_[1];
         switch(_loc7_)
         {
            case TYPE_NUMBER:
               _loc9_ = new NumberPlaceholder();
               _loc9_.name = _loc4_;
               if(_loc3_.length > 2)
               {
                  _loc9_.precision = _loc3_[2];
               }
               return _loc9_;
            case TYPE_DATETIME:
               _loc12_ = new DatePlaceholder();
               _loc12_.name = _loc4_;
               _loc12_.format = _loc3_[2];
               return _loc12_;
            case TYPE_PRICE:
               _loc11_ = new PricePlaceholder();
               _loc11_.name = _loc4_;
               _loc11_.format = _loc3_[2];
               return _loc11_;
            case TYPE_TIMESPAN:
               _loc10_ = new TimespanPlaceholder();
               _loc10_.name = _loc4_;
               _loc10_.format = _loc3_[2];
               if(_loc3_.length > 3)
               {
                  _loc10_.units = _loc3_[3];
               }
               return _loc10_;
            default:
               _loc8_ = new Placeholder();
               _loc8_.name = _loc4_;
               return _loc8_;
         }
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
      }
      
      override public function getText(param1:Dictionary) : String
      {
         return param1[this._name];
      }
   }
}

