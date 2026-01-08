package net.bigpoint.darkorbit.equipment.controller
{
   import flash.display.Stage;
   import net.bigpoint.darkorbit.equipment.application.ApplicationNotificationNames;
   import net.bigpoint.darkorbit.equipment.view.mediators.StageMediator;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.command.SimpleCommand;
   
   public class ViewPrepCommand extends SimpleCommand implements ICommand
   {
      
      public function ViewPrepCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Stage = param1.getBody() as Stage;
         facade.registerMediator(new StageMediator(_loc2_));
         sendNotification(ApplicationNotificationNames.INIT_DEBUG_CONFIGURATIONS);
      }
   }
}

