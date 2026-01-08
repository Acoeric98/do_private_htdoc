package net.bigpoint.darkorbit.equipment.controller
{
   import net.bigpoint.darkorbit.equipment.model.ConnectionProxy;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.command.SimpleCommand;
   
   public class SwitchConfigCommand extends SimpleCommand implements ICommand
   {
      
      public function SwitchConfigCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:int = param1.getBody() as int;
         var _loc3_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
         _loc3_.switchConfig(_loc2_);
      }
   }
}

