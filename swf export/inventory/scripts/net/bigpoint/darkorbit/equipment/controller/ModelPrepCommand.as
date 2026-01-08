package net.bigpoint.darkorbit.equipment.controller
{
   import net.bigpoint.darkorbit.equipment.application.ApplicationNotificationNames;
   import net.bigpoint.darkorbit.equipment.model.AssetProxy;
   import net.bigpoint.darkorbit.equipment.model.ConnectionProxy;
   import net.bigpoint.darkorbit.equipment.model.LoadDataProxy;
   import net.bigpoint.darkorbit.equipment.model.LoginProxy;
   import net.bigpoint.darkorbit.equipment.model.MenuProxy;
   import net.bigpoint.darkorbit.equipment.model.managers.HangarManagerProxy;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.command.SimpleCommand;
   
   public class ModelPrepCommand extends SimpleCommand implements ICommand
   {
      
      public function ModelPrepCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         facade.registerProxy(new MenuProxy(MenuProxy.PROXY_NAME,ApplicationNotificationNames.MENU_LAYOUT_DEFINED));
         facade.registerProxy(new LoadDataProxy(LoadDataProxy.PROXY_NAME,ApplicationNotificationNames.END_LOADING));
         facade.registerProxy(new AssetProxy(AssetProxy.PROXY_NAME));
         facade.registerProxy(new LoginProxy(LoginProxy.PROXY_NAME));
         facade.registerProxy(new ConnectionProxy(ConnectionProxy.PROXY_NAME));
         facade.registerProxy(new HangarManagerProxy());
      }
   }
}

