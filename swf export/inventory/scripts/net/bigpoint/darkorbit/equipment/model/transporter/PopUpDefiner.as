package net.bigpoint.darkorbit.equipment.model.transporter
{
   public class PopUpDefiner
   {
      
      public static const SELL_POPUP:String = "SELL_POPUP";
      
      public static const SELL_SHIP_POPUP:String = "SELL_SHIP_POPUP";
      
      public static const SPLIT_STACK_POPUP:String = "SPLIT_STACK_POPUP";
      
      public static const BUYABLE_SLOT_POPUP:String = "BUYABLE_SLOT_POPUP";
      
      public static const REPAIR_ITEM_POPUP:String = "REPAIR_ITEM_POPUP";
      
      public static const REPAIR_MODULE_POPUP:String = "REPAIR_MODULE_POPUP";
      
      public static const RENAME_PET:String = "RENAME_PET";
      
      public static const QUICK_BUY_ITEM:String = "QUICK_BUY_ITEM";
      
      public static const AMMO_CPU_CHOICE:String = "AMMO_CPU_CHOICE";
      
      public static const ERROR_POPUP:String = "ERROR_POPUP";
      
      public static const CLEAR_SHIP_CONFIG_CONFIRMATION_POPUP:String = "CLEAR_SHIP_CONFIG_CONFIRMATION_POPUP";
      
      public var popUpType:String;
      
      public var itemType:String;
      
      public var callback:Function;
      
      public var callbackParams:Object;
      
      public var cleanUpCallback:Function;
      
      public var errorMessage:String;
      
      public var buttonText:String;
      
      public var transporter:Object;
      
      public function PopUpDefiner()
      {
         super();
      }
   }
}

