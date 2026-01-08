package net.bigpoint.darkorbit.equipment.controller
{
   import net.bigpoint.darkorbit.equipment.model.managers.HangarManagerProxy;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.command.SimpleCommand;
   
   public class HangarSlotChangeCommand extends SimpleCommand implements ICommand
   {
      
      public function HangarSlotChangeCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:int = param1.getBody() as int;
         var _loc3_:HangarManagerProxy = facade.retrieveProxy(HangarManagerProxy.PROXY_NAME) as HangarManagerProxy;
         _loc3_.changeHangar(_loc2_);
      }
   }
}

