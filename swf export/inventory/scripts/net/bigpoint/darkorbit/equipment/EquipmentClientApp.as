package net.bigpoint.darkorbit.equipment
{
   import com.soenkerohde.logging.SOSLoggingTarget;
   import flash.display.Sprite;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuBuiltInItems;
   import flash.ui.ContextMenuItem;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.equipment.application.ApplicationConsole;
   import net.bigpoint.darkorbit.equipment.application.ApplicationFacade;
   import net.bigpoint.darkorbit.equipment.model.managers.ExternalInterfaceManager;
   import net.bigpoint.utils.SWFWheel;
   import net.bigpoint.utils.Version;
   
   public class EquipmentClientApp extends Sprite
   {
      
      private var appContextMenu:ContextMenu;
      
      private var mouseWheelTrapped:Boolean;
      
      public function EquipmentClientApp()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.initContextmenu();
         var _loc1_:ApplicationFacade = ApplicationFacade.getInstance();
         _loc1_.startup(this.stage);
         SWFWheel.initialize(stage);
         SWFWheel.browserScroll = false;
      }
      
      private function initContextmenu() : void
      {
         this.appContextMenu = new ContextMenu();
         this.removeDefaultItems();
         this.addCustomMenuItems();
         this.contextMenu = this.appContextMenu;
      }
      
      private function removeDefaultItems() : void
      {
         this.appContextMenu.hideBuiltInItems();
         var _loc1_:ContextMenuBuiltInItems = this.appContextMenu.builtInItems;
         _loc1_.print = true;
      }
      
      private function addCustomMenuItems() : void
      {
         var _loc1_:String = Version.getVersion();
         var _loc2_:ContextMenuItem = new ContextMenuItem(_loc1_);
         this.appContextMenu.customItems.push(_loc2_);
      }
      
      private function allowBrowserScroll(param1:Boolean) : void
      {
         this.createMouseWheelTrap();
         ExternalInterfaceManager.activateBrowserScrolling(param1);
      }
      
      private function createMouseWheelTrap() : void
      {
         if(this.mouseWheelTrapped)
         {
            return;
         }
         this.mouseWheelTrapped = true;
         ExternalInterfaceManager.createBrowserScrollingFunctionality();
      }
      
      public function initLogger() : void
      {
         var _loc1_:SOSLoggingTarget = new SOSLoggingTarget();
         _loc1_.server = "localhost";
         Log.addTarget(_loc1_);
      }
      
      private function initConsole() : void
      {
         new ApplicationConsole(this);
      }
   }
}

