package net.bigpoint.darkorbit.equipment.model.VO.item
{
   import net.bigpoint.darkorbit.equipment.model.VO.Config;
   
   public class ItemInstanceVO
   {
      
      public var ID:String;
      
      public var itemInfo:ItemInfoVO;
      
      public var equippedInConfigs:Array = [];
      
      public var quantity:int = 1;
      
      public var slot:int;
      
      public var level:int;
      
      public var attachedAmmo:String;
      
      public var levelText:String;
      
      public var charges:String;
      
      public var wordpuzzleName:String;
      
      public var wordpuzzleValue:String;
      
      public var wordpuzzlePos:uint;
      
      public var damageLevel:int;
      
      public var shieldLevel:int;
      
      public var boosterLevel:int;
      
      public var minuteLevel:int;
      
      public var durability:String;
      
      public var durabilityLevel:int;
      
      public var durabilityUpgradeLevel:int;
      
      public var repairCosts:int;
      
      public var repairLevel:int;
      
      public var hitPoints:int;
      
      public var maxHitPoints:int;
      
      public var installDate:Number;
      
      public var moduleInstalled:Boolean;
      
      public var battleStationName:String = "";
      
      public function ItemInstanceVO(param1:ItemInfoVO)
      {
         super();
         this.itemInfo = param1;
      }
      
      public function equipToConfig(param1:Config) : void
      {
         var _loc3_:Config = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.equippedInConfigs.length)
         {
            _loc3_ = this.equippedInConfigs[_loc2_];
            if(_loc3_ == param1)
            {
               return;
            }
            _loc2_++;
         }
         this.equippedInConfigs[param1.name] = param1;
      }
      
      public function unequipFromConfig(param1:Config) : void
      {
         var _loc3_:Config = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.equippedInConfigs.length)
         {
            _loc3_ = this.equippedInConfigs[_loc2_];
            if(_loc3_ == param1)
            {
               this.equippedInConfigs[_loc2_] = null;
               return;
            }
            _loc2_++;
         }
      }
      
      public function getLevelValue() : int
      {
         var _loc1_:ItemGroupVO = this.itemInfo.group;
         var _loc2_:int = 0;
         if(_loc1_ != null)
         {
            _loc2_ = this.level;
            if(_loc1_.isPet())
            {
               if(_loc1_.isGear() || _loc1_.isProtocol())
               {
                  _loc2_++;
               }
            }
         }
         if(this.damageLevel > 1)
         {
            _loc2_ = this.damageLevel;
         }
         else if(this.shieldLevel > 1)
         {
            _loc2_ = this.shieldLevel;
         }
         else if(this.durabilityLevel > 1)
         {
            _loc2_ = this.durabilityLevel;
         }
         return _loc2_;
      }
      
      public function getHitPointsInPercent() : int
      {
         if(this.maxHitPoints > 0 && this.hitPoints >= 0)
         {
            return int(this.hitPoints * 100 / this.maxHitPoints);
         }
         return -1;
      }
   }
}

