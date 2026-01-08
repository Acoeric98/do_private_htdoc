package net.bigpoint.darkorbit.equipment.view.mediators
{
   import net.bigpoint.darkorbit.equipment.application.ApplicationNotificationNames;
   import net.bigpoint.darkorbit.equipment.model.LoadDataProxy;
   import net.bigpoint.darkorbit.equipment.model.deprecated.AvatarVO;
   import net.bigpoint.darkorbit.equipment.view.components.IconURLView;
   import org.puremvc.as3.interfaces.IMediator;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.mediator.Mediator;
   
   public class IconURLViewMediator extends Mediator implements IMediator
   {
      
      public static const NAME:String = "IconURLViewMediator";
      
      public function IconURLViewMediator(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ApplicationNotificationNames.END_LOADING,ApplicationNotificationNames.ICON_CLICKED];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:LoadDataProxy = null;
         var _loc3_:int = 0;
         var _loc4_:AvatarVO = null;
         switch(param1.getName())
         {
            case ApplicationNotificationNames.END_LOADING:
               this.iconURLView.initComponent();
               break;
            case ApplicationNotificationNames.ICON_CLICKED:
               _loc2_ = facade.retrieveProxy(LoadDataProxy.PROXY_NAME) as LoadDataProxy;
               _loc3_ = IconViewMediator(facade.retrieveMediator(IconViewMediator.NAME)).selectedIconID;
               _loc4_ = _loc2_.entries[_loc3_];
               this.iconURLView.highlightURL(_loc4_.icon);
         }
      }
      
      private function get iconURLView() : IconURLView
      {
         return viewComponent as IconURLView;
      }
   }
}

