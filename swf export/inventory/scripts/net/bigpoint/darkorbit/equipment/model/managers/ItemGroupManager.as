package net.bigpoint.darkorbit.equipment.model.managers
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemGroupVO;
   
   public class ItemGroupManager
   {
      
      private static var _instance:ItemGroupManager;
      
      private var _groups:Dictionary = new Dictionary();
      
      public function ItemGroupManager(param1:Function)
      {
         super();
         if(param1 != hidden)
         {
            throw new Error("ItemGroupManager is a Singleton and can only be accessed through ItemGroupManager.getInstance()");
         }
      }
      
      public static function getInstance() : ItemGroupManager
      {
         if(_instance == null)
         {
            _instance = new ItemGroupManager(hidden);
         }
         return _instance;
      }
      
      private static function hidden() : void
      {
      }
      
      public function getGroup(param1:String) : ItemGroupVO
      {
         var _loc2_:ItemGroupVO = null;
         if(!this._groups[param1])
         {
            _loc2_ = new ItemGroupVO();
            _loc2_.name = param1;
            this._groups[param1] = _loc2_;
         }
         return this._groups[param1];
      }
      
      public function init() : void
      {
      }
   }
}

