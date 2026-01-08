package net.bigpoint.darkorbit.equipment.application
{
   import com.greensock.TweenMax;
   import com.junkbyte.console.Cc;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import net.bigpoint.darkorbit.equipment.model.ConnectionProxy;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.model.VO.Inventory;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInfoVO;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInstanceVO;
   import net.bigpoint.darkorbit.equipment.model.managers.HangarManagerProxy;
   
   public class ApplicationConsole
   {
      
      private static const CONSOL_COMMAND__SET_HANGAR:String = "setHangar";
      
      private static const CONSOL_COMMAND__GET_ITEM_INFO:String = "getItemInfo";
      
      private static const CONSOL_COMMAND__GET_ITEM_DETAIL_INFO:String = "getItemDetailInfo";
      
      private var CONSOLE_HEIGHT:int = 240;
      
      private var password:String = "";
      
      private var isVisible:Boolean = true;
      
      private var parent:Sprite;
      
      public function ApplicationConsole(param1:Sprite)
      {
         super();
         this.initialize(param1);
      }
      
      public function initialize(param1:Sprite) : void
      {
         this.parent = param1;
         Cc.startOnStage(param1,this.password);
         Cc.y = Settings.WINDOW_HEIGHT;
         Cc.width = Settings.WINDOW_WIDTH;
         Cc.height = this.CONSOLE_HEIGHT;
         Cc.commandLine = true;
         Cc.memoryMonitor = false;
         Cc.config.commandLineAllowed = true;
         Cc.addSlashCommand(CONSOL_COMMAND__SET_HANGAR,this.changeHangar);
         Cc.addSlashCommand(CONSOL_COMMAND__GET_ITEM_INFO,this.getItemInfo);
         Cc.addSlashCommand(CONSOL_COMMAND__GET_ITEM_DETAIL_INFO,this.getItemDetailInfo);
         Cc.addSlashCommand("exit",this.hideConsole);
         Cc.addSlashCommand("show",this.showErrorDialog);
         param1.stage.addEventListener(KeyboardEvent.KEY_UP,this.handleKeyDown);
      }
      
      private function handleKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:int = int(param1.keyCode);
         var _loc3_:* = _loc2_ == 220;
         if(_loc3_)
         {
            this.updateVisibilty();
         }
         if(_loc2_ == 69)
         {
            this.showErrorDialog();
         }
         if(_loc2_ == Keyboard.I)
         {
         }
      }
      
      private function showConsole() : void
      {
         TweenMax.to(Cc,0.3,{"y":Settings.WINDOW_HEIGHT - this.CONSOLE_HEIGHT});
         Cc.memoryMonitor = true;
         Cc.fpsMonitor = true;
         Cc.clear();
      }
      
      private function hideConsole() : void
      {
         TweenMax.to(Cc,0.5,{"y":Settings.WINDOW_HEIGHT});
         Cc.memoryMonitor = false;
         Cc.fpsMonitor = false;
      }
      
      private function updateVisibilty() : void
      {
         if(this.isVisible)
         {
            this.showConsole();
         }
         else
         {
            this.hideConsole();
         }
         this.isVisible = !this.isVisible;
      }
      
      private function changeHangar(param1:uint = 1) : void
      {
         var _loc2_:HangarManagerProxy = ApplicationFacade.getInstance().retrieveProxy(HangarManagerProxy.PROXY_NAME) as HangarManagerProxy;
         _loc2_.changeHangar(param1);
      }
      
      private function getItemInfo(param1:uint = 1) : void
      {
         var _loc2_:String = param1.toString();
         var _loc3_:ItemInstanceVO = Inventory.getInstance().getItem(_loc2_);
         var _loc4_:ItemInfoVO = _loc3_.itemInfo;
         Cc.info("lootID\t= " + _loc4_.lootID);
         Cc.info("name\t= " + _loc4_.name);
         var _loc5_:Array = _loc3_.equippedInConfigs;
         if(_loc5_[1])
         {
            Cc.info("equipped in config[1] = ");
         }
         if(_loc5_[2])
         {
            Cc.info("equipped in config[2] = ");
         }
         if(_loc5_[1] == null && _loc5_[2] == null)
         {
            Cc.info("Item isn´t equipped.");
         }
      }
      
      private function getItemDetailInfo(param1:uint = 1) : void
      {
         var _loc2_:String = param1.toString();
         var _loc3_:ItemInstanceVO = Inventory.getInstance().getItem(_loc2_);
         var _loc4_:ItemInfoVO = _loc3_.itemInfo;
         Cc.inspect(_loc3_);
         Cc.inspect(_loc4_);
      }
      
      private function showErrorDialog() : void
      {
         var _loc1_:ConnectionProxy = ApplicationFacade.getInstance().retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
         _loc1_.showErrorMessageDialog();
      }
   }
}

