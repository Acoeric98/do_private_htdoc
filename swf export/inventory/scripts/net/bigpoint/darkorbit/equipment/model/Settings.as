package net.bigpoint.darkorbit.equipment.model
{
   import org.puremvc.as3.interfaces.IProxy;
   import org.puremvc.as3.patterns.proxy.Proxy;
   
   public class Settings extends Proxy implements IProxy
   {
      
      public static var dynamicHost:String;
      
      public static var userID:int;
      
      public static var cdnHost:String;
      
      public static var presetCount:String;
      
      public static var activePreset:String;
      
      public static var slotsShip:String;
      
      public static var drones:String;
      
      public static var extraSlotsShip:String;
      
      public static var droneRepairFee:String;
      
      public static var vouchers:String;
      
      public static var loadingClima:String;
      
      public static var serverNature:String;
      
      public static var checkoutName:String;
      
      public static var employeeID:String;
      
      public static var projectID:String;
      
      public static var username:String;
      
      public static var password:String;
      
      public static var baseServerName:String;
      
      public static var instance:int;
      
      public static var defaultNumberOfExtrasSlots:int;
      
      public static const PROXY_NAME:String = "Settings";
      
      public static const INVENTORY_NAME:String = "inventory";
      
      public static const ACCORDION_NAME:String = "accordion";
      
      public static const WINDOW_WIDTH:Number = 770;
      
      public static const WINDOW_HEIGHT:Number = 395;
      
      public static var language:String = "dev";
      
      public static var activeConfig:int = 1;
      
      public static var inventoryOpen:Boolean = false;
      
      public static var USER_HAS_DRONES:Boolean = false;
      
      public static var USER_HAS_PET:Boolean = true;
      
      public static var DRONE_REPAIR_COST:int = 0;
      
      public static var DRONE_REPAIR_COSTS:Array = [];
      
      public static var PET_RENAME_COST:int = 0;
      
      public static var PET_LASER_SLOT_PRICES:Array = [];
      
      public static var PET_GENERATOR_SLOT_PRICES:Array = [];
      
      public static var PET_GEAR_SLOT_PRICES:Array = [];
      
      public static var PET_PROTOCOL_SLOT_PRICES:Array = [];
      
      public static var useEmbeddedFonts:Boolean = true;
      
      public function Settings(param1:String = null)
      {
         super(param1,null);
      }
      
      public static function get inactiveConfig() : int
      {
         return activeConfig == 1 ? 2 : 1;
      }
   }
}

