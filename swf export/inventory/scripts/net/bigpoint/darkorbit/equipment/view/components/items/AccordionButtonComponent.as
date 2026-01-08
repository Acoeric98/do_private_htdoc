package net.bigpoint.darkorbit.equipment.view.components.items
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.events.ActionIdentifiers;
   import net.bigpoint.darkorbit.equipment.model.AssetProxy;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.model.VO.Drone;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemLocalisationKeys;
   import net.bigpoint.darkorbit.equipment.model.VO.slot.SlotSetVO;
   import net.bigpoint.darkorbit.equipment.view.Styles;
   import net.bigpoint.darkorbit.equipment.view.components.interfaces.IMenuComponent;
   import net.bigpoint.dataInterchange.DataInterchange;
   import net.bigpoint.utils.TextFormatter;
   
   public class AccordionButtonComponent extends Sprite implements IMenuComponent
   {
      
      public static const OBJECT_NAME:String = "AccordionButtonComponent";
      
      public static const ICONS_ACROSS:int = 8;
      
      public var clip:MovieClip;
      
      public var gradientBg:Sprite;
      
      public var id:int;
      
      public var originalY:Number;
      
      public var currentYPos:Number;
      
      public var isBottomButton:Boolean = false;
      
      public var contentHeight:Number;
      
      public var open:Boolean = false;
      
      public var section:String;
      
      private var dragComp:DragComponent;
      
      public var iconsInThisMenu:Array = [];
      
      public var rowTracker:int = 0;
      
      public var grid:GridComponent;
      
      public var gridDesign:GridComponent;
      
      public var numberOfIconsInThisMenu:int = 0;
      
      public var equippableSections:Array = [];
      
      public var slotSetName:String;
      
      public var actualButtonHeight:int = 19;
      
      private var idleButtonFrame:int = 1;
      
      private var rolloverButtonFrame:int;
      
      public var droneIcon:InventoryLargeItemComponent;
      
      private var droneLevelText:TextField;
      
      public var droneEffectText:TextField;
      
      public var droneDamageText:TextField;
      
      private var droneDesignText:TextField;
      
      private var droneLevelDamageText:TextField;
      
      private var droneLevelShieldText:TextField;
      
      public function AccordionButtonComponent(param1:MovieClip, param2:int, param3:String)
      {
         super();
         this.section = param3;
         this.id = param2;
         this.clip = param1;
         this.clip.x = -1;
         this.clip.useHandCursor = true;
         this.clip.buttonMode = true;
         addChild(this.clip);
         this.gradientBg = AssetProxy.getMovieClip("scrollComponents","accordionGrad");
         var _loc4_:TextField = param1.btnText;
         _loc4_.selectable = false;
         _loc4_.mouseEnabled = false;
         _loc4_.embedFonts = Styles.baseEmbed;
         if(this.dragComp == null)
         {
            this.dragComp = DragComponent.getInstance();
         }
         this.addListeners();
      }
      
      public function addListeners() : void
      {
         this.clip.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
      }
      
      public function removeListeners() : void
      {
         this.clip.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.clip.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
      }
      
      private function handleMouseOver(param1:MouseEvent) : void
      {
         this.clip.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.clip.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this.clip.gotoAndStop(this.rolloverButtonFrame);
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         this.clip.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.clip.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this.clip.gotoAndStop(this.idleButtonFrame);
      }
      
      public function createBackgroundLayer() : void
      {
         this.graphics.clear();
         this.graphics.beginFill(2764595,1);
         this.graphics.drawRect(0,this.clip.y + this.clip.height - 8,this.clip.width,this.contentHeight + 15);
         this.graphics.endFill();
      }
      
      private function changeBackgroundSize(param1:Number) : void
      {
         this.graphics.clear();
         this.graphics.beginFill(2764595,1);
         this.graphics.drawRect(0,this.clip.y + this.clip.height - 8,param1,this.contentHeight + 15);
         this.graphics.endFill();
      }
      
      public function setDeselected() : void
      {
      }
      
      public function setSelected() : void
      {
      }
      
      public function createBottomButtonCover() : void
      {
         this.isBottomButton = true;
         this.graphics.beginFill(2764595,1);
         this.graphics.drawRect(0,this.clip.y + this.clip.height - 1,this.clip.width,10);
         this.graphics.endFill();
      }
      
      public function populateGrid(param1:SlotSetVO) : void
      {
         this.grid.populateEquipmentSide(param1);
      }
      
      public function populateDesignGrid(param1:SlotSetVO) : void
      {
         this.gridDesign.populateEquipmentSide(param1);
      }
      
      public function arrangeEmptyGridIcons(param1:int, param2:Boolean = false, param3:Number = 0, param4:Number = 0) : void
      {
         this.grid = new GridComponent(false);
         this.grid.startYPos = 20 + param4;
         this.grid.startXPos = param3;
         this.grid.GAP_AMOUNT = 0;
         this.grid.ICONS_ACROSS = 10;
         this.grid.slotSetName = this.slotSetName;
         this.grid.dragGroupID = GridComponent.DRAG_GROUP_ACCORDIONVIEW_ID;
         this.grid.createGridMenu(param1,param2);
         addChild(this.grid);
      }
      
      public function arrangeEmptySectionsForDrones(param1:Array) : void
      {
         this.grid = new GridComponent(false);
         this.grid.dragGroupID = GridComponent.DRAG_GROUP_ACCORDIONVIEW_ID;
         this.grid.startXPos = param1[0].x;
         this.grid.startYPos = 20 + param1[0].y;
         this.grid.GAP_AMOUNT = 0;
         this.grid.ICONS_ACROSS = 10;
         this.grid.slotSetName = this.slotSetName;
         this.grid.createGridMenu(param1[0].quantity,param1[0].drawVertical);
         this.gridDesign = new GridComponent(false);
         this.gridDesign.dragGroupID = GridComponent.DRAG_GROUP_ACCORDIONVIEW_ID;
         this.gridDesign.startXPos = param1[1].x;
         this.gridDesign.startYPos = 20 + param1[1].y;
         this.gridDesign.GAP_AMOUNT = 0;
         this.gridDesign.ICONS_ACROSS = 10;
         this.gridDesign.slotSetName = this.slotSetName;
         this.gridDesign.createGridMenu(param1[1].quantity,param1[1].drawVertical);
         addChild(this.grid);
         addChild(this.gridDesign);
      }
      
      public function changeNumberOfAvailableGridSlots(param1:int) : void
      {
         this.grid.changeNumberOfSlots(param1);
      }
      
      public function createDroneSpecificItems(param1:String, param2:String, param3:Drone) : void
      {
         this.droneIcon = new InventoryLargeItemComponent();
         this.droneIcon.useBackgroundBorder();
         this.droneIcon.isDrone = true;
         this.droneIcon.lootID = param3.lootID;
         this.droneIcon.itemID = param2;
         this.droneIcon.repairPrice = Settings.DRONE_REPAIR_COST;
         this.droneIcon.droneLevel = param3.level + 1;
         this.droneIcon.changeLargeGraphic(param1,ActionIdentifiers.RES_63);
         addChild(this.droneIcon);
         this.droneIcon.y = 26;
         this.droneIcon.x = 5;
         this.dragComp.addDraggableIcon(this.droneIcon);
         this.droneLevelText = this.createDroneTextBox();
         this.droneEffectText = this.createDroneTextBox();
         this.droneDamageText = this.createDroneTextBox();
         this.droneDesignText = this.createDroneTextBox();
         this.droneLevelDamageText = this.createDroneTextBox();
         this.droneLevelShieldText = this.createDroneTextBox();
         this.droneLevelText.x = 118;
         this.droneEffectText.x = this.droneLevelText.x;
         this.droneDamageText.x = this.droneLevelText.x;
         this.droneDesignText.x = 233;
         this.droneLevelDamageText.x = 118;
         this.droneLevelShieldText.x = 270;
         this.droneLevelText.y = 23;
         this.droneEffectText.y = this.droneLevelText.y + (this.droneLevelText.height - 2);
         this.droneDamageText.y = this.droneEffectText.y + (this.droneEffectText.height - 2);
         this.droneDesignText.y = 23;
         this.droneLevelDamageText.y = this.droneDamageText.y + (this.droneDamageText.height - 2);
         this.droneLevelShieldText.y = this.droneDamageText.y + (this.droneDamageText.height - 2);
         addChild(this.droneLevelText);
         addChild(this.droneEffectText);
         addChild(this.droneDamageText);
         addChild(this.droneDesignText);
         addChild(this.droneLevelDamageText);
         addChild(this.droneLevelShieldText);
         this.droneLevelText.text = BPLocale.getItem("label_drone_info_level").replace(/%VALUE%/,TextFormatter.roundInteger(param3.level + 1));
         this.droneEffectText.text = BPLocale.getItem("label_drone_info_effect").replace(/%VALUE%/,param3.effect);
         this.droneDamageText.text = BPLocale.getItem("label_drone_info_damage").replace(/%VALUE%/,String(param3.hitPoints));
         this.droneDesignText.text = BPLocale.getItem("label_drone_info_design").replace(/%VALUE%/,String(param3.design));
         this.droneLevelDamageText.text = BPLocale.getItem("label_drone_info_upgrade_level") + " " + BPLocale.getItem("label_drone_info_damage_level").replace(/%VALUE%/,TextFormatter.roundInteger(param3.damageLevel));
         this.droneLevelShieldText.text = BPLocale.getItem("label_drone_info_shield_level").replace(/%VALUE%/,TextFormatter.roundInteger(param3.shieldLevel));
         if(param3.damage == 0)
         {
            this.droneIcon.repairable = false;
         }
         else
         {
            this.droneIcon.repairable = true;
         }
         this.droneLevelText.width = this.droneEffectText.width = this.droneDamageText.width = this.droneLevelDamageText.width = 118;
         this.droneLevelDamageText.width = 300;
      }
      
      public function updateDroneLevel(param1:int) : void
      {
         this.droneLevelText.text = BPLocale.getItem("label_drone_info_level").replace(/%VALUE%/,param1);
      }
      
      public function updateDroneEffect(param1:String) : void
      {
         this.droneEffectText.text = BPLocale.getItem("label_drone_info_effect").replace(/%VALUE%/,param1);
      }
      
      public function updateDroneDamage(param1:String) : void
      {
         this.droneDamageText.text = BPLocale.getItem("label_drone_info_damage").replace(/%VALUE%/,param1);
         var _loc2_:int = int(param1.substring(0,param1.length - 1));
         if(_loc2_ == 0)
         {
            this.droneIcon.repairable = false;
         }
         else
         {
            this.droneIcon.repairable = true;
         }
      }
      
      public function updateDroneDesign(param1:String = "") : void
      {
         var _loc3_:String = null;
         var _loc2_:String = "";
         if(param1 != "")
         {
            _loc3_ = BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,param1);
            _loc2_ = BPLocale.getItem("label_drone_info_design").replace(/%VALUE%/,_loc3_);
         }
         else
         {
            _loc2_ = BPLocale.getItem("label_drone_info_design").replace(/%VALUE%/,"");
         }
         this.droneDesignText.text = _loc2_;
      }
      
      public function updateDroneGraphic(param1:String) : void
      {
         this.droneIcon.changeLargeGraphic(param1,ActionIdentifiers.RES_63);
      }
      
      private function createDroneTextBox() : TextField
      {
         var _loc1_:TextField = new TextField();
         _loc1_.width = 140;
         _loc1_.height = 20;
         _loc1_.selectable = false;
         _loc1_.textColor = 15658734;
         _loc1_.antiAliasType = AntiAliasType.ADVANCED;
         if(Styles.baseEmbed)
         {
            _loc1_.defaultTextFormat = Styles.droneTextFormat;
         }
         else
         {
            _loc1_.defaultTextFormat = Styles.droneTextFormaDeviceFontst;
         }
         return _loc1_;
      }
      
      public function arrangeSingleItem(param1:InventoryItemComponent) : void
      {
         if(param1.group == DataInterchange.DRONE_DESIGN_TYPE_CLASS)
         {
            this.gridDesign.placeDroppedItemFromInventory(param1);
         }
         else
         {
            this.grid.placeDroppedItemFromInventory(param1);
         }
      }
      
      public function exposeGridToMultiSelector() : void
      {
         if(this.grid)
         {
            this.grid.addGridToMultiSelector();
         }
      }
      
      public function hideGridToMultiSelector() : void
      {
         if(this.grid)
         {
            this.grid.removeGridFromMultiSelector();
         }
      }
      
      public function getStartingYPosition() : Number
      {
         return this.clip.height;
      }
      
      public function getGridRearranger() : GridRearrangeComponent
      {
         return null;
      }
      
      public function getParent() : Object
      {
         return this.parent;
      }
      
      public function getY() : Number
      {
         return this.y;
      }
      
      public function getX() : Number
      {
         return this.x;
      }
      
      public function addThisChild(param1:InventoryItemComponent) : void
      {
         this.addChild(param1);
      }
      
      public function getFilterState() : String
      {
         return "NONE";
      }
      
      public function getObjectType() : String
      {
         return OBJECT_NAME;
      }
      
      public function putThisItemBack(param1:InventoryItemComponent) : void
      {
      }
      
      public function reOrderIconArray() : void
      {
      }
      
      public function getContainingViewID() : String
      {
         return this.section;
      }
      
      public function getSlotSetName() : String
      {
         return "Error: Doesn\'t return slotSetName";
      }
      
      public function setOpen() : void
      {
         if(this.clip.btnText.text != "")
         {
            this.open = true;
            this.idleButtonFrame = 3;
            this.rolloverButtonFrame = 4;
            this.clip.gotoAndStop(this.idleButtonFrame);
            addChild(this.gradientBg);
            this.changeBackgroundSize(364);
            this.gradientBg.y = this.contentHeight + 15;
         }
      }
      
      public function setClosed() : void
      {
         if(this.clip.btnText.text != "")
         {
            this.open = false;
            this.idleButtonFrame = 1;
            this.rolloverButtonFrame = 2;
            this.clip.gotoAndStop(this.idleButtonFrame);
            this.changeBackgroundSize(364);
            if(contains(this.gradientBg))
            {
               removeChild(this.gradientBg);
            }
         }
      }
      
      public function createUnlockableSlots(param1:int) : void
      {
         this.grid.createUnlockableSlots(param1);
      }
      
      public function unlockOneLockedSlot() : void
      {
         this.grid.unlockOneSlot();
      }
      
      public function deactivate() : void
      {
         if(this.clip.btnText.text != "")
         {
            this.open = true;
            this.idleButtonFrame = 5;
            this.rolloverButtonFrame = 5;
            this.clip.gotoAndStop(this.idleButtonFrame);
            addChild(this.gradientBg);
            this.changeBackgroundSize(364);
            this.gradientBg.y = this.contentHeight + 15;
         }
      }
   }
}

