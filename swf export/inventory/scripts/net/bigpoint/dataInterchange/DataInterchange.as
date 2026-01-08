package net.bigpoint.dataInterchange
{
   import flash.events.EventDispatcher;
   import mx.utils.Base64Encoder;
   import net.bigpoint.darkorbit.equipment.events.ActionIdentifiers;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.model.transporter.Transporter;
   import net.bigpoint.dataInterchange.connectors.HTTPConnector;
   import net.bigpoint.dataInterchange.serialization.JSONSerializer;
   
   public class DataInterchange extends EventDispatcher
   {
      
      public static const CDN_KEYS:String = "cdn";
      
      public static const ITEM_ID:String = "I";
      
      public static const ITEM_ID_CODE:String = "I_";
      
      public static const ITEM_LOOT_ID:String = "L";
      
      public static const ITEM_NAME:String = "name";
      
      public static const ITEM_QUANTITY:String = "Q";
      
      public static const ITEM_ELITE:String = "elite";
      
      public static const ITEM_ASSETS:String = "assets";
      
      public static const ITEM_REF:String = "item";
      
      public static const ITEM_SLOT:String = "S";
      
      public static const ITEM_SLOTSETS:String = "slotsets";
      
      public static const ITEM_HITPOINTS:String = "HP";
      
      public static const ITEM_SELLING:String = "selling";
      
      public static const ITEM_CREDITS_VALUE:String = "credits";
      
      public static const ITEM_URIDIUM_VALUE:String = "uridium";
      
      public static const ITEM_GROUP:String = "T";
      
      public static const ITEM_GROUP_CODE:String = "type_";
      
      public static const ITEM_GROUPS:String = "types";
      
      public static const ITEM_GROUPS_CODE:String = "types_";
      
      public static const FULL_NAME:String = "fullname";
      
      public static const TEXT_REPLACEMENTS:String = "textReplace";
      
      public static const DESC:String = "desc";
      
      public static const UNLOCKABLE_SLOTS:String = "lockedSlots";
      
      public static const DEFAULT:String = "default";
      
      public static const PROPERTIES:String = "properties";
      
      public static const PROPERTY_ATTACHED_AMMO:String = "attachedAmmo";
      
      public static const PROPERTY_HITPOINTS:String = "hitPoints";
      
      public static const PROPERTY_INSTALL_DATE:String = "installDate";
      
      public static const PROPERTY_DURABILITY_UPGRADE_LEVEL:String = "durabilityUpgradeLevel";
      
      public static const MAXIMAL_HIT_POINTS:String = "MHP";
      
      public static const DAMAGE_LEVEL:String = "DL";
      
      public static const SHIELD_LEVEL:String = "SL";
      
      public static const BOOSTER_LEVEL:String = "BL";
      
      public static const MINUTE_LEVEL:String = "ML";
      
      public static const DURABILITY_LEVEL:String = "DBL";
      
      public static const REPAIR_LEVEL:String = "RL";
      
      public static const REPAIR_COSTS:String = "RC";
      
      public static const MODULE_INSTALLED:String = "IN";
      
      public static const KEY_BATTLESTATION_NAME:String = "BN";
      
      public static const SELECTED_DESIGN:String = "SM";
      
      public static const AVAILABLE_DESIGNS:String = "M";
      
      public static const LEVEL:String = "LV";
      
      public static const LEVELS_KEY:String = "levels";
      
      public static const PET_NAME:String = "PN";
      
      public static const SHOP_DEEP_LINK:String = "C";
      
      public static const DRONE_DAMAGE:String = "damage";
      
      public static const REPAIR_PRICE:String = "repair";
      
      public static const RENAME_PRICE:String = "rename";
      
      public static const COST_WEAPON_SLOT:String = "costWeaponSlot";
      
      public static const COST_GENERATOR_SLOT:String = "costGeneratorSlot";
      
      public static const COST_GEAR_SLOT:String = "costGearSlot";
      
      public static const COST_PROTOCOL_SLOT:String = "costProtocolSlot";
      
      public static const DURABILITY:String = "DU";
      
      public static const CHARGES:String = "CH";
      
      public static const TEXT_REPLACE_KEYS:String = "textKeys";
      
      public static const LEVEL_TEXT:String = "LT";
      
      public static const DESIGN:String = "design";
      
      public static const EQUIPPED_ITEMS:String = "EQ";
      
      public static const FACTION_DEPENDED:String = "FD";
      
      public static const WORDPUZZLE_EVENTNAME:String = "puzzle";
      
      public static const WORDPUZZLE_VALUE:String = "value";
      
      public static const WORDPUZZLE_POS:String = "pos";
      
      public static const WORDPUZZLE_ID:String = "wordpuzzle-letter";
      
      public static const WORDPUZZLE_NAME_HITEC2:String = "wordpuzzles_darkorbit";
      
      public static const WORDPUZZLE_NAME_ROCCAT:String = "wordpuzzles_roccat";
      
      public static const DRONE_EFFECT:String = "EF";
      
      public static const DRONE_DESIGN:String = "DE";
      
      public static const DRONE_DESIGN_TYPE_CLASS:String = "Drone_Design_DroneDesignType";
      
      public static const DRONE_REPAIR_VALUE:String = "repair";
      
      public static const DRONE_CURRENCY:String = "currency";
      
      protected var _broker:InterchangeBroker;
      
      protected var _hangarID:int = -1;
      
      public function DataInterchange()
      {
         super();
         this._broker = new InterchangeBroker();
         var _loc1_:HTTPConnector = new HTTPConnector();
         var _loc2_:* = Settings.dynamicHost + "flashAPI/inventory.php";
         _loc1_.serverURL = _loc2_;
         this._broker.connector = _loc1_;
         this._broker.serializer = new JSONSerializer();
      }
      
      public function setHangarID(param1:uint) : void
      {
         this._hangarID = param1;
      }
      
      public function executeAction(param1:String, param2:Object, param3:Function) : void
      {
         if(this._hangarID > 0)
         {
            if(param2.params == null)
            {
               param2.params = {};
            }
            param2.params.hi = this._hangarID;
         }
         var _loc4_:Base64Encoder = new Base64Encoder();
         _loc4_.encode(param1);
         var _loc5_:String = _loc4_.toString();
         this._broker.executeAction(param1,param2,param3,this.errorOccured);
      }
      
      public function serverRequest(param1:String, param2:Object, param3:Function = null) : void
      {
         var _loc4_:Object = Object(param2);
         if(param3 != null)
         {
            this.executeAction(param1,_loc4_,param3);
         }
         else
         {
            this.executeAction(param1,_loc4_,this.answerReceived);
         }
      }
      
      public function answerReceived(param1:Transaction) : void
      {
         if(!param1.hasErrors())
         {
            dispatchEvent(new DataInterchangeEvent(DataInterchangeEvent.ACTION_REPLY_RECEIVED,param1));
         }
         else
         {
            dispatchEvent(new DataInterchangeEvent(DataInterchangeEvent.SERVER_RESPONSE_ERROR,param1));
         }
      }
      
      public function errorOccured(param1:Transaction) : void
      {
         dispatchEvent(new DataInterchangeEvent(DataInterchangeEvent.SERVER_RESPONSE_ERROR,param1));
      }
      
      public function petNameChangeRequest(param1:String, param2:Object) : void
      {
         var _loc3_:Object = Object(param2);
         this.executeAction(param1,_loc3_,this.petNameAnswerReceived);
      }
      
      private function petNameAnswerReceived(param1:Transaction) : void
      {
         if(!param1.hasErrors())
         {
            dispatchEvent(new DataInterchangeEvent(DataInterchangeEvent.PET_NAME_CHANGE_REPLY_RECEIVED,param1));
         }
         else
         {
            dispatchEvent(new DataInterchangeEvent(DataInterchangeEvent.PET_NAME_CHANGE_REPLY_RECEIVED,param1));
         }
      }
      
      public function cpuModeChange(param1:String, param2:Object) : void
      {
         var _loc3_:Object = Object(param2);
         this.executeAction(param1,_loc3_,this.cpuModeChangeAnswer);
      }
      
      private function cpuModeChangeAnswer(param1:Transaction) : void
      {
         if(!param1.hasErrors())
         {
            dispatchEvent(new DataInterchangeEvent(DataInterchangeEvent.CPU_MODE_CHANGE_REPLY,param1));
         }
         else
         {
            this.dispatchServerResponseError(param1);
         }
      }
      
      public function designChangeRequest(param1:String, param2:Object) : void
      {
         var _loc3_:Object = Object(param2);
         this.executeAction(param1,_loc3_,this.designAnswerReceived);
      }
      
      private function designAnswerReceived(param1:Transaction) : void
      {
         if(!param1.hasErrors())
         {
            dispatchEvent(new DataInterchangeEvent(DataInterchangeEvent.DESIGN_CHANGE_REPLY_RECEIVED,param1));
         }
         else
         {
            this.dispatchServerResponseError(param1);
         }
      }
      
      public function fetchConfig(param1:int) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.nr = param1;
         this.executeAction("init",_loc2_,this.configReceived);
      }
      
      public function configReceived(param1:Transaction) : void
      {
         if(!param1.hasErrors())
         {
            dispatchEvent(new DataInterchangeEvent(DataInterchangeEvent.CONFIG_RECEIVED,param1));
         }
         else
         {
            this.dispatchServerResponseError(param1);
         }
      }
      
      public function clearShipEquipmentConfiguration(param1:int) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.configID = param1;
         _loc2_.wipe = 1;
         this.executeAction(ActionIdentifiers.CLEAR_EQUIPMENT_CONFIG,_loc2_,this.clearEquipmentConfigurationResponseHandler);
      }
      
      protected function clearEquipmentConfigurationResponseHandler(param1:Transaction) : void
      {
         if(!param1.hasErrors())
         {
            dispatchEvent(new DataInterchangeEvent(DataInterchangeEvent.SHIP_CONFIG_CLEARED_REPLY_RECEIVED,param1));
         }
         else
         {
            this.dispatchServerResponseError(param1);
         }
      }
      
      public function equipItemsToNDrones(param1:Transporter) : void
      {
         this.executeAction(param1.action,param1,this.equipDronesItemsResponseHandler);
      }
      
      protected function equipDronesItemsResponseHandler(param1:Transaction) : void
      {
         if(!param1.hasErrors())
         {
            dispatchEvent(new DataInterchangeEvent(DataInterchangeEvent.DRONE_ITEMS_EQUIPPED_REPLY_RECEIVED,param1));
         }
         else
         {
            this.dispatchServerResponseError(param1);
         }
      }
      
      private function dispatchServerResponseError(param1:Transaction) : void
      {
         dispatchEvent(new DataInterchangeEvent(DataInterchangeEvent.SERVER_RESPONSE_ERROR,param1));
      }
   }
}

