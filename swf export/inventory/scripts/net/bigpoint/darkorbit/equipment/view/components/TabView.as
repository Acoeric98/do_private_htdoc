package net.bigpoint.darkorbit.equipment.view.components
{
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.events.InventoryEvent;
   import net.bigpoint.darkorbit.equipment.events.MenuEvent;
   import net.bigpoint.darkorbit.equipment.model.AssetProxy;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.view.Styles;
   import net.bigpoint.darkorbit.equipment.view.components.buttons.ConfigButton;
   import net.bigpoint.darkorbit.equipment.view.components.buttons.GenericButton;
   import net.bigpoint.darkorbit.equipment.view.components.items.TabButtonComponent;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.TooltipControl;
   import net.bigpoint.utils.PredefinedFilters;
   
   public class TabView extends Sprite
   {
      
      public static const TAB_BUTTON_CLICKED:String = "TAB_BUTTON_CLICKED";
      
      private static const tabbarButtonIDs:Array = [TabButtonComponent.ID_SHIP,TabButtonComponent.ID_DRONES,TabButtonComponent.ID_PET];
      
      public var sectionList:Array;
      
      public var selectedTab:String = "none";
      
      private var uiAssetArray:Array = [];
      
      private var tabButtonComponents:Array = [];
      
      private var lastActiveTab:TabButtonComponent;
      
      private var lastActiveConfigBtn:ConfigButton;
      
      private var configBtn1:ConfigButton;
      
      private var configBtn2:ConfigButton;
      
      private var clearCurrentShipConfigurationButton:GenericButton;
      
      private var configurationLabel:MovieClip;
      
      private var buildOlnlyOnce:Boolean = false;
      
      private var toolTipControl:TooltipControl = TooltipControl.getInstance();
      
      public function TabView()
      {
         super();
      }
      
      public function buildMenu(param1:Array) : void
      {
         this.uiAssetArray = param1;
         this.createTabButtons();
         this.createConfigUIElements();
      }
      
      public function createTabButtons() : void
      {
         var _loc5_:MovieClip = null;
         var _loc6_:int = 0;
         var _loc7_:TabButtonComponent = null;
         var _loc1_:Array = [BPLocale.getItem("label_tab_ship"),BPLocale.getItem("label_tab_drones"),BPLocale.getItem("label_tab_pet")];
         var _loc2_:Array = [BPLocale.getItem("tooltip_tab_ship"),BPLocale.getItem("tooltip_tab_drones"),BPLocale.getItem("tooltip_tab_pet")];
         var _loc3_:TooltipControl = TooltipControl.getInstance();
         var _loc4_:int = 0;
         while(_loc4_ < this.sectionList.length)
         {
            _loc5_ = AssetProxy.getMovieClip("scrollComponents","mainTab");
            _loc6_ = int(tabbarButtonIDs[_loc4_]);
            _loc7_ = new TabButtonComponent(_loc5_,_loc6_);
            _loc7_.x = (_loc7_.width + 1) * _loc4_;
            _loc7_.y = 0;
            _loc7_.clip.btnTitle.text = _loc1_[_loc4_];
            _loc7_.tabName = String(this.sectionList[_loc4_].menuName);
            _loc7_.clip.btnTitle.selectable = false;
            this.tabButtonComponents.push(_loc7_);
            this.addEventListeners(_loc7_);
            addChild(_loc7_);
            _loc3_.addToolTip(_loc7_,_loc2_[_loc4_]);
            if(_loc4_ == 0)
            {
               _loc7_.setTabActive();
               this.lastActiveTab = _loc7_;
            }
            _loc4_++;
         }
      }
      
      public function createConfigUIElements() : void
      {
         this.configBtn1 = new ConfigButton(1);
         this.configBtn2 = new ConfigButton(2);
         this.configBtn1.x = 9;
         this.configBtn2.x = this.configBtn1.x + this.configBtn1.width + 6;
         this.configBtn1.y = this.configBtn2.y = -34;
         this.configBtn1.setActive();
         this.configBtn2.addHoverListener();
         this.configBtn1.addEventListener(MouseEvent.CLICK,this.handleConfigButtonClicked);
         this.configBtn2.addEventListener(MouseEvent.CLICK,this.handleConfigButtonClicked);
         addChild(this.configBtn1);
         addChild(this.configBtn2);
         this.lastActiveConfigBtn = this.configBtn1;
         this.createClearConfiguration();
         this.createConfigurationTextfield();
      }
      
      private function createClearConfiguration() : void
      {
         this.clearCurrentShipConfigurationButton = new GenericButton(GenericButton.NO_TEXT,"configClearBtn");
         this.clearCurrentShipConfigurationButton.y = -34;
         this.clearCurrentShipConfigurationButton.x = 72;
         this.clearCurrentShipConfigurationButton.addListeners();
         this.clearCurrentShipConfigurationButton.addEventListener(MouseEvent.CLICK,this.handleClearCurrentShipConfigurationButtonClicked);
         addChild(this.clearCurrentShipConfigurationButton);
         this.toolTipControl.addToolTip(this.clearCurrentShipConfigurationButton,BPLocale.getItem("tooltip_button_clear_config"));
      }
      
      private function createConfigurationTextfield() : void
      {
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.size = 12;
         _loc1_.font = Styles.baseEmbed ? Styles.standardFontName : null;
         _loc1_.align = TextFormatAlign.LEFT;
         var _loc2_:TextField = new TextField();
         _loc2_.height = 20;
         _loc2_.selectable = false;
         _loc2_.x = this.clearCurrentShipConfigurationButton.x + this.clearCurrentShipConfigurationButton.width + 10;
         _loc2_.y = -32;
         _loc2_.textColor = 7697781;
         _loc2_.wordWrap = false;
         _loc2_.embedFonts = Styles.baseEmbed;
         _loc2_.setTextFormat(_loc1_);
         _loc2_.defaultTextFormat = _loc1_;
         var _loc3_:String = BPLocale.getItem("label_ui_configuration").toUpperCase();
         _loc2_.text = _loc3_;
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         addChild(_loc2_);
         this.toolTipControl.addToolTip(_loc2_,BPLocale.getItem("tooltip_configuration"));
      }
      
      public function resetUI() : void
      {
         this.resetTabbarButtons();
         this.resetConfigurationButtons();
      }
      
      private function resetTabbarButtons() : void
      {
         var _loc3_:TabButtonComponent = null;
         var _loc1_:uint = this.tabButtonComponents.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.tabButtonComponents[_loc2_] as TabButtonComponent;
            if(_loc3_)
            {
               if(_loc2_ == 0)
               {
                  _loc3_.setTabActive();
                  this.lastActiveTab = _loc3_;
               }
               else
               {
                  _loc3_.setTabInactive();
               }
            }
            _loc2_++;
         }
      }
      
      private function resetConfigurationButtons() : void
      {
         if(this.configBtn1 != null && this.configBtn2 != null)
         {
            if(Settings.activeConfig == 1)
            {
               this.configBtn1.setActive();
               this.configBtn2.setInActive();
            }
            else if(Settings.activeConfig == 2)
            {
               this.configBtn1.setInActive();
               this.configBtn2.setActive();
            }
         }
      }
      
      private function handleClearCurrentShipConfigurationButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:int = this.lastActiveConfigBtn.configNumber;
         dispatchEvent(new MenuEvent(MenuEvent.EVENT_CONFIG_CLEAR_BUTTON_CLICKED,_loc2_));
      }
      
      private function handleConfigButtonClicked(param1:MouseEvent) : void
      {
         param1.currentTarget.setActive();
         if(this.lastActiveConfigBtn != param1.currentTarget)
         {
            this.lastActiveConfigBtn.setInActive();
            this.lastActiveConfigBtn = ConfigButton(param1.currentTarget);
         }
         dispatchEvent(new MenuEvent(MenuEvent.EVENT_CONFIG_BUTTON_CLICKED,param1.currentTarget.configNumber));
         dispatchEvent(new InventoryEvent(InventoryEvent.CLOSE_DESIGN_MENU));
      }
      
      public function buildHangarSlotButtons(param1:Vector.<int>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:ConfigButton = null;
         if(this.buildOlnlyOnce)
         {
            return;
         }
         this.buildOlnlyOnce = true;
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1[_loc3_];
            _loc5_ = new ConfigButton(_loc4_);
            _loc5_.x = _loc3_ * _loc5_.width + 2;
            _loc5_.y = -13;
            _loc5_.addHoverListener();
            _loc5_.addEventListener(MouseEvent.CLICK,this.handleHangarSlotButtonClicked);
            addChild(_loc5_);
            _loc3_++;
         }
      }
      
      private function handleHangarSlotButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:ConfigButton = param1.currentTarget as ConfigButton;
         var _loc3_:int = _loc2_.configNumber;
         dispatchEvent(new MenuEvent(MenuEvent.EVENT_HANGAR_SLOT_BUTTON_CLICKED,_loc3_));
      }
      
      private function addEventListeners(param1:TabButtonComponent) : void
      {
         param1.addEventListener(MouseEvent.CLICK,this.handleTabButtonClicked);
      }
      
      private function handleTabButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:TabButtonComponent = param1.currentTarget as TabButtonComponent;
         if(_loc2_ != this.lastActiveTab)
         {
            _loc2_.setTabActive();
            this.lastActiveTab.setTabInactive();
            this.lastActiveTab = _loc2_;
         }
         this.selectedTab = _loc2_.tabName;
         dispatchEvent(new Event(TAB_BUTTON_CLICKED));
         dispatchEvent(new InventoryEvent(InventoryEvent.CLOSE_DESIGN_MENU));
      }
      
      public function reactivateShipTabButton() : void
      {
         var _loc2_:TabButtonComponent = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.tabButtonComponents.length)
         {
            _loc2_ = this.tabButtonComponents[_loc1_];
            if(_loc2_.id == TabButtonComponent.ID_SHIP)
            {
               TweenMax.to(_loc2_,0.5,PredefinedFilters.TWEENMAX_COLORMATRIX_COLORED);
            }
            _loc1_++;
         }
      }
      
      public function deactivateShipTabButton() : void
      {
         var _loc2_:TabButtonComponent = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.tabButtonComponents.length)
         {
            _loc2_ = this.tabButtonComponents[_loc1_];
            if(_loc2_.id == TabButtonComponent.ID_SHIP)
            {
               _loc2_.deactive();
               TweenMax.to(_loc2_,0.5,PredefinedFilters.TWEENMAX_COLORMATRIX_BLACKANDWHITE);
            }
            _loc1_++;
         }
      }
   }
}

