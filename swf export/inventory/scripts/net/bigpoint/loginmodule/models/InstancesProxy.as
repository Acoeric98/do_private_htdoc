package net.bigpoint.loginmodule.models
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import net.bigpoint.loginmodule.models.vo.InstanceVO;
   
   public class InstancesProxy extends EventDispatcher
   {
      
      private static var _instance:InstancesProxy;
      
      public static const LOADED:String = "LOADED";
      
      public static const NAME:String = "Instances";
      
      public static const instancesXml:Class = InstancesProxy_instancesXml;
      
      public var xmlData:XML;
      
      public var instances:Vector.<InstanceVO>;
      
      public var selectedInstanceId:int = -1;
      
      public function InstancesProxy(param1:Function)
      {
         super();
         if(param1 !== hidden)
         {
            throw new Error("Instances is a Singleton and can only be accessed through Instances.getInstance()");
         }
         this.init();
      }
      
      public static function getInstance() : InstancesProxy
      {
         if(_instance == null)
         {
            _instance = new InstancesProxy(hidden);
         }
         return _instance;
      }
      
      private static function hidden() : void
      {
      }
      
      public function init() : void
      {
      }
      
      public function loadInstances(param1:String = "") : void
      {
         this.handleXMLLoaded();
      }
      
      private function handleXMLLoaded() : void
      {
         var _loc1_:ByteArray = new instancesXml() as ByteArray;
         this.xmlData = new XML(_loc1_.readUTFBytes(_loc1_.length));
         this.parseXML();
      }
      
      private function parseXML() : void
      {
         var _loc1_:XML = null;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         this.instances = new Vector.<InstanceVO>();
         for each(_loc1_ in this.xmlData.instance)
         {
            _loc2_ = int(_loc1_.@id);
            _loc3_ = String(_loc1_.@name);
            this.addInstance(_loc2_,_loc3_);
         }
         dispatchEvent(new Event(LOADED));
      }
      
      public function addInstance(param1:int = -1, param2:String = "") : Boolean
      {
         var _loc3_:InstanceVO = null;
         if(param1 >= 0 && param2 != "")
         {
            _loc3_ = new InstanceVO(param1,param2);
            this.instances.push(_loc3_);
            return true;
         }
         return false;
      }
      
      public function getInstanceByIndex(param1:int) : InstanceVO
      {
         return this.instances[param1];
      }
      
      public function getInstanceById(param1:int) : InstanceVO
      {
         var _loc2_:InstanceVO = null;
         var _loc3_:InstanceVO = null;
         for each(_loc3_ in this.instances)
         {
            if(_loc3_.id == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         return _loc2_;
      }
      
      public function getSelectedInstance() : InstanceVO
      {
         if(this.selectedInstanceId >= 0)
         {
            return this.getInstanceById(this.selectedInstanceId);
         }
         return null;
      }
   }
}

