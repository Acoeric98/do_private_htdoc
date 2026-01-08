package net.bigpoint.as3toolbox.bplocale
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.parser.BPLocaleParser;
   import net.bigpoint.as3toolbox.bplocale.parser.IBPLocaleParser;
   import net.bigpoint.as3toolbox.bplocale.parser.XMLParserNew;
   import net.bigpoint.as3toolbox.bplocale.parser.XMLParserOld;
   import net.bigpoint.as3toolbox.bplocale.structure.Item;
   import net.bigpoint.as3toolbox.bplocale.structure.NumberPlaceholder;
   
   public class BPLocale
   {
      
      private static var _currentLocaleID:String;
      
      private static var _currentLanguageLoader:URLLoader;
      
      private static var _currentURLRequest:URLRequest;
      
      private static var _ed:EventDispatcher;
      
      public static var CURRENCY_RATIO:Number;
      
      public static const ON_FAIL_ERROR:uint = 0;
      
      public static const ON_FAIL_EVENT:uint = 1;
      
      public static const ON_FAIL_NOTHING:uint = 2;
      
      private static var _xmlPathQueue:Vector.<String> = new Vector.<String>();
      
      private static var _dictionary:Dictionary = new Dictionary();
      
      private static var _parser:IBPLocaleParser = new XMLParserNew();
      
      public static var THOUSANDS_SEPARATOR:String = ",";
      
      public static var DECIMAL_MARK:String = ".";
      
      public static var SEPARATOR_PATTERN:Vector.<int> = initSeparatorPattern();
      
      private static var _onFailMode:uint = ON_FAIL_ERROR;
      
      public function BPLocale()
      {
         super();
      }
      
      private static function initSeparatorPattern() : Vector.<int>
      {
         var _loc1_:Vector.<int> = new Vector.<int>();
         _loc1_.push(3);
         return _loc1_;
      }
      
      public static function setXMLParser(param1:uint) : void
      {
         switch(param1)
         {
            case BPLocaleParser.BPLOCALE_PARSER_2007:
               _parser = new XMLParserOld();
               break;
            case BPLocaleParser.BPLOCALE_PARSER_2011:
               _parser = new XMLParserNew();
               break;
            default:
               throw new Error("Could not find a parser associated with the parameter \"" + param1 + "\"");
         }
      }
      
      public static function setParser(param1:IBPLocaleParser) : void
      {
         if(!param1)
         {
            throw new Error("IBPLocaleParser is null");
         }
         _parser = param1;
      }
      
      public static function get thousandsSeparator() : String
      {
         return THOUSANDS_SEPARATOR;
      }
      
      public static function set thousandsSeparator(param1:String) : void
      {
         THOUSANDS_SEPARATOR = param1;
      }
      
      public static function get decimalMark() : String
      {
         return DECIMAL_MARK;
      }
      
      public static function set decimalMark(param1:String) : void
      {
         DECIMAL_MARK = param1;
      }
      
      public static function get currentLocaleID() : String
      {
         return _currentLocaleID;
      }
      
      public static function set currentLocaleID(param1:String) : void
      {
         _currentLocaleID = param1;
      }
      
      public static function get onFailMode() : uint
      {
         return _onFailMode;
      }
      
      public static function set onFailMode(param1:uint) : void
      {
         _onFailMode = param1;
      }
      
      public static function formatNumber(param1:Number, param2:uint = 0) : String
      {
         var _loc3_:NumberPlaceholder = new NumberPlaceholder();
         _loc3_.precision = param2;
         _loc3_.name = "$number";
         return _loc3_.getText(turnIntoDictionary("number",param1));
      }
      
      public static function load(... rest) : void
      {
         var _loc4_:String = null;
         var _loc2_:Array = rest.length == 1 && rest[0] is Array ? rest[0] : rest;
         var _loc3_:uint = _loc2_.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = _loc2_[_loc5_] as String;
            if(_loc4_ == null)
            {
               throw new Error("BPLocale: couldn\'t load XML localization file: " + _loc2_[_loc5_] + " is not a valid string Object.");
            }
            addPathToQueue(_loc4_);
            _loc5_++;
         }
      }
      
      private static function addPathToQueue(param1:String) : void
      {
         var _loc2_:uint = _xmlPathQueue.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            if(_xmlPathQueue[_loc3_] == param1)
            {
               dispatchEvent(new BPLocaleEvent(BPLocaleEvent.LANGUAGE_ALREADY_IN_QUEUE,param1));
               return;
            }
            _loc3_++;
         }
         _xmlPathQueue.push(param1);
         if(_currentLanguageLoader == null)
         {
            loadNextLanguage();
         }
      }
      
      public static function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         if(_ed == null)
         {
            _ed = new EventDispatcher();
         }
         _ed.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public static function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         if(_ed == null)
         {
            return;
         }
         _ed.removeEventListener(param1,param2,param3);
      }
      
      public static function dispatchEvent(param1:Event) : void
      {
         if(_ed == null)
         {
            _ed = new EventDispatcher();
         }
         _ed.dispatchEvent(param1);
      }
      
      private static function loadNextLanguage() : void
      {
         if(_currentLanguageLoader != null)
         {
            _currentLanguageLoader.removeEventListener(Event.COMPLETE,languageLoaded);
            _currentLanguageLoader.removeEventListener(IOErrorEvent.IO_ERROR,errorLoadingLanguage);
            _currentLanguageLoader = null;
            _currentURLRequest = null;
         }
         if(_xmlPathQueue.length <= 0)
         {
            linkDictionary();
            dispatchEvent(new BPLocaleEvent(BPLocaleEvent.NO_LANGUAGES_LEFT_TO_LOAD));
            return;
         }
         var _loc1_:String = _xmlPathQueue.shift();
         _currentLanguageLoader = new URLLoader();
         _currentLanguageLoader.addEventListener(Event.COMPLETE,languageLoaded);
         _currentLanguageLoader.addEventListener(IOErrorEvent.IO_ERROR,errorLoadingLanguage);
         _currentURLRequest = new URLRequest(_loc1_);
         _currentLanguageLoader.load(_currentURLRequest);
      }
      
      private static function errorLoadingLanguage(param1:IOErrorEvent) : void
      {
         _ed.dispatchEvent(new BPLocaleEvent(BPLocaleEvent.LANGUAGE_LOADING_ERROR,param1.text));
         loadNextLanguage();
      }
      
      private static function languageLoaded(param1:Event) : void
      {
         var _loc2_:XML = new XML((param1.target as URLLoader).data);
         if(_parser != null)
         {
            _parser.parseXML(_loc2_);
            dispatchEvent(new BPLocaleEvent(BPLocaleEvent.LANGUAGELOADED,_currentURLRequest.url));
            loadNextLanguage();
            return;
         }
         throw new Error("No IBPLocaleParser has been found. BPLocale.PARSER is null.");
      }
      
      public static function addXMLObject(param1:XML) : void
      {
         _parser.parseXML(param1);
         linkDictionary();
      }
      
      public static function addDictionaryToCategory(param1:String, param2:Dictionary) : void
      {
         var _loc3_:String = null;
         for(_loc3_ in param2)
         {
            setItemInCategory(param1,_loc3_,param2[_loc3_]);
         }
      }
      
      public static function addDictionary(param1:Dictionary) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in param1)
         {
            setItem(_loc2_,param1[_loc2_]);
         }
      }
      
      public static function linkDictionary() : void
      {
         var _loc1_:Dictionary = null;
         var _loc2_:Item = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         for(_loc3_ in _dictionary)
         {
            _loc1_ = _dictionary[_loc3_] as Dictionary;
            for(_loc4_ in _loc1_)
            {
               _loc2_ = _loc1_[_loc4_] as Item;
               _loc2_.link();
            }
         }
      }
      
      public static function turnIntoDictionary(... rest) : Dictionary
      {
         var _loc2_:Dictionary = new Dictionary();
         var _loc3_:uint = uint(rest.length);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_ - 1)
         {
            _loc2_["$" + rest[_loc4_]] = rest[_loc4_ + 1];
            _loc4_ += 2;
         }
         return _loc2_;
      }
      
      public static function setItem(param1:String, param2:String, param3:int = 0, param4:Boolean = true) : void
      {
         var _loc7_:String = null;
         var _loc5_:Array = param1.split(/\.(\w+$)/);
         var _loc6_:String = "";
         if(_loc5_.length > 1)
         {
            _loc6_ = _loc5_[0];
            _loc7_ = _loc5_[1];
         }
         else
         {
            _loc7_ = _loc5_[0];
         }
         setItemInCategory(_loc6_,_loc7_,param2,param3,param4);
      }
      
      public static function setItemInCategory(param1:String, param2:String, param3:String, param4:int = 0, param5:Boolean = true) : void
      {
         var _loc6_:Dictionary = null;
         var _loc7_:Item = null;
         if(_dictionary.hasOwnProperty(param1))
         {
            _loc6_ = _dictionary[param1];
         }
         else
         {
            _loc6_ = new Dictionary();
            _dictionary[param1] = _loc6_;
         }
         if(_loc6_.hasOwnProperty(param2))
         {
            _loc7_ = _loc6_[param2] as Item;
         }
         else
         {
            _loc7_ = new Item(param2);
            _loc6_[param2] = _loc7_;
         }
         _loc7_.setContent(param3,param4,param5);
      }
      
      public static function getItem(param1:String, param2:Dictionary = null, param3:int = 0) : String
      {
         var _loc6_:String = null;
         var _loc4_:Array = param1.split(/\.(\w+$)/);
         var _loc5_:String = "";
         if(_loc4_.length > 1)
         {
            _loc5_ = _loc4_[0];
            _loc6_ = _loc4_[1];
         }
         else
         {
            _loc6_ = _loc4_[0];
         }
         return getItemInCategory(_loc5_,_loc6_,param2,param3);
      }
      
      public static function getItemObject(param1:String) : Item
      {
         var _loc2_:Array = param1.split(/\.(\w+$)/);
         if(_loc2_.length <= 1)
         {
            throw new Error(param1 + " is not a valid key to retrieve an item from a category. Category and item name need to be separated with a \'.\' character.");
         }
         return getItemObjectInCategory(_loc2_[0],_loc2_[1]);
      }
      
      public static function getItemInCategory(param1:String, param2:String, param3:Dictionary = null, param4:int = 0) : String
      {
         var _loc5_:Item = getItemObjectInCategory(param1,param2);
         return _loc5_ != null ? _loc5_.getContent(param3,param4) : "{" + param1 + (param1.length > 0 ? "." : "") + param2 + "}";
      }
      
      public static function getItemObjectInCategory(param1:String, param2:String) : Item
      {
         var _loc3_:Dictionary = null;
         var _loc4_:Item = null;
         if(!_dictionary.hasOwnProperty(param1))
         {
            switch(_onFailMode)
            {
               case ON_FAIL_ERROR:
                  throw new Error("BPLocale Error: Cannot find category \'" + param1 + "\' while trying to retrieve item \'" + param2 + "\'.");
               case ON_FAIL_EVENT:
                  dispatchEvent(new BPLocaleEvent(BPLocaleEvent.CATEGORY_NOT_FOUND,"BPLocale could not find category \'" + param1 + "\' while trying to retrieve item \'" + param2 + "\'."));
            }
            return null;
         }
         _loc3_ = _dictionary[param1];
         if(!_loc3_.hasOwnProperty(param2))
         {
            switch(_onFailMode)
            {
               case ON_FAIL_ERROR:
                  throw new Error("BPLocale Error: Cannot find item \'" + param2 + "\' in category \'" + param1 + "\'.");
               case ON_FAIL_EVENT:
                  dispatchEvent(new BPLocaleEvent(BPLocaleEvent.KEY_NOT_FOUND,"BPLocale could not find item \'" + param2 + "\' in category \'" + param1 + "\'."));
            }
            return null;
         }
         return _loc3_[param2] as Item;
      }
   }
}

