package net.bigpoint.darkorbit.equipment.model
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import net.bigpoint.darkorbit.equipment.application.ApplicationNotificationNames;
   import net.bigpoint.darkorbit.equipment.view.components.items.MenuSection;
   import org.puremvc.as3.interfaces.IProxy;
   import org.puremvc.as3.patterns.proxy.Proxy;
   
   public class MenuProxy extends Proxy implements IProxy
   {
      
      public static const PROXY_NAME:String = "AccordionProxy";
      
      public var tabMenuList:Array;
      
      public var invSection:MenuSection = new MenuSection();
      
      public var invButtonMenu:MenuSection = new MenuSection();
      
      public function MenuProxy(param1:String, param2:String)
      {
         super(param1,null);
      }
      
      public function loadMenuLayoutXML() : void
      {
         var _loc1_:String = null;
         var _loc2_:LoadDataProxy = facade.retrieveProxy(LoadDataProxy.PROXY_NAME) as LoadDataProxy;
         _loc1_ = Settings.cdnHost + "/swf_global/inventory/xml/menuLayout.xml?__cv=" + _loc2_.fileHashList.menuLayoutConfig;
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.handleIOError);
         _loc3_.addEventListener(Event.COMPLETE,this.handleLayoutMenuConfigLoad);
         _loc3_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleXMLSecurityError);
         _loc3_.dataFormat = URLLoaderDataFormat.BINARY;
         _loc3_.load(new URLRequest(_loc1_));
      }
      
      private function handleLayoutMenuConfigLoad(param1:Event) : void
      {
         var layoutMenuConfigXml:XML = null;
         var event:Event = param1;
         try
         {
            layoutMenuConfigXml = new XML(event.target.data);
         }
         catch(e:TypeError)
         {
         }
         this.parseMenuLayoutXML(layoutMenuConfigXml);
      }
      
      private function handleIOError(param1:IOErrorEvent) : void
      {
      }
      
      private function handleXMLSecurityError(param1:SecurityErrorEvent) : void
      {
      }
      
      private function parseMenuLayoutXML(param1:XML) : void
      {
         var _loc2_:int = 0;
         var _loc9_:XMLList = null;
         var _loc10_:MenuSection = null;
         var _loc11_:int = 0;
         this.tabMenuList = [];
         var _loc3_:XMLList = param1.tab;
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length())
         {
            _loc9_ = _loc3_[_loc2_].children();
            _loc10_ = new MenuSection();
            _loc10_.menuName = _loc3_[_loc2_].@title;
            _loc11_ = 0;
            while(_loc11_ < _loc9_.length())
            {
               _loc10_.subSectionList.push(_loc9_[_loc11_].@title);
               _loc11_++;
            }
            this.tabMenuList.push(_loc10_);
            _loc2_++;
         }
         var _loc4_:XMLList = param1.inventory;
         var _loc5_:XMLList = _loc4_[0].children();
         this.invSection.menuName = _loc4_[0].@title;
         _loc2_ = 0;
         while(_loc2_ < _loc5_.length())
         {
            this.invSection.subSectionList.push(_loc5_[_loc2_].@title);
            _loc2_++;
         }
         var _loc6_:XMLList = param1.inventoryButtons;
         var _loc7_:XMLList = _loc6_[0].children();
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_.length())
         {
            this.invButtonMenu.subSectionList.push(_loc7_[_loc8_].@title);
            _loc8_++;
         }
         sendNotification(ApplicationNotificationNames.MENU_LAYOUT_DEFINED);
      }
   }
}

