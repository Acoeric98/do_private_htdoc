package net.bigpoint.darkorbit.equipment.model.VO.item
{
   import flash.utils.Dictionary;
   
   public class ItemInfoVO
   {
      
      public var loka:Dictionary = new Dictionary();
      
      public var lootID:String;
      
      public var name:String;
      
      public var group:ItemGroupVO;
      
      public var assets:Object;
      
      public var elite:Boolean;
      
      public var slotSetRawInfo:Object;
      
      public var rawSlotSetInfoByLevel:Array = [];
      
      public var cdnHashesByLevel:Array = [];
      
      public var acceptedItemGroups:Array = [];
      
      public var saleValuesByLevel:Array = [];
      
      public var saleValue:Number;
      
      public var sellable:Boolean = true;
      
      public var graphicKey:String;
      
      public var shopDeepLink:String;
      
      public var repairPrice:int;
      
      public var renamePrice:int;
      
      public var replacementText:Dictionary = new Dictionary();
      
      public var replacePattern:Dictionary = new Dictionary();
      
      public var factionDepended:String = "";
      
      public var factionID:String = "";
      
      public var textReplacements:Object;
      
      public function ItemInfoVO()
      {
         super();
      }
      
      public function defineLokaKeysInfo() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         for(_loc1_ in ItemLocalisationKeys.LOCA_ITEM_KEYS)
         {
            _loc2_ = ItemLocalisationKeys.LOCA_ITEM_KEYS[_loc1_];
            _loc3_ = "items" + "_" + this.lootID + "_" + _loc2_;
            this.loka[_loc2_] = _loc3_;
         }
      }
      
      public function populateCdnDictionary(param1:int, param2:Object) : void
      {
         var _loc4_:String = null;
         var _loc3_:Dictionary = new Dictionary();
         for(_loc4_ in param2)
         {
            _loc3_[_loc4_] = param2[_loc4_];
         }
         this.cdnHashesByLevel[param1] = _loc3_;
      }
      
      public function checkIfItemSellable() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.saleValuesByLevel.length)
         {
            if(this.saleValuesByLevel[_loc1_] == 0)
            {
               this.sellable = false;
               return;
            }
            _loc1_++;
         }
      }
      
      public function populateReplacementTextKeysDict(param1:int, param2:Object) : void
      {
         var _loc3_:String = null;
         for(_loc3_ in param2)
         {
            this.replacePattern[param1] = _loc3_;
            this.replacementText[param1] = param2[_loc3_];
         }
      }
   }
}

