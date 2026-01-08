package net.bigpoint.darkorbit.equipment.view.components.items
{
   import com.bigpoint.filecollection.finish.FileCollectionFinisher;
   import com.greensock.TweenMax;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.net.registerClassAlias;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.ByteArray;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.events.ActionIdentifiers;
   import net.bigpoint.darkorbit.equipment.model.AssetProxy;
   import net.bigpoint.darkorbit.equipment.model.VO.Inventory;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInstanceVO;
   import net.bigpoint.darkorbit.equipment.view.Styles;
   import net.bigpoint.darkorbit.equipment.view.components.interfaces.IMenuComponent;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.ToolTipHook;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.TooltipControl;
   import net.bigpoint.dataInterchange.DataInterchange;
   
   public class InventoryItemComponent extends Sprite
   {
      
      public static const UNLOCKABLE:String = "UNLOCKABLE";
      
      private static const HEALTH_NORMAL:uint = 1;
      
      private static const HEALTH_CRITICAL:uint = 2;
      
      private static const HEALTH_DESTROYED:uint = 3;
      
      private static const UNDEFINED_GROUP_NAME:String = "undefinedGroupName";
      
      public var itemName:String;
      
      public var itemID:String;
      
      public var itemGraphic:MovieClip;
      
      public var itemBorder:MovieClip;
      
      public var itemSprite:Sprite = new Sprite();
      
      public var stackGraphic:MovieClip = new MovieClip();
      
      public var equippedSprite:MovieClip = new MovieClip();
      
      public var bitmapFont:BitmapFont;
      
      public var isDrone:Boolean = false;
      
      public var droneLevel:int;
      
      public var isLargeIcon:Boolean = false;
      
      public var group:String;
      
      public var col:int;
      
      public var row:int;
      
      public var equippedInConfigs:Array = [];
      
      public var menuSectionComponent:IMenuComponent;
      
      public var indexInGrid:int;
      
      public var canBeSelected:Boolean = true;
      
      public var selected:Boolean = false;
      
      public var quantity:Number = 1;
      
      public var quantityField:TextField;
      
      private var lowerCaseName:String;
      
      private var currentGraphicBitmap:Bitmap = new Bitmap();
      
      public var buyableExtraSlot:Boolean = false;
      
      private var itemHover:MovieClip;
      
      private var unlockableSlotIcon:MovieClip;
      
      private var greaterThanSymbol:Sprite;
      
      private var moduleInstalledIcon:MovieClip;
      
      private var moduleRelatedOverlays:MovieClip;
      
      public var sellable:Boolean = true;
      
      public var repairPrice:int;
      
      public var currency:String;
      
      public var repairable:Boolean;
      
      public var equipped:Boolean = false;
      
      public var damageLevel:int = 1;
      
      public var shieldLevel:int = 1;
      
      private var levelFont:BitmapFont;
      
      private var levelValue:int;
      
      public var lootID:String;
      
      public function InventoryItemComponent()
      {
         super();
      }
      
      public static function changeFilename(param1:String, param2:ItemInstanceVO) : String
      {
         if(param1 == DataInterchange.WORDPUZZLE_ID)
         {
            param1 = ActionIdentifiers.RESOURCE + "_" + param1;
            param1 += "_" + param2.wordpuzzleValue.toLowerCase();
         }
         if(param1.indexOf(DataInterchange.WORDPUZZLE_ID) != -1 && (param2.wordpuzzleName == DataInterchange.WORDPUZZLE_NAME_HITEC2 || param2.wordpuzzleName == DataInterchange.WORDPUZZLE_NAME_ROCCAT))
         {
            param1 = param2.wordpuzzleValue.toLowerCase();
         }
         return param1;
      }
      
      public function init() : void
      {
         this.itemGraphic = AssetProxy.getMovieClip("inventoryItems","emptySlot");
         this.itemHover = AssetProxy.getMovieClip("inventoryItems","hover");
         this.itemBorder = AssetProxy.getMovieClip("inventoryItems","emptySlot");
         this.equippedSprite = AssetProxy.getMovieClip("inventoryItems","equippedSlot");
         this.moduleRelatedOverlays = AssetProxy.getMovieClip("inventoryItems","moduleRelatedOverlays");
         this.greaterThanSymbol = AssetProxy.getMovieClip("scrollComponents","greaterThan");
         addChild(this.itemBorder);
         addChild(this.itemSprite);
         this.itemHover.alpha = 0;
         addChild(this.itemHover);
         TweenMax.to(this.itemHover,0.5,{"colorMatrixFilter":{
            "amount":1,
            "brightness":2
         }});
         this.setChildIndex(this.itemHover,this.numChildren - 1);
         this.bitmapFont = new BitmapFont();
         this.bitmapFont.x = this.itemGraphic.height - this.bitmapFont.height;
         this.bitmapFont.y = this.itemGraphic.width - this.bitmapFont.width;
         this.levelFont = new BitmapFont();
         this.levelFont.changeFontColour(BitmapFont.BLUE);
         this.levelFont.x = this.itemGraphic.width - this.bitmapFont.width;
         this.levelFont.y = this.itemGraphic.height - this.bitmapFont.height;
         this.quantityField = new TextField();
         this.quantityField.height = 20;
         this.quantityField.width = 25;
         this.quantityField.selectable = false;
         this.quantityField.y = this.itemGraphic.height - this.quantityField.height;
         this.quantityField.x = this.itemGraphic.width - this.quantityField.width;
         this.quantityField.textColor = 16777215;
         this.quantityField.embedFonts = Styles.baseEmbed;
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.size = 10;
         _loc1_.align = TextFormatAlign.RIGHT;
         this.quantityField.setTextFormat(_loc1_);
         this.useHandCursor = true;
         this.buttonMode = true;
         this.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
      }
      
      private function handleMouseOver(param1:MouseEvent) : void
      {
         this.setChildIndex(this.itemHover,this.numChildren - 1);
         this.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         TweenMax.to(this.itemHover,0.4,{"alpha":1});
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         this.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         TweenMax.to(this.itemHover,0.4,{"alpha":0});
      }
      
      public function addUnlockableSlotIcon() : void
      {
         var _loc1_:TooltipControl = TooltipControl.getInstance();
         this.unlockableSlotIcon = AssetProxy.getMovieClip("scrollComponents","lockedSlot");
         _loc1_.addToolTip(this,BPLocale.getItem("tooltip_pet_locked_slot"));
         this.unlockableSlotIcon.x = this.unlockableSlotIcon.y = 2;
         addChild(this.unlockableSlotIcon);
         this.buyableExtraSlot = true;
      }
      
      public function removeUnlockableSlotIcon() : void
      {
         var _loc1_:TooltipControl = TooltipControl.getInstance();
         if(contains(this.unlockableSlotIcon))
         {
            removeChild(this.unlockableSlotIcon);
            _loc1_.removeToolTip(this);
         }
         this.buyableExtraSlot = false;
      }
      
      public function checkEquippedStatus() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         while(_loc2_ < this.equippedInConfigs.length)
         {
            if(this.equippedInConfigs[_loc2_])
            {
               _loc1_ = true;
            }
            _loc2_++;
         }
         if(_loc1_)
         {
            this.setEquipped();
         }
         else
         {
            this.setUnEquipped();
         }
      }
      
      public function setEquipped() : void
      {
         addChild(this.equippedSprite);
      }
      
      public function setUnEquipped() : void
      {
         if(contains(this.equippedSprite))
         {
            removeChild(this.equippedSprite);
         }
      }
      
      public function isSelected() : Boolean
      {
         return this.selected;
      }
      
      public function setSelected() : void
      {
         this.selected = true;
         TweenMax.to(this.itemBorder,0.5,{"colorTransform":{
            "tint":16766515,
            "tintAmount":1
         }});
         this.equippedSprite.gotoAndStop(2);
      }
      
      public function setDeselected() : void
      {
         this.selected = false;
         TweenMax.to(this.itemBorder,0.5,{"colorTransform":{
            "tint":16766515,
            "tintAmount":0
         }});
         this.equippedSprite.gotoAndStop(1);
      }
      
      public function setQuantityValue(param1:int) : void
      {
         var _loc2_:TooltipControl = null;
         var _loc3_:ToolTipHook = null;
         var _loc4_:int = 0;
         if(param1 != 0 && param1 > 1)
         {
            _loc2_ = TooltipControl.getInstance();
            _loc3_ = _loc2_.getInventoryItemToolTip(this);
            _loc3_.setQuantity(param1);
            _loc3_.updateText();
            this.bitmapFont.setText(String(param1));
            this.bitmapFont.y = this.itemGraphic.height - this.bitmapFont.height - 3;
            this.bitmapFont.x = this.itemGraphic.width - this.bitmapFont.width - 3;
            this.quantity = param1;
            if(this.bitmapFont.useGreaterThanSymbol)
            {
               if(!this.contains(this.greaterThanSymbol))
               {
                  this.addChild(this.greaterThanSymbol);
                  this.greaterThanSymbol.x = this.bitmapFont.x - this.greaterThanSymbol.width;
                  this.greaterThanSymbol.y = this.bitmapFont.y;
               }
            }
            else if(contains(this.greaterThanSymbol))
            {
               removeChild(this.greaterThanSymbol);
            }
            if(!this.contains(this.bitmapFont))
            {
               this.addChild(this.bitmapFont);
            }
            this.setChildIndex(this.bitmapFont,this.numChildren - 1);
            _loc4_ = this.getChildIndex(this.itemSprite);
            if(this.contains(this.greaterThanSymbol))
            {
               this.setChildIndex(this.greaterThanSymbol,_loc4_ + 1);
            }
         }
      }
      
      public function getLevel() : int
      {
         return this.levelValue;
      }
      
      public function setLevelText(param1:int) : void
      {
         this.levelValue = param1;
         if(param1 > 0)
         {
            this.levelFont.setText(String(param1));
            this.levelFont.x = 3;
            this.levelFont.y = 3;
            if(!this.contains(this.levelFont))
            {
               this.addChild(this.levelFont);
            }
         }
         else
         {
            this.removeLevelText();
         }
      }
      
      public function removeLevelText() : void
      {
         if(this.contains(this.levelFont))
         {
            this.removeChild(this.levelFont);
         }
      }
      
      public function removeQuantityOverlay() : void
      {
         if(contains(this.bitmapFont))
         {
            removeChild(this.bitmapFont);
         }
         if(contains(this.greaterThanSymbol))
         {
            removeChild(this.greaterThanSymbol);
         }
      }
      
      public function changeGraphic(param1:String, param2:String = "_30x30") : void
      {
         if(param1 == null)
         {
            param1 = "empty";
         }
         this.itemName = param1;
         this.lowerCaseName = param1.toLowerCase() + param2;
         if(param1 != "empty")
         {
            if(contains(this.itemGraphic))
            {
               removeChild(this.itemGraphic);
            }
            AssetProxy.lazyGetAsset(this.lowerCaseName,this.handleIconLoaded,this.handleIconLoadError);
         }
         else
         {
            if(contains(this.itemSprite))
            {
               removeChild(this.itemSprite);
            }
            this.setDeselected();
         }
         if(contains(this.bitmapFont))
         {
            this.setChildIndex(this.bitmapFont,this.numChildren - 1);
         }
      }
      
      private function handleIconLoaded(param1:FileCollectionFinisher = null) : void
      {
         if(this.itemSprite.contains(this.currentGraphicBitmap))
         {
            this.itemSprite.removeChild(this.currentGraphicBitmap);
         }
         var _loc2_:Bitmap = Bitmap(AssetProxy.getImage(this.lowerCaseName));
         var _loc3_:BitmapData = _loc2_.bitmapData;
         var _loc4_:BitmapData = _loc3_.clone();
         this.currentGraphicBitmap = new Bitmap(_loc4_);
         this.itemSprite.addChild(new Bitmap(_loc4_));
         addChild(this.itemSprite);
         if(contains(this.equippedSprite))
         {
            setChildIndex(this.equippedSprite,this.numChildren - 1);
         }
         this.itemSprite.x = this.itemSprite.y = 2;
         if(contains(this.bitmapFont))
         {
            this.setChildIndex(this.bitmapFont,this.numChildren - 1);
         }
         if(contains(this.greaterThanSymbol))
         {
            this.setChildIndex(this.greaterThanSymbol,this.numChildren - 1);
         }
         if(this.contains(this.levelFont))
         {
            this.setChildIndex(this.levelFont,this.numChildren - 1);
         }
         if(this.moduleInstalledIcon)
         {
            if(this.contains(this.moduleInstalledIcon))
            {
               this.setChildIndex(this.moduleInstalledIcon,this.numChildren - 1);
            }
         }
         if(this.contains(this.moduleRelatedOverlays))
         {
            if(this.contains(this.moduleRelatedOverlays))
            {
               this.setChildIndex(this.moduleRelatedOverlays,this.numChildren - 1);
            }
         }
      }
      
      private function handleIconLoadError() : void
      {
      }
      
      public function addStackUnderlay() : void
      {
         this.stackGraphic = AssetProxy.getMovieClip("inventoryItems","stack");
         addChild(this.stackGraphic);
         this.setChildIndex(this.stackGraphic,0);
      }
      
      public function removeStackUnderlay() : void
      {
         if(this.contains(this.stackGraphic))
         {
            removeChild(this.stackGraphic);
         }
      }
      
      public function setModuleInstalledState(param1:Boolean) : void
      {
         this.moduleInstalledIcon = AssetProxy.getMovieClip("inventoryItems","equippedSlot");
         if(param1)
         {
            if(this.contains(this.moduleInstalledIcon) == false)
            {
               addChild(this.moduleInstalledIcon);
            }
            this.setChildIndex(this.moduleInstalledIcon,this.numChildren - 1);
         }
         else if(this.contains(this.moduleInstalledIcon))
         {
            removeChild(this.moduleInstalledIcon);
         }
      }
      
      public function setContenActivation(param1:Boolean) : void
      {
         var _loc2_:Number = param1 ? 1 : 0;
         this.itemSprite.alpha = _loc2_;
         this.bitmapFont.alpha = _loc2_;
         this.greaterThanSymbol.alpha = _loc2_;
         this.levelFont.alpha = _loc2_;
         if(this.moduleRelatedOverlays)
         {
            this.moduleRelatedOverlays.alpha = _loc2_;
         }
         if(this.moduleInstalledIcon)
         {
            this.moduleInstalledIcon.alpha = _loc2_;
         }
         if(param1)
         {
            this.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         }
         else
         {
            this.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
            this.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         }
         this.canBeSelected = param1;
      }
      
      public function setModuleHitpointState(param1:int) : void
      {
         var _loc2_:int = param1 >= 25 && param1 <= 100 ? int(HEALTH_NORMAL) : -1;
         _loc2_ = param1 >= 1 && param1 <= 24 ? int(HEALTH_CRITICAL) : _loc2_;
         _loc2_ = param1 == 0 ? int(HEALTH_DESTROYED) : _loc2_;
         switch(_loc2_)
         {
            case HEALTH_NORMAL:
               this.showHealthStateLayer(HEALTH_NORMAL);
               break;
            case HEALTH_CRITICAL:
               this.showHealthStateLayer(HEALTH_CRITICAL);
               break;
            case HEALTH_DESTROYED:
               this.showHealthStateLayer(HEALTH_DESTROYED);
               break;
            case -1:
               this.clearModuleHitpointState();
         }
      }
      
      public function clearModuleHitpointState() : void
      {
         if(this.contains(this.moduleRelatedOverlays))
         {
            this.removeChild(this.moduleRelatedOverlays);
         }
      }
      
      protected function showHealthStateLayer(param1:uint) : void
      {
         if(this.contains(this.moduleRelatedOverlays) == false)
         {
            this.addChild(this.moduleRelatedOverlays);
         }
         this.setChildIndex(this.moduleRelatedOverlays,this.numChildren - 1);
         switch(param1)
         {
            case HEALTH_CRITICAL:
               this.moduleRelatedOverlays.gotoAndStop(2);
               break;
            case HEALTH_DESTROYED:
               this.moduleRelatedOverlays.gotoAndStop(3);
               break;
            case HEALTH_NORMAL:
            default:
               this.moduleRelatedOverlays.gotoAndStop(1);
         }
      }
      
      protected function getGroupBaseName() : String
      {
         var _loc1_:Array = null;
         var _loc2_:String = null;
         if(this.group)
         {
            _loc1_ = this.group.split("_");
            _loc2_ = _loc1_[0];
            if(_loc2_)
            {
               return _loc2_.toLowerCase();
            }
            return UNDEFINED_GROUP_NAME;
         }
         return UNDEFINED_GROUP_NAME;
      }
      
      public function isModule() : Boolean
      {
         var _loc1_:String = this.getGroupBaseName();
         return _loc1_ == ActionIdentifiers.MODULE ? true : false;
      }
      
      public function isModuleInstalled() : Boolean
      {
         var _loc2_:ItemInstanceVO = null;
         var _loc1_:Boolean = false;
         if(this.isModule())
         {
            _loc2_ = this.getItemInstanceData();
            if(_loc2_)
            {
               if(_loc2_.moduleInstalled)
               {
                  _loc1_ = true;
               }
            }
         }
         return _loc1_;
      }
      
      public function isLF4Laser() : Boolean
      {
         return this.itemName == ActionIdentifiers.LF4;
      }
      
      public function isResource() : Boolean
      {
         var _loc1_:String = this.getGroupBaseName();
         return _loc1_ == ActionIdentifiers.RESOURCE ? true : false;
      }
      
      public function isLotteryItem() : Boolean
      {
         return Boolean(this.itemName) && this.itemName.indexOf("lottery") >= 0 ? true : false;
      }
      
      public function isWordPuzzleItem() : Boolean
      {
         return this.lootID && this.lootID.indexOf("wordpuzzle") >= 0 || this.itemName && this.itemName.indexOf("wordpuzzle") >= 0 ? true : false;
      }
      
      public function isDroneDesignClassItem() : Boolean
      {
         return this.group == DataInterchange.DRONE_DESIGN_TYPE_CLASS ? true : false;
      }
      
      public function isResourceDronePart() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.itemName.indexOf("apis-part") >= 0 || this.itemName.indexOf("zeus-part") >= 0)
         {
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      public function isDroneDesign() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.group)
         {
            if(this.group.indexOf("DroneDesignType") >= 0)
            {
               _loc1_ = true;
            }
         }
         return _loc1_;
      }
      
      public function getItemInstanceData() : ItemInstanceVO
      {
         return Inventory.getInstance().getItem(this.itemID);
      }
      
      public function clone() : InventoryItemComponent
      {
         registerClassAlias("net.bigpoint.darkorbit.equipment.view.components.items",InventoryItemComponent);
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeObject(this);
         _loc1_.position = 0;
         return _loc1_.readObject() as InventoryItemComponent;
      }
   }
}

