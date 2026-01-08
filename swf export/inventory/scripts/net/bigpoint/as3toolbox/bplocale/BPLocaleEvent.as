package net.bigpoint.as3toolbox.bplocale
{
   import flash.events.Event;
   
   public class BPLocaleEvent extends Event
   {
      
      public static const LANGUAGELOADED:String = "BPLocaleEvent.onLanguageLoaded";
      
      public static const LANGUAGE_LOADING_ERROR:String = "BPLocaleEvent.onLanguageLoadingError";
      
      public static const NO_LANGUAGES_LEFT_TO_LOAD:String = "BPLocaleEvent.onNoLanguagesLeftToLoad";
      
      public static const LANGUAGE_ALREADY_IN_QUEUE:String = "BPLocaleEvent.onLanguageAlreadyInQueue";
      
      public static const KEY_OVERWRITTEN:String = "BPLocaleEvent.onKeyOverwritten";
      
      public static const KEY_NOT_FOUND:String = "BPLocaleEvent.onKeyNotFound";
      
      public static const CATEGORY_NOT_FOUND:String = "BPLocaleEvent.onCategoryNotFound";
      
      private var _text:String;
      
      private var _key:String;
      
      public function BPLocaleEvent(param1:String, param2:String = "", param3:String = "", param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param4,param5);
         this._text = param2;
         this._key = param3;
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(param1:String) : void
      {
         this._text = param1;
      }
      
      public function get key() : String
      {
         return this._key;
      }
      
      public function set key(param1:String) : void
      {
         this._key = param1;
      }
   }
}

