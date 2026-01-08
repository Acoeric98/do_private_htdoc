package net.bigpoint.as3toolbox.bplocale.parser
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class XMLParserOld implements IBPLocaleParser
   {
      
      private static const ITEM_TAG:String = "item";
      
      private static const ITEM_NAME:String = "name";
      
      public function XMLParserOld()
      {
         super();
      }
      
      public function parseXML(param1:XML) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:XML = null;
         var _loc2_:XMLList = param1.elements(ITEM_TAG);
         for each(_loc5_ in _loc2_)
         {
            _loc4_ = "";
            _loc3_ = _loc5_.attribute(ITEM_NAME);
            if(_loc3_.length <= 0)
            {
               throw new Error("An item has no name. " + "Check if the name attributes for all items in the file are set.");
            }
            if(_loc5_.hasSimpleContent())
            {
               _loc4_ = _loc5_.text();
               BPLocale.setItemInCategory("",_loc3_,_loc4_);
            }
         }
      }
   }
}

