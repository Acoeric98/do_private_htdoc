package net.bigpoint.darkorbit.equipment.view.managers
{
   public class FocusManager
   {
      
      private static var _instance:FocusManager;
      
      private var currentFocus:IFocusable;
      
      private var managedFocusableList:Vector.<IFocusable>;
      
      public function FocusManager()
      {
         super();
         this.initialize();
      }
      
      public static function getInstance() : FocusManager
      {
         if(_instance == null)
         {
            _instance = new FocusManager();
         }
         return _instance;
      }
      
      private function initialize() : void
      {
         this.managedFocusableList = new Vector.<IFocusable>();
      }
      
      public function clearFocus() : void
      {
         if(this.currentFocus)
         {
            this.currentFocus.unfocusing();
         }
         this.currentFocus = null;
         this.focusChanged();
      }
      
      public function getFocus() : IFocusable
      {
         return this.currentFocus;
      }
      
      public function setFocus(param1:IFocusable) : void
      {
         this.currentFocus = param1;
         this.currentFocus.focusing();
         this.focusChanged();
      }
      
      private function focusChanged() : void
      {
         var _loc2_:IFocusable = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.managedFocusableList.length)
         {
            _loc2_ = this.managedFocusableList[_loc1_];
            if(this.currentFocus != _loc2_)
            {
               if(_loc2_.unfocusing != null)
               {
                  _loc2_.unfocusing();
               }
            }
            _loc1_++;
         }
      }
      
      public function add(param1:IFocusable) : void
      {
         var _loc2_:IFocusable = this.searchFocusable(param1);
         if(_loc2_ == null)
         {
            this.managedFocusableList.push(param1);
         }
      }
      
      public function remove(param1:IFocusable) : void
      {
         this.removeFocusable(param1);
      }
      
      private function removeFocusable(param1:IFocusable) : void
      {
         var _loc3_:IFocusable = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.managedFocusableList.length)
         {
            _loc3_ = this.managedFocusableList[_loc2_];
            if(param1 == _loc3_)
            {
               this.managedFocusableList.splice(_loc2_,1);
               return;
            }
            _loc2_++;
         }
      }
      
      private function searchFocusable(param1:IFocusable) : IFocusable
      {
         var _loc2_:IFocusable = null;
         var _loc4_:IFocusable = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.managedFocusableList.length)
         {
            _loc4_ = this.managedFocusableList[_loc3_];
            if(param1 == _loc4_)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

