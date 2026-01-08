package net.bigpoint.darkorbit.equipment.view.mediators
{
   import net.bigpoint.darkorbit.equipment.application.ApplicationNotificationNames;
   import net.bigpoint.darkorbit.equipment.model.managers.HangarManagerProxy;
   import net.bigpoint.darkorbit.equipment.view.components.SuspendView;
   import org.puremvc.as3.interfaces.IMediator;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.mediator.Mediator;
   
   public class SuspendMediator extends Mediator implements IMediator
   {
      
      public static const NAME:String = "SuspendMediator";
      
      public function SuspendMediator(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         var _loc5_:String = null;
         switch(param1.getName())
         {
            case ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW:
               _loc2_ = param1.getBody() as Array;
               _loc3_ = Boolean(_loc2_[0]);
               _loc4_ = _loc2_[1];
               _loc5_ = _loc2_[2];
               this.suspendView.toggleSuspend(_loc3_,_loc4_,_loc5_);
               HangarManagerProxy.setHangarBarActive(!_loc3_);
         }
      }
      
      private function get suspendView() : SuspendView
      {
         return viewComponent as SuspendView;
      }
   }
}

