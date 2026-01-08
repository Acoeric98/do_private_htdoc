package net.bigpoint.utils
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.bplocale.parser.IBPLocaleParser;
   
   public class BPlocaleParser4Equipment implements IBPLocaleParser
   {
      
      private static const PROPERTY_LANGUAGE_KEY:String = "key";
      
      private static const PROPERTY_DECIMAL_MARK:String = "decimalMark";
      
      private static const PROPERTY_THOUSANDS_SEPARATOR:String = "thousandsSeparator";
      
      private static const PROPERTY_SEPARATOR_PATTERN:String = "separatorPattern";
      
      private static const PROPERTY_CURRENCY_RATIO:String = "currencyRatio";
      
      private static const CATEGORY_TAG:String = "category";
      
      private static const CATEGORY_NAME:String = "name";
      
      private static const ITEM_TAG:String = "item";
      
      private static const ITEM_NAME:String = "name";
      
      private static const CONTENT_TAG:String = "content";
      
      private static const CASE_TAG:String = "case";
      
      private static const CASE_QUANTITY:String = "quantity";
      
      private static const AND_ABOVE_CHARACTER:String = "+";
      
      private static const REGEXP_PATTERN_SEPARATOR:RegExp = /,\s*/g;
      
      public function BPlocaleParser4Equipment()
      {
         super();
      }
      
      public function parseXML(param1:XML) : void
      {
         var _loc3_:String = null;
         var _loc4_:XMLList = null;
         var _loc5_:String = null;
         var _loc6_:XMLList = null;
         var _loc7_:String = null;
         var _loc8_:XMLList = null;
         var _loc9_:XMLList = null;
         var _loc10_:XML = null;
         var _loc11_:String = null;
         var _loc12_:Array = null;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:XML = null;
         var _loc16_:String = null;
         var _loc17_:int = 0;
         var _loc18_:Boolean = false;
         var _loc19_:XML = null;
         var _loc2_:XMLList = param1.elements(CATEGORY_TAG);
         _loc9_ = param1.attribute(PROPERTY_DECIMAL_MARK);
         if(_loc9_.length() > 0)
         {
            BPLocale.DECIMAL_MARK = _loc9_[0];
         }
         _loc9_ = param1.attribute(PROPERTY_THOUSANDS_SEPARATOR);
         if(_loc9_.length() > 0)
         {
            BPLocale.THOUSANDS_SEPARATOR = _loc9_[0];
         }
         _loc9_ = param1.attribute(PROPERTY_CURRENCY_RATIO);
         if(_loc9_.length() > 0)
         {
            BPLocale.CURRENCY_RATIO = Number(_loc9_[0]);
         }
         _loc9_ = param1.attribute(PROPERTY_SEPARATOR_PATTERN);
         if(_loc9_.length() > 0)
         {
            _loc11_ = _loc9_[0];
            _loc12_ = _loc11_.split(REGEXP_PATTERN_SEPARATOR);
            _loc13_ = _loc12_.length;
            BPLocale.SEPARATOR_PATTERN = new Vector.<int>(_loc13_,true);
            _loc14_ = 0;
            while(_loc14_ < _loc13_)
            {
               BPLocale.SEPARATOR_PATTERN[_loc14_] = int(_loc12_[_loc14_]);
               _loc14_++;
            }
         }
         _loc9_ = param1.attribute(PROPERTY_LANGUAGE_KEY);
         if(_loc9_.length() > 0)
         {
            BPLocale.currentLocaleID = String(_loc9_[0]);
         }
         for each(_loc10_ in _loc2_)
         {
            _loc3_ = _loc10_.attribute(CATEGORY_NAME);
            _loc4_ = _loc10_.elements(ITEM_TAG);
            for each(_loc15_ in _loc4_)
            {
               _loc7_ = "";
               _loc5_ = _loc15_.attribute(ITEM_NAME);
               if(_loc5_.length <= 0)
               {
                  throw new Error("An item in the category " + _loc3_ + " has no name. " + "Check if the name attributes for all items in this category are set.");
               }
               if(_loc15_.hasSimpleContent())
               {
                  _loc7_ = _loc15_.text();
                  BPLocale.setItemInCategory(_loc3_,_loc5_,this.removeSpecialCharMasks(_loc7_));
               }
               else
               {
                  _loc6_ = _loc15_.child(CONTENT_TAG);
                  if(_loc6_.length() <= 0)
                  {
                     throw new Error("The item " + _loc3_ + "." + _loc5_ + " has no content. " + "There is neither a <content> tag nor any text inside the <item> tag directly.");
                  }
                  if(_loc6_.hasSimpleContent())
                  {
                     _loc7_ = (_loc6_[0] as XML).text();
                     BPLocale.setItemInCategory(_loc3_,_loc5_,this.removeSpecialCharMasks(_loc7_));
                  }
                  else
                  {
                     _loc8_ = _loc6_.elements(CASE_TAG);
                     for each(_loc19_ in _loc8_)
                     {
                        _loc7_ = _loc19_.text();
                        _loc16_ = _loc19_.attribute(CASE_QUANTITY);
                        _loc18_ = false;
                        if(_loc16_.charAt(_loc16_.length - 1) == AND_ABOVE_CHARACTER)
                        {
                           _loc16_ = _loc16_.substr(0,_loc16_.length - 1);
                           _loc18_ = true;
                        }
                        _loc17_ = int(_loc16_);
                        BPLocale.setItemInCategory(_loc3_,_loc5_,this.removeSpecialCharMasks(_loc7_),_loc17_,_loc18_);
                     }
                  }
               }
            }
         }
      }
      
      private function removeSpecialCharMasks(param1:String) : String
      {
         return param1.replace(/\\n/g,"\n").replace(/\\'/g,"\'").replace(/\\"/g,"\"");
      }
   }
}

