package net.bigpoint.darkorbit.equipment.model
{
   import com.bigpoint.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.equipment.application.ApplicationNotificationNames;
   import net.bigpoint.loginmodule.LoginModule;
   import org.puremvc.as3.interfaces.IProxy;
   import org.puremvc.as3.patterns.proxy.Proxy;
   
   public class LoginProxy extends Proxy implements IProxy
   {
      
      public static const PROXY_NAME:String = "LoginProxy";
      
      private var loginModule:LoginModule;
      
      private var loadingItemIndex:int;
      
      private var neededAssetsCount:uint;
      
      public function LoginProxy(param1:String = null, param2:Object = null)
      {
         super(param1,null);
      }
      
      public function beginLogin() : void
      {
         sendNotification(ApplicationNotificationNames.LOG_IN_SUCCESSFUL);
      }
      
      private function handleCookieCreated(param1:String) : void
      {
         sendNotification(ApplicationNotificationNames.LOG_IN_SUCCESSFUL);
      }
      
      public function loadItemGraphics() : void
      {
         var _loc1_:Array = ["prometium_30x30","g3n-1010_30x30","lf-3_30x30"];
         this.loadingItemIndex = 0;
         this.neededAssetsCount = _loc1_.length;
         var _loc2_:int = 0;
         while(_loc2_ < this.neededAssetsCount)
         {
            AssetProxy.load(_loc1_[_loc2_],this.handleImageLoaded);
            _loc2_++;
         }
      }
      
      private function handleImageLoaded(param1:ImageFinisher = null) : void
      {
         if(++this.loadingItemIndex == this.neededAssetsCount)
         {
            sendNotification(ApplicationNotificationNames.ICONS_LOADED);
         }
      }
   }
}

