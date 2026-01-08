package net.bigpoint.darkorbit.equipment.model.VO
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInfoVO;
   import net.bigpoint.darkorbit.equipment.model.managers.ItemInfoManager;
   
   public class Ship extends EquippableObject
   {
      
      public var ID:String;
      
      public var saleValue:Number = 23;
      
      public var sellable:Boolean = false;
      
      public var hitPoints:Number;
      
      public var selectedDesign:String = "";
      
      public var availableDesignsList:Array = [];
      
      public var availableDesignsListLoka:Dictionary = new Dictionary();
      
      public var slotCPUsExist:Boolean = false;
      
      public var actualSlotsWithSlotCPUForConfig:Array = [];
      
      public var baseType:String;
      
      public function Ship()
      {
         super();
      }
      
      public function setAllAvailableDesignLokaInfo(param1:ItemInfoManager) : void
      {
         var _loc3_:String = null;
         var _loc4_:ItemInfoVO = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.availableDesignsList.length)
         {
            _loc3_ = this.availableDesignsList[_loc2_];
            _loc4_ = param1.getItemInfo(_loc3_);
            this.availableDesignsListLoka[_loc4_.name] = _loc3_;
            _loc2_++;
         }
      }
      
      public function setAvailableDesignsList(param1:Array) : void
      {
         if(param1)
         {
            this.baseType = this.analyzeSelectedDesignByBaseType(this.selectedDesign);
            if(param1.length > 0)
            {
               this.availableDesignsList = param1;
            }
            else
            {
               this.availableDesignsList = [this.selectedDesign,this.baseType];
            }
         }
         else
         {
            this.availableDesignsList = [this.selectedDesign];
            this.baseType = this.analyzeSelectedDesignByBaseType(this.selectedDesign);
         }
      }
      
      private function analyzeSelectedDesignByBaseType(param1:String) : String
      {
         var _loc2_:Array = param1.split("_");
         return _loc2_[0] + "_" + _loc2_[1];
      }
      
      public function getShipType() : String
      {
         return this.baseType;
      }
   }
}

