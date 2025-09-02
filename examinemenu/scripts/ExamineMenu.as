package
{
   import Shared.AS3.BCGridList;
   import Shared.AS3.BSButtonHintBar;
   import Shared.AS3.BSButtonHintData;
   import Shared.AS3.BSScrollingList;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Data.UIDataFromClient;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.PlatformChangeEvent;
   import Shared.AS3.IMenu;
   import Shared.AS3.PerkClipRequirement;
   import Shared.AS3.QuantityMenu;
   import Shared.AS3.StyleSheet;
   import Shared.AS3.Styles.ExamineMenu_CurrentModListStyle;
   import Shared.AS3.Styles.ExamineMenu_LeftHandListStyle;
   import Shared.AS3.Styles.ExamineMenu_RightHandListStyle;
   import Shared.GlobalFunc;
   import Shared.HUDModes;
   import com.adobe.serialization.json.JSONEncoder;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.ui.*;
   import flash.utils.*;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol443")]
   public class ExamineMenu extends IMenu
   {
      
      private static const MIN_ITEM_CARD_ENTRIES:int = 10;
      
      private static const MAX_ITEM_CARD_ENTRIES:int = 15;
      
      public static const EVENT_TRANSFER_LOCKING_FEATURE_ENABLED:* = "TransferLockingFeature::Enabled";
      
      public static const EVENT_TRANSFER_LOCKING_FEATURE_DISABLED:* = "TransferLockingFeature::Disabled";
      
      public static const EVENT_UPDATE_PIPBOY_INV_SELECTION:String = "Pipboy::UpdateInventorySelection";
      
      public static const EVENT_IS_CRAFTING:String = "Crafting::IsCrafting";
      
      public static const EVENT_LOCK_ITEM:String = "ExamineMenu::TransferLockToggle";
      
      private static var m_IsTransferLockingFeatureEnabled:Boolean = false;
      
      public var BGSCodeObj:Object;
      
      public var InventoryList_mc:MovieClip;
      
      public var ItemName_tf:TextField;
      
      public var CraftingHeirarchy_mc:MovieClip;
      
      public var LegendaryItemDescription_tf:TextField;
      
      public var ModDescriptionBase_mc:MovieClip;
      
      public var ItemCardContainer_mc:MovieClip;
      
      public var ButtonHintBar_mc:BSButtonHintBar;
      
      public var InventoryBase_mc:MovieClip;
      
      public var ModSlotBase_mc:MovieClip;
      
      public var CurrentModsBase_mc:MovieClip;
      
      public var PerkPanel0_mc:PerkClipRequirement;
      
      public var PerkPanel1_mc:PerkClipRequirement;
      
      public var ItemCatcher:MovieClip;
      
      public var MouseReleaseCatcher:MovieClip;
      
      public var VaultBoySafeRectGroup_mc:MovieClip;
      
      public var CenterShadedBG_mc:MovieClip;
      
      public var QuantityModal_mc:QuantityMenu;
      
      public var Header_mc:MovieClip;
      
      public var perkPanelLabel_mc:MovieClip;
      
      public var KnownModsInfo_mc:MovieClip;
      
      public var LegendaryCraftingFanfare_mc:LegendaryCraftingFanfare;
      
      public var ItemCardList_mc:ItemCard;
      
      private var m_ConfirmMenuOpen:Boolean = false;
      
      private var m_LockHolding:Boolean = false;
      
      private var m_LockHoldStartTimeout:int = -1;
      
      private var m_TransferLockText:String = "$LOCK";
      
      private var m_TransferUnlockText:String = "$UNLOCK";
      
      public var InventoryListObject:ListInfoObject = new ListInfoObject();
      
      public var ModSlotListObject:ListInfoObject = new ListInfoObject();
      
      public var ComponentsListObject:ListInfoObject = new ListInfoObject();
      
      public var ModListObject:ListInfoObject = new ListInfoObject();
      
      public var MiscItemListObject:ListInfoObject = new ListInfoObject();
      
      public var RequirementsListObject:ListInfoObject = new ListInfoObject();
      
      public var CurrentModsListObject:ListInfoObject = new ListInfoObject();
      
      public var ItemLevelListObject:ListInfoObject = new ListInfoObject();
      
      private var InspectModeButtons:Vector.<BSButtonHintData>;
      
      private var TakeButton:BSButtonHintData;
      
      private var RenameButton:BSButtonHintData;
      
      private var NextButton:BSButtonHintData;
      
      private var PrevButton:BSButtonHintData;
      
      private var ZoomInButton:BSButtonHintData;
      
      private var ZoomOutButton:BSButtonHintData;
      
      private var ExitButton:BSButtonHintData;
      
      private var ToggleCraftingButton:BSButtonHintData;
      
      private var PrevBtnVisibility:Array = new Array();
      
      private var TakeButtonVisiblity:Boolean = false;
      
      private var ExitButtonVisiblity:Boolean = true;
      
      private var ItemStatsVisibility:Boolean = true;
      
      private var InventoryButtonHints:Vector.<BSButtonHintData>;
      
      private var ModSlotButtonHints:Vector.<BSButtonHintData>;
      
      private var ModButton:BSButtonHintData;
      
      private var BackButton:BSButtonHintData;
      
      private var ScrapButton:BSButtonHintData;
      
      private var ToggleEquipButton:BSButtonHintData;
      
      private var FilterCraftableButton:BSButtonHintData;
      
      private var FilterAtxButton:BSButtonHintData;
      
      private var InspectRepairButton:BSButtonHintData;
      
      private var zel_RepairButton:BSButtonHintData;
      
      private var RepairKitButton:BSButtonHintData;
      
      private var WorkbenchRepairButton:BSButtonHintData;
      
      private var LockButton:BSButtonHintData;
      
      private var ModsListHints:Vector.<BSButtonHintData>;
      
      private var AutoBuild:BSButtonHintData;
      
      private var ChooseComponents:BSButtonHintData;
      
      private var TagButton:BSButtonHintData;
      
      private var AlternateButton:BSButtonHintData;
      
      private var ComponentsListHints:Vector.<BSButtonHintData>;
      
      private var Build:BSButtonHintData;
      
      private var MiscItemListHints:Vector.<BSButtonHintData>;
      
      private var Add:BSButtonHintData;
      
      protected var ItemLevelSelectButtons:Vector.<BSButtonHintData>;
      
      protected var ItemLevelAcceptButton:BSButtonHintData;
      
      protected var ItemLevelCancelButton:BSButtonHintData;
      
      protected var QuantityButtons:Vector.<BSButtonHintData>;
      
      protected var QuantityAcceptButton:BSButtonHintData;
      
      protected var QuantityCancelButton:BSButtonHintData;
      
      protected var ExternalPurchaseButtons:Vector.<BSButtonHintData>;
      
      private var RotateButton:BSButtonHintData = new BSButtonHintData("$ROTATE","A/D","PSN_L2R2","Xenon_L2R2",1,null);
      
      private var CameraButton:BSButtonHintData = new BSButtonHintData("$CAMERA","C","PSN_L1","Xenon_L1",1,null);
      
      private const INIT_MODE:uint = 0;
      
      private const INVENTORY_MODE:uint = 1;
      
      private const SLOTS_MODE:uint = 2;
      
      private const MOD_MODE:uint = 3;
      
      private const REQUIREMENTS_MODE:uint = 4;
      
      private const ITEM_SELECT_MODE:uint = 5;
      
      private const INSPECT_MODE:uint = 6;
      
      private const LEVEL_SELECT_MODE:uint = 7;
      
      private const ITEM_CARD_START_HEIGHT:Number = 82;
      
      private const ITEM_CARD_START_Y:Number = 338.8;
      
      private const ITEM_CARD_ENTRY_HEIGHT:Number = 40;
      
      private const ITEM_CARD_LABEL_START_Y:Number = 340.7;
      
      private const ITEM_CARD_DESCRIPTION_START_Y:Number = 240.05;
      
      private const MAX_CRAFTABLE:uint = 255;
      
      private const SCRAP_ITEM_COUNT_THRESHOLD:uint = 5;
      
      private var _ScrapQuantity:uint = 1;
      
      private var bConfirm:* = false;
      
      private var strStartName:* = "";
      
      private var strBuildButtonText:* = "$BUILD";
      
      private var strAlternateButtonText:String = "";
      
      private var AternateTextEnabled:* = true;
      
      private var LastFocusedClip:InteractiveObject;
      
      private var bEnteringText:Boolean = false;
      
      private var bQueuedBackToMods:Boolean = false;
      
      private var CraftingMenuData:UIDataFromClient = null;
      
      public var _inspectMode:Boolean = false;
      
      private var _featuredItemMode:Boolean = false;
      
      private var _singleItemInspectMode:Boolean = false;
      
      private var _itemNameManagedByCode:Boolean = false;
      
      private var Language:String = "en";
      
      private var _allowClearName:Boolean = false;
      
      private var _allowEquip:Boolean = false;
      
      private var _allowRename:Boolean = true;
      
      private var _allowRepair:Boolean = false;
      
      private var RepairKitsEnabled:Boolean = false;
      
      private var _showScrapButton:Boolean = true;
      
      private var _isCookingMenu:Boolean = false;
      
      private var _eMode:uint = 0;
      
      private var m_IsCrafting:Boolean = false;
      
      private var bTransitionToCrafting:Boolean = false;
      
      private var _craftingHierarchy:Array = new Array();
      
      private var _itemLevelData:Object = null;
      
      private var _allowsModding:Boolean = true;
      
      private var _allowsCrafting:Boolean = true;
      
      private var _modalActive:Boolean = false;
      
      private var _isWorkbench:Boolean = false;
      
      private var _repairKitCount:int = 0;
      
      private var _wasModalJustConfirmed:Boolean = false;
      
      private var _isModeInitialized:* = false;
      
      private var _isExternalPurchaseOpen:Boolean = false;
      
      private var _isWaitingForRefreshMTX:Boolean = false;
      
      private var _HasZeus:Boolean = false;
      
      private var m_CraftableQuantity:uint = 0;
      
      private var m_PreviousMode:String = "";
      
      private var m_SelectedModListEntryIndex:int = -1;
      
      private var m_RestoreSelectedIndex:Boolean = false;
      
      private var m_DynamicModDescEnabled:Boolean = false;
      
      private var m_AdvancedModDescMode:Boolean = false;
      
      private var _improvedWorkbench:ImprovedWorkbench;
      
      private var errorMessage:TextField;
      
      public var __SFCodeObj:Object = new Object();
      
      public function ExamineMenu()
      {
         this.displayFormat();
         this.TakeButton = new BSButtonHintData("$TAKE","Space","PSN_A","Xenon_A",1,this.onTakeButton);
         this.RenameButton = new BSButtonHintData("$RENAME","V","PSN_Select","Xenon_Select",1,this.onRename);
         this.NextButton = new BSButtonHintData("$NEXT","S","PSN_R1","Xenon_R1",1,this.onNextButton);
         this.PrevButton = new BSButtonHintData("$PREV","W","PSN_L1","Xenon_L1",1,this.onPreviousButton);
         this.ZoomInButton = new BSButtonHintData("$ZOOM IN","Wheel up","PSN_R2","Xenon_R2",1,this.onZoomInButton);
         this.ZoomOutButton = new BSButtonHintData("$ZOOM OUT","Wheel down","PSN_L2","Xenon_L2",1,this.onZoomOutButton);
         this.ExitButton = new BSButtonHintData("$EXIT","TAB","PSN_B","Xenon_B",1,this.onBackButton);
         this.ToggleCraftingButton = new BSButtonHintData("$SWITCHTOCRAFT","R","PSN_X","Xenon_X",1,this.onToggleCraftingbutton);
         this.ModButton = new BSButtonHintData("$MODIFY","Space","PSN_A","Xenon_A",1,this.onModButton);
         this.BackButton = new BSButtonHintData("$BACK","TAB","PSN_B","Xenon_B",1,this.onBackButton);
         this.ScrapButton = new BSButtonHintData("$SCRAP","G","PSN_R2","Xenon_R2",1,this.onScrapBuildAdd);
         this.ToggleEquipButton = new BSButtonHintData("$EQUIP","F","PSN_L2","Xenon_L2",1,this.onToggleEquip);
         this.FilterCraftableButton = new BSButtonHintData("$TOGGLECRAFTABLEITEMS","Q","PSN_L3","Xenon_L3",1,this.onFilterCraftable);
         this.FilterAtxButton = new BSButtonHintData("$TOGGLEATXITEMS","V","PSN_Select","Xenon_Select",1,this.onFilterAtx);
         this.InspectRepairButton = new BSButtonHintData("$INSPECT","T","PSN_Y","Xenon_Y",1,this.onInspectRepair);
         this.zel_RepairButton = new BSButtonHintData("$REPAIR","X","PSN_R3","Xenon_R3",1,null);
         this.RepairKitButton = new BSButtonHintData("$REPAIR KIT","T","PSN_Y","Xenon_Y",1,this.onRepairKit);
         this.WorkbenchRepairButton = new BSButtonHintData("$WORKBENCH REPAIR","R","PSN_X","Xenon_X",1,this.onWorkbenchRepair);
         this.LockButton = new BSButtonHintData("$LOCK","L","PSN_Y","Xenon_Y",1,this.onLockButton);
         this.AutoBuild = new BSButtonHintData("$BUILD","Space","PSN_A","Xenon_A",1,this.onScrapBuildAdd);
         this.ChooseComponents = new BSButtonHintData("$CHOOSE COMPONENTS","Space","PSN_A","Xenon_A",1,this.onModButton);
         this.TagButton = new BSButtonHintData("$TAG FOR SEARCH","X","PSN_R3","Xenon_R3",1,this.onSearch);
         this.AlternateButton = new BSButtonHintData("","R","PSN_X","Xenon_X",1,this.onAlternateButton);
         this.Build = new BSButtonHintData("$BUILD","R","PSN_X","Xenon_X",1,this.onScrapBuildAdd);
         this.Add = new BSButtonHintData("$ADD","R","PSN_X","Xenon_X",1,this.onScrapBuildAdd);
         this.ItemLevelAcceptButton = new BSButtonHintData("$ACCEPT","Space","PSN_A","Xenon_A",1,this.onModButton);
         this.ItemLevelCancelButton = new BSButtonHintData("$CANCEL","TAB","PSN_B","Xenon_B",1,this.onBackButton);
         this.QuantityAcceptButton = new BSButtonHintData("$ACCEPT","Space","PSN_A","Xenon_A",1,this.onQuantityAccept);
         this.QuantityCancelButton = new BSButtonHintData("$CANCEL","TAB","PSN_B","Xenon_B",1,this.onQuantityCancel);
         super();
         addFrameScript(11,this.frame12,17,this.frame18,24,this.frame25,37,this.frame38);
         this.ItemCardList_mc = this.ItemCardContainer_mc.ItemCardList_mc;
         this.BGSCodeObj = new Object();
         this.BGSCodeObj.SwitchBaseItem = new Function();
         this.BGSCodeObj.FillModPartArray = new Function();
         this.BGSCodeObj.StartRotate3DItem = new Function();
         this.BGSCodeObj.EndRotate3DItem = new Function();
         this.BGSCodeObj.RevertChanges = new Function();
         this.BGSCodeObj.ShowItem = new Function();
         this.BGSCodeObj.PlaySound = new Function();
         this.BGSCodeObj.LevelSelectChanged = new Function();
         this.ButtonHintBar_mc.useVaultTecColor = true;
         this.RepairKitButton.ButtonVisible = false;
         this.KnownModsInfo_mc.KnownModsInfo_tf.visible = false;
         this.ScrapButton.disabledButtonCallback = this.onScrapClickDisabled;
         this._improvedWorkbench = new ImprovedWorkbench(this);
         setTimeout(rescale,10);
      }
      
      public static function toJSON(obj:*) : String
      {
         return new JSONEncoder(obj).getString();
      }
      
      public static function get IsTransferLockingFeatureEnabled() : Boolean
      {
         return m_IsTransferLockingFeatureEnabled;
      }
      
      public function rescale() : void
      {
         stage.scaleMode = "showAll";
      }
      
      private function displayFormat() : void
      {
         this.errorMessage = new TextField();
         this.errorMessage.x = 20;
         this.errorMessage.y = 40;
         this.errorMessage.width = 1800;
         this.errorMessage.height = 700;
         GlobalFunc.SetText(this.errorMessage,"",false);
         if(false)
         {
            TextFieldEx.setTextAutoSize(this.errorMessage,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
         this.errorMessage.autoSize = TextFieldAutoSize.LEFT;
         this.errorMessage.wordWrap = true;
         this.errorMessage.multiline = true;
         var font:TextFormat = new TextFormat("$MAIN_Font",18,16777215);
         this.errorMessage.defaultTextFormat = font;
         this.errorMessage.setTextFormat(font);
         this.errorMessage.selectable = true;
         this.errorMessage.mouseWheelEnabled = true;
         this.errorMessage.mouseEnabled = true;
         this.errorMessage.visible = false;
         addChild(this.errorMessage);
      }
      
      public function displayError(param1:*, clear:Boolean = false) : void
      {
         var str:String;
         if(!ImprovedWorkbench.Debug)
         {
            return;
         }
         if(clear)
         {
            GlobalFunc.SetText(this.errorMessage,"");
         }
         if(param1 is String)
         {
            str = param1;
         }
         else
         {
            str = toJSON(param1);
         }
         GlobalFunc.SetText(this.errorMessage,this.errorMessage.text + "\n" + str);
         this.errorMessage.visible = true;
         this.errorMessage.scrollV = this.errorMessage.maxScrollV;
         setTimeout(function():void
         {
            var split:Array = errorMessage.text.split("\n");
            if(split.length > 0)
            {
               GlobalFunc.SetText(errorMessage,split.slice(1).join("\n"));
            }
         },7000);
      }
      
      public function AddRotateButtons() : *
      {
         this.InventoryButtonHints.push(this.RotateButton);
         this.ModsListHints.push(this.RotateButton);
         this.ModSlotButtonHints.push(this.RotateButton);
         this.InventoryButtonHints.push(this.CameraButton);
         this.ModsListHints.push(this.CameraButton);
         this.ModSlotButtonHints.push(this.CameraButton);
      }
      
      public function set inspectMode(param1:Boolean) : *
      {
         this._inspectMode = param1;
      }
      
      public function set singleItemInspectMode(param1:Boolean) : *
      {
         this._singleItemInspectMode = param1;
         this.PrevButton.ButtonVisible = this.NextButton.ButtonVisible = !this._singleItemInspectMode;
      }
      
      public function set alternateTextEnabled(param1:Boolean) : *
      {
         this.AternateTextEnabled = param1;
      }
      
      public function set alternateButtonText(param1:String) : *
      {
         this.strAlternateButtonText = param1;
      }
      
      public function set itemNameManagedByCode(param1:Boolean) : *
      {
         this._itemNameManagedByCode = param1;
      }
      
      public function set language(param1:String) : *
      {
         this.Language = param1.toLowerCase();
      }
      
      public function set allowEquip(param1:Boolean) : *
      {
         this._allowEquip = param1;
      }
      
      public function set BuildButtonText(param1:String) : *
      {
         this.strBuildButtonText = param1;
      }
      
      public function set allowClearName(param1:Boolean) : *
      {
         this._allowClearName = param1;
      }
      
      public function set allowRename(param1:Boolean) : *
      {
         this._allowRename = param1;
      }
      
      public function set allowRepair(param1:Boolean) : *
      {
         this._allowRepair = param1;
      }
      
      public function set showScrapButton(param1:Boolean) : *
      {
         this._showScrapButton = param1;
      }
      
      public function set knownModsInfo(param1:String) : *
      {
         this.KnownModsInfo_mc.KnownModsInfo_tf.text = param1;
      }
      
      public function get itemStatsVisibility() : *
      {
         return this.ItemStatsVisibility;
      }
      
      public function set itemStatsVisibility(param1:Boolean) : *
      {
         this.ItemStatsVisibility = param1;
      }
      
      public function get inspectMode() : *
      {
         return this._inspectMode;
      }
      
      public function get shouldHighlight() : Boolean
      {
         return this.eMode != this.INVENTORY_MODE && this.eMode != this.INSPECT_MODE;
      }
      
      public function get inventoryLevel() : Boolean
      {
         return this.eMode == this.INVENTORY_MODE;
      }
      
      public function get resetItemRotation() : Boolean
      {
         return this.eMode == this.INVENTORY_MODE;
      }
      
      public function get shouldReshow() : Boolean
      {
         return this.eMode == this.INVENTORY_MODE || this.eMode == this.MOD_MODE || this.eMode == this.INSPECT_MODE;
      }
      
      public function get isCrafting() : Boolean
      {
         return this.m_IsCrafting;
      }
      
      public function get allowClearName() : *
      {
         return this.eMode == this.INSPECT_MODE && this._allowClearName;
      }
      
      public function get allowRename() : *
      {
         return this.eMode == this.INSPECT_MODE && this._allowRename;
      }
      
      public function get isCookingMenu() : Boolean
      {
         return this._isCookingMenu;
      }
      
      private function RefreshKnownModsVisibility() : *
      {
         this.KnownModsInfo_mc.KnownModsInfo_tf.visible = !this.isCrafting && (this._eMode == this.INVENTORY_MODE || this._eMode == this.SLOTS_MODE || this._eMode == this.MOD_MODE);
      }
      
      private function get eMode() : *
      {
         return this._eMode;
      }
      
      private function set eMode(param1:uint) : *
      {
         this._eMode = param1;
         this.SetButtonHintData();
         this.UpdateButtons();
         this.RefreshKnownModsVisibility();
      }
      
      private function get isWorkbench() : *
      {
         return this._isWorkbench;
      }
      
      private function set isWorkbench(param1:Boolean) : *
      {
         this._isWorkbench = param1;
         this.SetButtonHintData();
         this.UpdateButtons();
      }
      
      private function get repairKitCount() : *
      {
         return this._repairKitCount;
      }
      
      private function set repairKitCount(param1:uint) : *
      {
         this._repairKitCount = param1;
         this.SetButtonHintData();
         this.UpdateButtons();
      }
      
      public function get externalPurchaseOpen() : *
      {
         return this._isExternalPurchaseOpen;
      }
      
      public function set externalPurchaseOpen(param1:Boolean) : *
      {
         this._isExternalPurchaseOpen = param1;
         this.SetButtonHintData();
         this.UpdateButtons();
      }
      
      public function get isWaitingForRefreshMTX() : *
      {
         return this._isWaitingForRefreshMTX;
      }
      
      public function set isWaitingForRefreshMTX(param1:Boolean) : *
      {
         this._isWaitingForRefreshMTX = param1;
         this.UpdateButtons();
      }
      
      public function get allowsModding() : Boolean
      {
         return this._allowsModding;
      }
      
      public function set allowsModding(param1:Boolean) : *
      {
         this._allowsModding = param1;
         if(!this.isCrafting && !this._allowsModding)
         {
            this.ToggleCrafting();
         }
      }
      
      public function get allowsCrafting() : Boolean
      {
         return this._allowsCrafting;
      }
      
      public function set allowsCrafting(param1:Boolean) : *
      {
         this._allowsCrafting = param1;
         if(this.isCrafting && !this._allowsCrafting)
         {
            this.ToggleCrafting();
         }
      }
      
      public function get modalActive() : Boolean
      {
         return this._modalActive;
      }
      
      public function set modalActive(param1:Boolean) : *
      {
         if(param1 != this._modalActive)
         {
            this._modalActive = param1;
            if(this._modalActive)
            {
               gotoAndPlay("examineMessageBox");
            }
            else
            {
               gotoAndPlay("examineMessageBoxOff");
            }
         }
      }
      
      private function updateModalActive() : *
      {
         var _loc1_:String = BSUIDataManager.GetDataFromClient("HUDModeData").data.hudMode;
         this.modalActive = this.QuantityModal_mc.opened || _loc1_ == HUDModes.MESSAGE_MODE;
         this.InventoryBase_mc.InventoryList_mc.disableInput_Inspectable = this.modalActive || !this.InventoryBase_mc.visible;
         this.ItemLevelListObject.disableInput = this.modalActive || !this.InventoryBase_mc.visible;
      }
      
      public function set isCrafting(param1:Boolean) : *
      {
         this.m_IsCrafting = param1;
         this._isCookingMenu = this.m_IsCrafting;
         this.RefreshKnownModsVisibility();
      }
      
      public function onToggleCraftingbutton() : *
      {
         if(!this.inspectMode && this.allowsModding && this.allowsCrafting && !this.QuantityModal_mc.opened)
         {
            this.ToggleCrafting();
         }
      }
      
      private function onFFEvent(param1:FromClientDataEvent) : void
      {
         var _loc2_:* = param1.data;
         if(GlobalFunc.HasFFEvent(_loc2_,EVENT_TRANSFER_LOCKING_FEATURE_ENABLED))
         {
            m_IsTransferLockingFeatureEnabled = true;
            this.BGSCodeObj.UpdateItemList();
         }
         else if(GlobalFunc.HasFFEvent(_loc2_,EVENT_TRANSFER_LOCKING_FEATURE_DISABLED))
         {
            m_IsTransferLockingFeatureEnabled = false;
            this.BGSCodeObj.UpdateItemList();
         }
      }
      
      override public function onAddedToStage() : void
      {
         StyleSheet.apply(this.InventoryBase_mc.InventoryList_mc,false,ExamineMenu_LeftHandListStyle);
         StyleSheet.apply(this.ModSlotBase_mc.ModSlotList_mc,false,ExamineMenu_RightHandListStyle);
         StyleSheet.apply(this.CurrentModsBase_mc.ModSlotList_mc,false,ExamineMenu_CurrentModListStyle);
         TextFieldEx.setTextAutoSize(this.ItemName_tf,"shrink");
         TextFieldEx.setTextAutoSize(this.PerkPanel0_mc.Title_mc.Title_tf,"shrink");
         TextFieldEx.setTextAutoSize(this.PerkPanel1_mc.Title_mc.Title_tf,"shrink");
         this.MiscItemListObject.CategoryNameList = new Array();
         Extensions.enabled = true;
         this.MouseReleaseCatcher.visible = false;
         stage.stageFocusRect = false;
         this.alpha = 0;
         this.ItemName_tf.selectable = false;
         this.itemName = "";
         this.CurrentModsBase_mc.visible = false;
         this.CurrentModsBase_mc.ModSlotList_mc.disableSelection_Inspectable = true;
         this.PopulateButtonBar();
         addEventListener(BSScrollingList.ITEM_PRESS,this.onItemPressed);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         addEventListener(QuantityMenu.CONFIRM,this.onQuantityAccept);
         addEventListener(PlatformChangeEvent.PLATFORM_CHANGE,this.onPlatformChange);
         BSUIDataManager.Subscribe("FireForgetEvent",this.onFFEvent);
         this.InventoryListObject.addEventListener(BSScrollingList.SELECTION_CHANGE,this.InventorySelectionChange);
         this.ModSlotListObject.addEventListener(BSScrollingList.SELECTION_CHANGE,this.FillPossibleModPartArray);
         this.ModSlotListObject.addEventListener(ListInfoObject.ENTRY_LIST_CHANGE,this.UpdateButtons);
         this.ModListObject.addEventListener(BSScrollingList.SELECTION_CHANGE,this.ModChange);
         this.ModListObject.addEventListener(ListInfoObject.FILTERS_DUPLICATE_CHANGE,this.FillPossibleModPartArray);
         this.RequirementsListObject.addEventListener(BSScrollingList.SELECTION_CHANGE,this.UpdateMiscItemList);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.OnStopRotateItem);
         this.ItemCatcher.addEventListener(MouseEvent.MOUSE_DOWN,this.OnStartRotateItem);
         this.ItemLevelListObject.addEventListener(BSScrollingList.SELECTION_CHANGE,this.LevelChange);
         this.InventoryBase_mc.InventoryList_mc.addsDummyEntryOnBlankList = true;
         this.InventoryBase_mc.InventoryList_mc.dummyEntryText = "$NO_ITEMS";
         this.ModSlotBase_mc.ModSlotList_mc.addsDummyEntryOnBlankList = true;
         this.ModSlotBase_mc.ModSlotList_mc.dummyEntryText = "$None_Available";
         this.ModDescriptionBase_mc.DynamicModDescription_mc.maxRows = 1;
         this.ModDescriptionBase_mc.DynamicModDescription_mc.maxCols = 6;
         this.ModDescriptionBase_mc.DynamicModDescription_mc.listItemClassName = "DynamicModDescriptionEntry";
         this.ModDescriptionBase_mc.DynamicModDescription_mc.scrollVertical = false;
         this.ModDescriptionBase_mc.DynamicModDescription_mc.useVariableWidth = true;
         this.ModDescriptionBase_mc.DynamicModDescription_mc.disableInput = true;
         addEventListener(BCGridList.LIST_UPDATED,this.onDynamicModDescriptionUpdated);
         this.ItemCardList_mc.bottomUp = true;
         this.ItemCardList_mc.entrySpacing = 2.5;
         this.ItemCardList_mc.showItemDesc = false;
         this.ItemCardList_mc.blankEntryFillTarget = 10;
         this.ItemCardList_mc.addEventListener(ItemCard.EVENT_ITEM_CARD_UPDATED,this.OnItemCardUpdated);
      }
      
      private function finalizeInitialization() : *
      {
         BSUIDataManager.Subscribe("ItemLevelEligibilityData",function(param1:FromClientDataEvent):*
         {
            ItemLevelListObject.removeEventListener(BSScrollingList.SELECTION_CHANGE,LevelChange);
            var _loc2_:uint = ItemLevelListObject.selectedIndex;
            ItemLevelListObject.entryList = new Array();
            _itemLevelData = param1.data;
            var _loc3_:* = param1.data.levels;
            var _loc4_:* = _loc3_.length;
            var _loc5_:* = 0;
            while(_loc5_ < _loc4_)
            {
               ItemLevelListObject.entryList.push({
                  "text":"$$LEVEL " + _loc3_[_loc5_].level.toString(),
                  "level":_loc3_[_loc5_].level,
                  "hasRequired":_loc3_[_loc5_].hasRequired
               });
               _loc5_++;
            }
            ItemLevelListObject.RefreshList();
            ItemLevelListObject.addEventListener(BSScrollingList.SELECTION_CHANGE,LevelChange);
            ItemLevelListObject.selectedIndex = _loc2_;
         });
         BSUIDataManager.Subscribe("ExamineMenuMode",function(param1:FromClientDataEvent):*
         {
            var _loc2_:String = param1.data.mode;
            if(_loc2_.length > 0)
            {
               if(m_PreviousMode != _loc2_ || _loc2_ == "inspect")
               {
                  m_PreviousMode = _loc2_;
                  switch(_loc2_)
                  {
                     case "inspect":
                        EnterInspect();
                        break;
                     case "crafting":
                        isCrafting = true;
                        EnterCrafting();
                        break;
                     case "modding":
                        isCrafting = false;
                        EnterModding();
                  }
               }
               ItemCard_Entry.DynamicModDescEnable = param1.data.dynamicModDescEnabled;
               ItemCard_Entry.AdvanceModDescMode = param1.data.advancedModDesc;
               DynamicModDescriptionEntry.AdvancedModDescMode = param1.data.advancedModDesc;
               m_DynamicModDescEnabled = param1.data.dynamicModDescEnabled;
               m_AdvancedModDescMode = param1.data.advancedModDesc;
               allowsModding = param1.data.allowsModding;
               allowsCrafting = param1.data.allowsCrafting;
               ToggleCraftingButton.ButtonVisible = allowsModding && allowsCrafting;
               _allowRename = param1.data.allowsRenaming;
               RenameButton.ButtonVisible = _allowRename;
               allowClearName = param1.data.canClearName;
               isWorkbench = param1.data.isWorkbench;
               repairKitCount = param1.data.repairKitCount;
               RepairKitsEnabled = param1.data.repairKitsEnabled;
               if(m_IsTransferLockingFeatureEnabled != param1.data.isTransferLockingFeatureEnabled)
               {
                  m_IsTransferLockingFeatureEnabled = param1.data.isTransferLockingFeatureEnabled;
                  InventoryBase_mc.InventoryList_mc.InvalidateData();
               }
               RenameButton.ButtonText = allowClearName ? "$CLEARNAME" : "$RENAME";
            }
         });
         BSUIDataManager.Subscribe("HUDModeData",function(param1:FromClientDataEvent):void
         {
            updateModalActive();
         });
         BSUIDataManager.Subscribe("AccountInfoData",function(param1:FromClientDataEvent):void
         {
            _HasZeus = param1.data.hasZeus;
            UpdateButtons();
         });
         BSUIDataManager.Subscribe("MenuStackData",this.onMenuStackUpdate);
      }
      
      private function onPlatformChange(param1:PlatformChangeEvent) : void
      {
         this.UpdateButtons();
      }
      
      private function onMenuStackUpdate(param1:FromClientDataEvent) : void
      {
         var _loc2_:int = 0;
         if(Boolean(param1.data) && Boolean(param1.data.menuStackA))
         {
            this.m_ConfirmMenuOpen = false;
            _loc2_ = param1.data.menuStackA.length - 1;
            while(_loc2_ > -1)
            {
               if(param1.data.menuStackA[_loc2_].menuName == "ExamineConfirmMenu")
               {
                  this.m_ConfirmMenuOpen = true;
                  break;
               }
               _loc2_--;
            }
            this.InventoryBase_mc.InventoryList_mc.disableInput_Inspectable = this.m_ConfirmMenuOpen || !this.InventoryBase_mc.visible;
            this.ItemLevelListObject.disableInput = this.m_ConfirmMenuOpen;
            if(this.m_ConfirmMenuOpen && this.isCrafting && this.m_RestoreSelectedIndex)
            {
               this.m_RestoreSelectedIndex = false;
               if(this.eMode == this.LEVEL_SELECT_MODE)
               {
                  this.ItemLevelListObject.selectedIndex = this.m_SelectedModListEntryIndex;
               }
               else
               {
                  this.ModListObject.selectedIndex = this.m_SelectedModListEntryIndex;
               }
            }
         }
      }
      
      private function ToggleCrafting(param1:Boolean = false, param2:Boolean = true) : *
      {
         if(this.inspectMode)
         {
            return;
         }
         this.isCrafting = !this.isCrafting;
         if(param1)
         {
            this.isCrafting = param2 ? true : false;
         }
         if(this.isCrafting)
         {
            this.EnterCrafting();
         }
         else
         {
            this.EnterModding();
         }
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_IS_CRAFTING,{"isCrafting":this.m_IsCrafting}));
      }
      
      public function DisplayLegendaryFanfare(param1:String, param2:Boolean) : void
      {
         this.LegendaryCraftingFanfare_mc.ShowFanfare(param1,param2);
      }
      
      public function GoBackToMod() : void
      {
         this.EnterModding();
      }
      
      public function ResetCraftingModding() : *
      {
         if(this._isModeInitialized)
         {
            this.BGSCodeObj.RevertChanges();
            if(this.eMode == this.MOD_MODE)
            {
               this.ModModeToSlotsMode();
            }
            else
            {
               this.InventoryModeToSlotsMode();
            }
            this.RequirementsListObject.SetInactive();
            this.ItemLevelListObject.SetInactive();
            if(!this.inspectMode)
            {
               this.InventoryBase_mc.InventoryList_mc.selectedIndex = -1;
               this.InventoryBase_mc.InventoryList_mc.moveSelectionDown();
            }
            this.ModListObject.removeEventListener(BSScrollingList.SELECTION_CHANGE,this.ModChange);
         }
      }
      
      public function EnterInspect() : *
      {
         this._isModeInitialized = true;
         this.inspectMode = true;
         this.InventoryBase_mc.visible = false;
         this.ModSlotBase_mc.visible = false;
         this.CurrentModsBase_mc.ModSlotList_mc.visible = true;
         this.ItemCardContainer_mc.visible = this.ItemStatsVisibility;
         this.CurrentModsListObject.SetActive(this.CurrentModsBase_mc.ModSlotList_mc,"CurrentModsListObject");
         this.eMode = this.INSPECT_MODE;
         this.InventoryBase_mc.InventoryList_mc.disableInput_Inspectable = true;
         this.InventoryListObject.SetActive(this.InventoryBase_mc.InventoryList_mc,"InventoryListObject");
         this.SetCraftingHierarchy("");
         this.SetRightListLabel("$CURRENT MODS");
         this.UpdatePerks();
         this.UpdateBackground();
         this.UpdateDescription();
         this.UpdateButtons();
         this.alpha = 1;
         this._improvedWorkbench.initUI();
      }
      
      public function EnterCrafting() : *
      {
         this.ResetCraftingModding();
         this._isModeInitialized = true;
         this.inspectMode = false;
         this.SetCraftingHierarchy("$CRAFTING");
         this.ModButton.ButtonText = "$Select";
         this.Build.ButtonText = this.strBuildButtonText;
         this.AutoBuild.ButtonText = this.strBuildButtonText;
         this.eMode = this.SLOTS_MODE;
         this.SetRightListLabel("$AVAILABLE RECIPES");
         this.ItemLevelListObject.SetInactive();
         this.ModSlotListObject.SetInactive();
         this.ModListObject.SetInactive();
         this.ModSlotListObject.SetActive(this.InventoryBase_mc.InventoryList_mc,"ModSlotListObject");
         this.ModListObject.SetActive(this.ModSlotBase_mc.ModSlotList_mc,"ModListObject");
         this.ModListObject.filtersDuplicates = true;
         this.ModSlotListObject.addEventListener(BSScrollingList.SELECTION_CHANGE,this.FillPossibleModPartArray);
         this.ModSlotBase_mc.ModSlotList_mc.disableSelection_Inspectable = false;
         this.ModSlotBase_mc.ModSlotList_mc.allowWheelScrollNoSelectionChange = false;
         this.ModSlotBase_mc.ModSlotList_mc.selectedIndex = -1;
         this.ModSlotBase_mc.ModSlotList_mc.InvalidateData();
         this.InventoryListObject.SetInactive();
         this.InventoryListObject.removeEventListener(BSScrollingList.SELECTION_CHANGE,this.InventorySelectionChange);
         this.InventoryListObject.addEventListener(BSScrollingList.SELECTION_CHANGE,this.InventorySelectionChange);
         this.UpdatePerks();
         this.UpdateBackground();
         this.UpdateDescription();
         this.UpdateButtons();
         this.alpha = 1;
         this._improvedWorkbench.initUI();
      }
      
      public function EnterModding() : *
      {
         this.ResetCraftingModding();
         this._isModeInitialized = true;
         this.inspectMode = false;
         this.InventoryBase_mc.visible = true;
         this.InventoryBase_mc.InventoryList_mc.disableInput_Inspectable = false;
         this.ModSlotBase_mc.visible = true;
         this.CurrentModsBase_mc.ModSlotList_mc.visible = false;
         this.SetCraftingHierarchy("$MODIFY");
         this.ModButton.ButtonText = "$MODIFY";
         this.eMode = this.INVENTORY_MODE;
         this.BGSCodeObj.RemoveHighlight();
         this.ModListObject.SetInactive();
         this.ModSlotListObject.SetActive(this.ModSlotBase_mc.ModSlotList_mc,"ModSlotListObject");
         this.InventoryListObject.SetActive(this.InventoryBase_mc.InventoryList_mc,"InventoryListObject");
         this.SetRightListLabel("$CURRENT MODS");
         this.ModSlotBase_mc.ModSlotList_mc.disableSelection_Inspectable = true;
         this.ModSlotBase_mc.ModSlotList_mc.allowWheelScrollNoSelectionChange = true;
         this.ModSlotBase_mc.ModSlotList_mc.selectedIndex = -1;
         this.ModSlotBase_mc.ModSlotList_mc.InvalidateData();
         this.InventorySelectionChange(new Event(""));
         this.BGSCodeObj.UpdateItemList();
         this.BGSCodeObj.SwitchBaseItem();
         this.UpdatePerks();
         this.UpdateBackground();
         this.UpdateDescription();
         this.UpdateButtons();
         this.alpha = 1;
         this._improvedWorkbench.initUI();
      }
      
      private function OnStartRotateItem(param1:MouseEvent) : void
      {
         this.BGSCodeObj.StartRotate3DItem();
         this.MouseReleaseCatcher.visible = true;
      }
      
      private function OnStopRotateItem(param1:MouseEvent) : void
      {
         this.BGSCodeObj.EndRotate3DItem();
         this.MouseReleaseCatcher.visible = false;
      }
      
      public function AllowRotate() : Boolean
      {
         return this.eMode != this.MOD_MODE || this.ModSlotBase_mc.ModSlotList_mc.entryList.length <= ExamineMenu_RightHandListStyle.numListItems_Inspectable;
      }
      
      private function onItemPressed(param1:Event) : *
      {
         if(!this.bEnteringText && !this.modalActive && !this._wasModalJustConfirmed)
         {
            this.onModButton();
            param1.stopPropagation();
         }
         if(this._wasModalJustConfirmed)
         {
            this._wasModalJustConfirmed = false;
         }
      }
      
      public function set itemName(param1:String) : *
      {
         GlobalFunc.SetText(this.ItemName_tf,param1,false,false);
      }
      
      private function PopulateButtonBar() : void
      {
         this.ItemLevelSelectButtons = new Vector.<BSButtonHintData>();
         this.ItemLevelSelectButtons.push(this.ItemLevelAcceptButton);
         this.ItemLevelSelectButtons.push(this.ItemLevelCancelButton);
         this.ItemLevelAcceptButton.ButtonVisible = false;
         this.ItemLevelCancelButton.ButtonVisible = false;
         this.ItemLevelSelectButtons.push(this.ToggleCraftingButton);
         this.ItemLevelSelectButtons.push(this.FilterCraftableButton);
         this.ItemLevelSelectButtons.push(this.FilterAtxButton);
         this.InspectModeButtons = new Vector.<BSButtonHintData>();
         this.InspectModeButtons.push(this.RenameButton);
         this.InspectModeButtons.push(this.TakeButton);
         this.InspectModeButtons.push(this.PrevButton);
         this.InspectModeButtons.push(this.NextButton);
         this.InspectModeButtons.push(this.ZoomInButton);
         this.InspectModeButtons.push(this.ZoomOutButton);
         this.InspectModeButtons.push(this.RepairKitButton);
         this.InspectModeButtons.push(this.WorkbenchRepairButton);
         this.InspectModeButtons.push(this.ExitButton);
         this.TakeButton.ButtonVisible = this.TakeButtonVisiblity;
         this.InventoryButtonHints = new Vector.<BSButtonHintData>();
         this.InventoryButtonHints.push(this.ToggleEquipButton);
         this.InventoryButtonHints.push(this.ScrapButton);
         this.InventoryButtonHints.push(this.InspectRepairButton);
         this.InventoryButtonHints.push(this.zel_RepairButton);
         this.InventoryButtonHints.push(this.LockButton);
         this.InventoryButtonHints.push(this.ModButton);
         this.InventoryButtonHints.push(this.ExitButton);
         this.InventoryButtonHints.push(this.AlternateButton);
         this.InventoryButtonHints.push(this.ToggleCraftingButton);
         this.InventoryButtonHints.push(this.FilterCraftableButton);
         this.InventoryButtonHints.push(this.FilterAtxButton);
         this.ModSlotButtonHints = new Vector.<BSButtonHintData>();
         this.ModSlotButtonHints.push(this.ModButton);
         this.ModSlotButtonHints.push(this.BackButton);
         this.ModSlotButtonHints.push(this.AlternateButton);
         this.ModSlotButtonHints.push(this.ToggleCraftingButton);
         this.ModSlotButtonHints.push(this.FilterCraftableButton);
         this.ModSlotButtonHints.push(this.FilterAtxButton);
         this.ModsListHints = new Vector.<BSButtonHintData>();
         this.ModsListHints.push(this.AutoBuild);
         this.ModsListHints.push(this.TagButton);
         this.ModsListHints.push(this.BackButton);
         this.ModsListHints.push(this.AlternateButton);
         this.ModsListHints.push(this.ToggleCraftingButton);
         this.ModsListHints.push(this.FilterCraftableButton);
         this.ModsListHints.push(this.FilterAtxButton);
         this.ComponentsListHints = new Vector.<BSButtonHintData>();
         this.ComponentsListHints.push(this.Build);
         this.ComponentsListHints.push(this.ChooseComponents);
         this.ComponentsListHints.push(this.BackButton);
         this.MiscItemListHints = new Vector.<BSButtonHintData>();
         this.MiscItemListHints.push(this.Add);
         this.MiscItemListHints.push(this.BackButton);
         this.MiscItemListHints.push(this.ToggleCraftingButton);
         this.MiscItemListHints.push(this.FilterCraftableButton);
         this.MiscItemListHints.push(this.FilterAtxButton);
         this.QuantityButtons = new Vector.<BSButtonHintData>();
         this.QuantityButtons.push(this.QuantityAcceptButton);
         this.QuantityButtons.push(this.QuantityCancelButton);
         this.ExternalPurchaseButtons = new Vector.<BSButtonHintData>();
         this.ToggleCraftingButton.ButtonVisible = this.allowsModding && this.allowsCrafting;
      }
      
      public function RegisterComponents() : *
      {
         this.BGSCodeObj.RegisterComponents(this,this.InventoryListObject,this.ItemName_tf,this.ModDescriptionBase_mc.ModDescription_tf,this.ItemCardList_mc,this.ComponentsListObject,this.ModSlotListObject,this.ModListObject,this.MiscItemListObject,this.RequirementsListObject,this.ButtonHintBar_mc,this.CurrentModsListObject);
         stage.focus = this.InventoryBase_mc.InventoryList_mc;
         this.finalizeInitialization();
      }
      
      public function FillPossibleModPartArray(param1:Event) : *
      {
         if(ImprovedWorkbench.DEBUG_SELECTION)
         {
            displayError(this.ModSlotListObject.selectedEntry);
         }
         if(this.ModSlotListObject.selectedIndex > -1 && this.ModListObject.entryList)
         {
            this.BGSCodeObj.FillModPartArray(this.ModListObject.entryList,this.ModListObject);
         }
         this.UpdateDescription();
         this.UpdateBackground();
      }
      
      public function ModChange(param1:Event) : *
      {
         if(!this.bEnteringText)
         {
            this.onModChange();
         }
      }
      
      public function onModChange() : *
      {
         var textIds:String;
         var _loc1_:Array;
         if(ImprovedWorkbench.DEBUG_SELECTION)
         {
            displayError(this.ModListObject.selectedEntry);
            textIds = "";
            this.ModListObject.selectedEntry.text.split("").forEach(function(x:String):void
            {
               textIds += x.charCodeAt(0) + ",";
            });
            displayError("codes: " + textIds);
         }
         _loc1_ = null;
         if(!this._isCookingMenu || this.eMode == this.MOD_MODE)
         {
            _loc1_ = new Array();
            this.BGSCodeObj.SwitchMod(this.ModListObject.selectedIndex,_loc1_);
            this.AutoBuild.ButtonEnabled = this.GetBuildable();
            this.AutoBuild.ButtonVisible = true;
            this.AutoBuild.ButtonText = this.GetLooseModAvailable() ? "$ATTACH MOD" : "$BUILD";
            if(this.ChooseComponents != null && this.ModListObject.active && this.ModListObject.selectedIndex >= 0)
            {
               if(this.eMode == this.MOD_MODE && Boolean(this.ModListObject.entryList[this.ModListObject.selectedIndex].hasLooseMod))
               {
                  this.ChooseComponents.ButtonText = "$ATTACH MOD";
               }
               else
               {
                  this.ChooseComponents.ButtonText = "$CHOOSE COMPONENTS";
               }
            }
            this.UpdatePerks();
            this.UpdateBackground();
            this.UpdateDescription();
            this.UpdateButtons();
         }
      }
      
      public function LevelChange(param1:Event) : *
      {
         var _loc2_:* = this.ItemLevelListObject.selectedEntry;
         if(_loc2_)
         {
            this.BGSCodeObj.LevelSelectChanged(_loc2_.level);
         }
      }
      
      public function UpdateBackground() : *
      {
         if(this.eMode == this.INSPECT_MODE)
         {
            if(this.CurrentModsListObject.entryList.length)
            {
               this.CenterShadedBG_mc.gotoAndStop("inspect");
               GlobalFunc.SetText(this.CurrentModsBase_mc.SlotsLabel_tf,"$CURRENT MODS",false);
            }
            else
            {
               if(!this.ItemStatsVisibility)
               {
                  this.CenterShadedBG_mc.gotoAndStop("inspectNoMenus");
               }
               else
               {
                  this.CenterShadedBG_mc.gotoAndStop("inspectNoMods");
               }
               GlobalFunc.SetText(this.CurrentModsBase_mc.SlotsLabel_tf,"",false);
            }
            this.perkPanelLabel_mc.visible = false;
         }
         else if(this.PerkPanel0_mc.visible || this.PerkPanel1_mc.visible)
         {
            this.CenterShadedBG_mc.gotoAndStop("craftModPerks");
            this.perkPanelLabel_mc.visible = true;
         }
         else
         {
            this.CenterShadedBG_mc.gotoAndStop("craftMod");
            this.perkPanelLabel_mc.visible = false;
         }
         var _loc1_:Boolean = this.eMode != this.INSPECT_MODE && this.allowsModding && this.allowsCrafting;
      }
      
      public function UpdatePerks() : *
      {
         var _loc1_:PerkClipRequirement = null;
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         if(this.eMode != this.MOD_MODE && this.eMode != this.LEVEL_SELECT_MODE)
         {
            this.PerkPanel0_mc.visible = false;
            this.PerkPanel1_mc.visible = false;
         }
         else if(this.ModListObject.selectedIndex >= 0 && this.ModListObject.entryList[this.ModListObject.selectedIndex].perkData != null)
         {
            _loc3_ = 0;
            while(_loc3_ < 2)
            {
               _loc1_ = getChildByName("PerkPanel" + _loc3_ + "_mc") as PerkClipRequirement;
               if(_loc3_ < this.ModListObject.entryList[this.ModListObject.selectedIndex].perkData.length)
               {
                  _loc2_ = this.ModListObject.entryList[this.ModListObject.selectedIndex].perkData[_loc3_];
                  _loc1_.perkName = _loc2_.text;
                  _loc1_.rank = _loc2_.rank;
                  _loc1_.vaultBoyImageName = _loc2_.clipName;
                  _loc1_.animated = _loc2_.isAnimatedPerk;
                  _loc1_.isLevelMet = !_loc2_.perkLocked;
                  _loc1_.visible = true;
               }
               else
               {
                  _loc1_.visible = false;
               }
               _loc3_++;
            }
         }
      }
      
      public function InventorySelectionChange(param1:Event) : *
      {
         if(ImprovedWorkbench.DEBUG_SELECTION)
         {
            displayError(this.InventoryBase_mc.InventoryList_mc.selectedEntry);
         }
         if(!this._isCookingMenu)
         {
            this.BGSCodeObj.SwitchBaseItem();
            this.FillPossibleModPartArray(new Event(""));
            this.UpdateDescription();
            this.UpdateButtons();
         }
      }
      
      private function UpdateMiscItemList() : *
      {
         this.MiscItemListObject.filterer.itemFilter = 1 << this.RequirementsListObject.selectedIndex;
         this.MiscItemListObject.RefreshList();
         this.UpdateButtons();
      }
      
      private function SetRightListLabel(param1:String) : *
      {
         GlobalFunc.SetText(this.ModSlotBase_mc.SlotsLabel_tf,param1,false);
      }
      
      public function ModModeToSlotsMode() : *
      {
         this.BGSCodeObj.RevertChanges();
         this.bQueuedBackToMods = true;
         if(this.isCrafting)
         {
            this.ExecuteQueuedActions();
         }
      }
      
      public function ExecuteQueuedActions() : *
      {
         if(this.bQueuedBackToMods && this.eMode != this.INVENTORY_MODE)
         {
            this.ModListObject.removeEventListener(BSScrollingList.SELECTION_CHANGE,this.ModChange);
            this.bQueuedBackToMods = false;
            this.eMode = this.SLOTS_MODE;
            this.RequirementsListObject.SetInactive();
            this.ModSlotListObject.removeEventListener(BSScrollingList.SELECTION_CHANGE,this.FillPossibleModPartArray);
            this.ModSlotListObject.SetInactive();
            this.ModListObject.SetInactive();
            this.ModSlotListObject.SetActive(this.InventoryBase_mc.InventoryList_mc,"ModSlotListObject");
            this.ModListObject.SetActive(this.ModSlotBase_mc.ModSlotList_mc,"ModListObject");
            this.ModListObject.filtersDuplicates = true;
            this.SetRightListLabel(this._isCookingMenu ? "$AVAILABLE RECIPES" : "$AVAILABLE MODS");
            this.ModSlotListObject.addEventListener(BSScrollingList.SELECTION_CHANGE,this.FillPossibleModPartArray);
            this.UpdatePerks();
            this.UpdateBackground();
            this.UpdateDescription();
         }
      }
      
      public function InventoryModeToSlotsMode() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.isCrafting || this.ModSlotBase_mc.ModSlotList_mc.entryList.length > 0)
         {
            if(!this._isCookingMenu)
            {
               this.InventoryListObject.SetInactive();
            }
            this.ModSlotListObject.SetInactive();
            this.ModListObject.SetInactive();
            this.ModListObject.SetActive(this.ModSlotBase_mc.ModSlotList_mc,"ModListObject");
            if(this.m_IsCrafting)
            {
               this.ModListObject.removeEventListener(ListInfoObject.FILTERS_DUPLICATE_CHANGE,this.FillPossibleModPartArray);
               this.ModListObject.filtersDuplicates = true;
               this.ModListObject.addEventListener(ListInfoObject.FILTERS_DUPLICATE_CHANGE,this.FillPossibleModPartArray);
            }
            this.ModSlotListObject.SetActive(this.InventoryBase_mc.InventoryList_mc,"ModSlotListObject");
            this.InventoryBase_mc.InventoryList_mc.selectedIndex = -1;
            this.InventoryBase_mc.InventoryList_mc.moveSelectionDown();
            this.eMode = this.SLOTS_MODE;
            this.SetRightListLabel(this._isCookingMenu ? "$AVAILABLE RECIPES" : "$AVAILABLE MODS");
            this.BGSCodeObj.PlaySound("UIMenuOK");
            _loc1_ = true;
         }
         else
         {
            this.BGSCodeObj.PlaySound("UICancel");
         }
         return _loc1_;
      }
      
      private function GetModEquipped() : *
      {
         return this.ModListObject.entryList.length > this.ModListObject.selectedIndex && this.ModListObject.selectedIndex >= 0 && this.ModListObject.entryList[this.ModListObject.selectedIndex].equipState != undefined && this.ModListObject.entryList[this.ModListObject.selectedIndex].equipState > 0;
      }
      
      private function GetIsMTX() : *
      {
         return this.ModListObject.entryList.length > this.ModListObject.selectedIndex && this.ModListObject.selectedIndex >= 0 && this.ModListObject.entryList[this.ModListObject.selectedIndex].isMTX != undefined && this.ModListObject.entryList[this.ModListObject.selectedIndex].isMTX == true;
      }
      
      private function GetIsZeus() : Boolean
      {
         return this.ModListObject.entryList.length > this.ModListObject.selectedIndex && this.ModListObject.selectedIndex >= 0 && this.ModListObject.entryList[this.ModListObject.selectedIndex].isZeus != undefined && this.ModListObject.entryList[this.ModListObject.selectedIndex].isZeus == true;
      }
      
      private function GetHasEntitlement() : *
      {
         return this.ModListObject.entryList.length > this.ModListObject.selectedIndex && this.ModListObject.selectedIndex >= 0 && this.ModListObject.entryList[this.ModListObject.selectedIndex].hasEntitlement != undefined && this.ModListObject.entryList[this.ModListObject.selectedIndex].hasEntitlement == true;
      }
      
      private function GetLooseModAvailable() : *
      {
         return this.ModListObject.entryList.length > this.ModListObject.selectedIndex && this.ModListObject.selectedIndex >= 0 && this.ModListObject.entryList[this.ModListObject.selectedIndex].hasLooseMod == true;
      }
      
      private function GetBuildable() : Boolean
      {
         return !this.GetModEquipped() && (this.GetLooseModAvailable() || Boolean(this.BGSCodeObj.CheckRequirements()));
      }
      
      private function SetButtonHintData() : void
      {
         if(this.externalPurchaseOpen)
         {
            this.ButtonHintBar_mc.SetButtonHintData(this.ExternalPurchaseButtons);
         }
         else
         {
            switch(this.eMode)
            {
               case this.INVENTORY_MODE:
                  if(this.modalActive)
                  {
                     this.ButtonHintBar_mc.SetButtonHintData(this.QuantityButtons);
                  }
                  else
                  {
                     this.ButtonHintBar_mc.SetButtonHintData(this.InventoryButtonHints);
                  }
                  break;
               case this.SLOTS_MODE:
                  this.ButtonHintBar_mc.SetButtonHintData(this.ModSlotButtonHints);
                  break;
               case this.MOD_MODE:
                  this.ButtonHintBar_mc.SetButtonHintData(this.ModsListHints);
                  break;
               case this.REQUIREMENTS_MODE:
                  this.ButtonHintBar_mc.SetButtonHintData(this.ComponentsListHints);
                  break;
               case this.LEVEL_SELECT_MODE:
                  this.ButtonHintBar_mc.SetButtonHintData(this.ItemLevelSelectButtons);
                  break;
               case this.ITEM_SELECT_MODE:
                  this.ButtonHintBar_mc.SetButtonHintData(this.MiscItemListHints);
                  break;
               case this.INSPECT_MODE:
                  this.ButtonHintBar_mc.SetButtonHintData(this.InspectModeButtons);
            }
         }
      }
      
      public function SetButtonVisibility(param1:int, param2:int) : void
      {
         if(param1 > 0)
         {
            this.TakeButtonVisiblity = true;
         }
         else if(param1 == 0)
         {
            this.TakeButtonVisiblity = false;
         }
         if(param2 > 0)
         {
            this.ExitButtonVisiblity = true;
         }
         else if(param2 == 0)
         {
            this.ExitButtonVisiblity = false;
         }
         this.TakeButton.ButtonVisible = this.TakeButtonVisiblity;
         this.ExitButton.ButtonVisible = this.ExitButtonVisiblity;
      }
      
      public function UpdateButtons() : void
      {
         var _loc2_:TextField = null;
         this.BackButton.ButtonText = this.eMode == this.SLOTS_MODE && this._isCookingMenu ? "$EXIT" : "$BACK";
         this.ToggleCraftingButton.ButtonVisible = !this.inspectMode && this.allowsModding && this.allowsCrafting;
         this.ToggleCraftingButton.ButtonText = this.isCrafting ? "$SWITCHTOMODIFY" : "$SWITCHTOCRAFT";
         this.FilterCraftableButton.ButtonVisible = true;
         this.FilterAtxButton.ButtonVisible = true;
         if(this.inspectMode)
         {
            this.Header_mc.HeaderText_tf.text = "$INSPECT";
         }
         else if(this.isCrafting)
         {
            this.Header_mc.HeaderText_tf.text = "$CRAFT";
         }
         else
         {
            this.Header_mc.HeaderText_tf.text = "$MODIFY";
         }
         var _loc1_:Object = this.InventoryBase_mc.InventoryList_mc.selectedEntry;
         if(this._improvedWorkbench.EnableRepairAll)
         {
            this.RepairKitButton.ButtonVisible = this.RepairKitsEnabled;
            _loc2_ = new TextField();
            _loc2_.text = "$REPAIR_KIT_NUM";
            this.RepairKitButton.ButtonText = _loc2_.text.replace("{1}",this._repairKitCount);
         }
         else if(this.RepairKitsEnabled)
         {
            this.RepairKitButton.ButtonVisible = this.BGSCodeObj.CanRepairSelectedItem(true);
            _loc2_ = new TextField();
            _loc2_.text = "$REPAIR_KIT_NUM";
            this.RepairKitButton.ButtonText = _loc2_.text.replace("{1}",this._repairKitCount);
         }
         else
         {
            this.RepairKitButton.ButtonVisible = false;
         }
         if(this._isWorkbench)
         {
            this.WorkbenchRepairButton.ButtonVisible = true;
            this.WorkbenchRepairButton.ButtonDisabled = !this.BGSCodeObj.CanRepairSelectedItem(false);
         }
         else
         {
            this.WorkbenchRepairButton.ButtonVisible = false;
         }
         switch(this.eMode)
         {
            case this.INVENTORY_MODE:
               if(!this.modalActive)
               {
                  this.ToggleEquipButton.ButtonEnabled = this._allowEquip;
                  if(this._allowEquip)
                  {
                     this.ToggleEquipButton.ButtonText = this.BGSCodeObj.IsSelectedItemEquipped() ? "$UNEQUIP" : "$EQUIP";
                  }
                  this.AlternateButton.ButtonVisible = this.strAlternateButtonText.length > 0;
                  this.AlternateButton.ButtonText = this.strAlternateButtonText;
                  this.AlternateButton.ButtonEnabled = this.AternateTextEnabled;
                  this.ModButton.ButtonEnabled = this.isCrafting || this.ModSlotListObject.entryList && this.ModSlotListObject.entryList.length > 0;
                  this.zel_RepairButton.ButtonVisible = this._improvedWorkbench.EnableQuickRepairButton && this._allowRepair;
                  if(this.zel_RepairButton.ButtonVisible)
                  {
                     if(this.BGSCodeObj.CanRepairSelectedItem(false))
                     {
                        this.zel_RepairButton.ButtonText = "$WORKBENCH REPAIR";
                     }
                     else if(this.RepairKitsEnabled)
                     {
                        this.zel_RepairButton.ButtonText = "$REPAIR KIT";
                     }
                  }
                  this.InspectRepairButton.ButtonVisible = this._allowRepair;
                  this.ScrapButton.ButtonVisible = this._showScrapButton;
                  this.ScrapButton.ButtonEnabled = Boolean(this.BGSCodeObj.CanScrapSelectedItem()) && _loc1_ != null && !(m_IsTransferLockingFeatureEnabled && _loc1_.isTransferLocked);
                  this.ToggleEquipButton.ButtonVisible = this._allowEquip;
                  this.LockButton.ButtonVisible = m_IsTransferLockingFeatureEnabled;
                  if(this.LockButton.ButtonVisible)
                  {
                     if(_loc1_ == null)
                     {
                        this.LockButton.ButtonDisabled = true;
                        this.LockButton.ButtonText = this.m_TransferLockText;
                     }
                     else
                     {
                        this.LockButton.ButtonDisabled = !_loc1_.canBeTransferLocked;
                        this.LockButton.ButtonText = _loc1_.isTransferLocked ? this.m_TransferUnlockText : this.m_TransferLockText;
                     }
                     this.LockButton.canHold = uiController != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE;
                  }
                  this.InspectRepairButton.ButtonVisible = this._allowRepair;
                  this.ToggleEquipButton.ButtonVisible = this._allowEquip;
               }
               break;
            case this.SLOTS_MODE:
               this.AlternateButton.ButtonVisible = this.strAlternateButtonText.length > 0;
               this.AlternateButton.ButtonText = this.strAlternateButtonText;
               this.AlternateButton.ButtonEnabled = this.AternateTextEnabled;
               this.ItemLevelAcceptButton.ButtonVisible = false;
               this.ItemLevelCancelButton.ButtonVisible = false;
               break;
            case this.MOD_MODE:
               this.AutoBuild.ButtonVisible = true;
               if(this.GetIsMTX() || this.GetIsZeus())
               {
                  this.AutoBuild.ButtonEnabled = !this.isWaitingForRefreshMTX;
                  if(this.GetLooseModAvailable())
                  {
                     this.AutoBuild.ButtonText = "$ATTACH MOD";
                  }
                  else if(this.GetHasEntitlement())
                  {
                     this.AutoBuild.ButtonText = "$BUILD";
                  }
                  else
                  {
                     this.AutoBuild.ButtonText = "$UNLOCK";
                  }
               }
               else
               {
                  this.AutoBuild.ButtonEnabled = this.GetBuildable();
                  this.AutoBuild.ButtonText = this.GetLooseModAvailable() ? "$ATTACH MOD" : "$BUILD";
               }
               this.TagButton.ButtonEnabled = this.BGSCodeObj.ShouldShowTagForSearchButton();
               this.AlternateButton.ButtonVisible = this.strAlternateButtonText.length > 0;
               this.AlternateButton.ButtonText = this.strAlternateButtonText;
               this.AlternateButton.ButtonEnabled = this.AternateTextEnabled;
               this.ItemLevelAcceptButton.ButtonVisible = false;
               this.ItemLevelCancelButton.ButtonVisible = false;
               break;
            case this.REQUIREMENTS_MODE:
               this.BGSCodeObj.SetItemSelectValuesForComponents(this.MiscItemListObject.entryList,this.MiscItemListObject.CategoryNameList);
               this.AutoBuild.ButtonEnabled = this.GetBuildable();
               this.AutoBuild.ButtonVisible = true;
               this.ChooseComponents.ButtonEnabled = !this.ModSlotBase_mc.ModSlotList_mc.filterer.IsFilterEmpty(this.ModSlotBase_mc.ModSlotList_mc.filterer.itemFilter);
               break;
            case this.LEVEL_SELECT_MODE:
               this.ItemLevelAcceptButton.ButtonVisible = true;
               this.ItemLevelCancelButton.ButtonVisible = true;
         }
         if(this.eMode == this.MOD_MODE)
         {
            _loc1_ = this.InventoryBase_mc.InventoryList_mc.selectedEntry;
         }
         if(this.isCrafting)
         {
            this._improvedWorkbench.updateInventoryCount();
         }
      }
      
      private function hasValidEntries() : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc1_:Boolean = false;
         if(this.InventoryBase_mc && this.InventoryBase_mc.InventoryList_mc && !this.InventoryBase_mc.InventoryList_mc.addedDummyEntryOnBlankList)
         {
            _loc2_ = int(this.InventoryBase_mc.InventoryList_mc.entryList.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if(this.InventoryBase_mc.InventoryList_mc.entryList[_loc3_] != null)
               {
                  _loc1_ = true;
                  break;
               }
               _loc3_++;
            }
         }
         return _loc1_;
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         if(this._improvedWorkbench)
         {
            this._improvedWorkbench.ProcessUserEvent(param1,param2);
         }
         if(param1 == "DISABLED")
         {
            return false;
         }
         var _loc3_:Boolean = false;
         if(!this.modalActive)
         {
            if(this.bEnteringText)
            {
               return true;
            }
            if(this.eMode == this.ITEM_SELECT_MODE)
            {
               stage.focus = this.ModSlotBase_mc.ModSlotList_mc;
            }
            else if(stage.focus != this.ModSlotBase_mc.ModSlotList_mc)
            {
               stage.focus = this.InventoryBase_mc.InventoryList_mc;
            }
         }
         else
         {
            _loc3_ = this.QuantityModal_mc.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_ && param2)
         {
            switch(param1)
            {
               case "TransferLockItem_Hold":
                  if(this.m_LockHoldStartTimeout == -1 && this.LockButton.ButtonVisible && this.LockButton.canHold && this.eMode != this.INSPECT_MODE)
                  {
                     this.m_LockHoldStartTimeout = setTimeout(this.startItemLockHold,GlobalFunc.HOLD_METER_DELAY);
                     _loc3_ = true;
                     break;
                  }
            }
         }
         if(!_loc3_ && !param2)
         {
            switch(param1)
            {
               case "Activate":
               case "Accept":
                  if(this.modalActive)
                  {
                     _loc3_ = true;
                  }
                  else if(this.TakeButtonVisiblity)
                  {
                     this.onTakeButton();
                     _loc3_ = true;
                  }
                  break;
               case "Left":
               case "StrafeLeft":
                  if(this.modalActive)
                  {
                     break;
                  }
                  if(this.eMode == this.INSPECT_MODE || this.eMode == this.INVENTORY_MODE || this.eMode == this.SLOTS_MODE && this._isCookingMenu)
                  {
                     _loc3_ = true;
                     break;
                  }
               case "Cancel":
                  if(this.ExitButtonVisiblity)
                  {
                     if(this.modalActive)
                     {
                        this.onQuantityCancel();
                     }
                     else
                     {
                        this.onBackButton();
                     }
                     _loc3_ = true;
                  }
                  break;
               case "StrafeRight":
               case "Right":
                  if(!this.modalActive)
                  {
                     this.onModButton();
                     _loc3_ = true;
                  }
                  break;
               case "L3":
                  if(!this.modalActive)
                  {
                     this.onFilterCraftable();
                     _loc3_ = true;
                  }
                  break;
               case "Select":
                  if(this.inspectMode)
                  {
                     this.onRename();
                     _loc3_ = true;
                  }
                  else if(!this.modalActive)
                  {
                     this.onFilterAtx();
                     _loc3_ = true;
                  }
                  break;
               case "RTrigger":
                  if(!this.modalActive)
                  {
                     this.onScrapBuildAdd();
                     _loc3_ = true;
                  }
                  break;
               case "LTrigger":
                  if(!this.modalActive)
                  {
                     this.onToggleEquip();
                     _loc3_ = true;
                  }
                  break;
               case "TransferLockItem_Press":
                  if(this.LockButton.ButtonVisible && this.LockButton.ButtonEnabled && this.eMode != this.INSPECT_MODE)
                  {
                     this.onLockButton();
                     _loc3_ = true;
                  }
                  break;
               case "TransferLockItem_Hold":
                  if(this.m_LockHolding)
                  {
                     this.m_LockHolding = false;
                     this.stopItemLockHold();
                     _loc3_ = true;
                  }
                  else if(this.m_LockHoldStartTimeout != -1)
                  {
                     this.stopItemLockHold();
                  }
               case "YButton":
                  if(!_loc3_ && !this.modalActive && this.InspectRepairButton.ButtonVisible && this.InspectRepairButton.ButtonEnabled)
                  {
                     if(this.eMode == this.INVENTORY_MODE)
                     {
                        if(this.InspectRepairButton.ButtonVisible)
                        {
                           this.onInspectRepair();
                        }
                        _loc3_ = true;
                     }
                     else if(this.eMode == this.INSPECT_MODE)
                     {
                        if(this.RepairKitButton.ButtonVisible)
                        {
                           this.onRepairKit();
                        }
                        _loc3_ = true;
                     }
                  }
                  break;
               case "R3":
                  if(this.zel_RepairButton.ButtonVisible && this.eMode == this.INVENTORY_MODE)
                  {
                     if(this.BGSCodeObj.CanRepairSelectedItem(false))
                     {
                        this.onWorkbenchRepair();
                     }
                     else if(this.RepairKitsEnabled)
                     {
                        this.onRepairKit();
                     }
                     _loc3_ = true;
                  }
                  else if(!this.inspectMode && !this.modalActive)
                  {
                     this.onSearch();
                     _loc3_ = true;
                  }
                  break;
               case "XButton":
                  if(!this.modalActive)
                  {
                     if(!this.inspectMode && this.allowsModding && this.allowsCrafting)
                     {
                        this.ToggleCrafting();
                        _loc3_ = true;
                     }
                     else if(this.inspectMode)
                     {
                        if(this.WorkbenchRepairButton.ButtonVisible)
                        {
                           this.onWorkbenchRepair();
                        }
                        _loc3_ = true;
                     }
                  }
                  break;
               case "RShoulder":
                  _loc3_ = true;
               case "Back":
                  if(this.eMode == this.INSPECT_MODE && !this._singleItemInspectMode && !this.modalActive)
                  {
                     BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_UPDATE_PIPBOY_INV_SELECTION,{"isNext":true}));
                     _loc3_ = true;
                  }
                  break;
               case "LShoulder":
                  _loc3_ = true;
               case "Forward":
                  if(this.eMode == this.INSPECT_MODE && !this._singleItemInspectMode && !this.modalActive)
                  {
                     BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_UPDATE_PIPBOY_INV_SELECTION,{"isNext":false}));
                     _loc3_ = true;
                  }
            }
            if(_loc3_)
            {
               this.UpdateDescription();
               this.UpdatePerks();
               this.UpdateBackground();
            }
         }
         else
         {
            switch(param1)
            {
               case "RShoulder":
               case "LShoulder":
                  _loc3_ = true;
            }
         }
         return _loc3_;
      }
      
      private function startItemLockHold() : void
      {
         this.m_LockHolding = true;
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(this.m_LockHolding)
         {
            this.LockButton.holdPercent += GlobalFunc.HOLD_METER_TICK_AMOUNT;
            if(this.LockButton.holdPercent >= 1)
            {
               this.onLockButton();
               this.stopItemLockHold();
            }
         }
      }
      
      private function stopItemLockHold() : *
      {
         if(this.m_LockHoldStartTimeout != -1)
         {
            clearTimeout(this.m_LockHoldStartTimeout);
            this.m_LockHoldStartTimeout = -1;
         }
         this.LockButton.holdPercent = 0;
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onMouseWheel(param1:MouseEvent) : *
      {
         if(this.eMode == this.INSPECT_MODE)
         {
            if(param1.delta < 0)
            {
               this.BGSCodeObj.ZoomOut();
            }
            else if(param1.delta > 0)
            {
               this.BGSCodeObj.ZoomIn();
            }
         }
      }
      
      private function onNextButton() : void
      {
         this.InventoryBase_mc.InventoryList_mc.moveSelectionDown();
         if(!this._itemNameManagedByCode)
         {
            this.itemName = this.InventoryBase_mc.InventoryList_mc.entryList[this.InventoryBase_mc.InventoryList_mc.selectedIndex].text;
         }
      }
      
      private function onPreviousButton() : void
      {
         this.InventoryBase_mc.InventoryList_mc.moveSelectionUp();
         if(!this._itemNameManagedByCode)
         {
            this.itemName = this.InventoryBase_mc.InventoryList_mc.entryList[this.InventoryBase_mc.InventoryList_mc.selectedIndex].text;
         }
      }
      
      private function onZoomInButton() : void
      {
         this.BGSCodeObj.ZoomIn();
      }
      
      private function onZoomOutButton() : void
      {
         this.BGSCodeObj.ZoomOut();
      }
      
      private function onSearch() : void
      {
         var _loc1_:Boolean = false;
         if(this.eMode == this.MOD_MODE)
         {
            if(this.BGSCodeObj.ToggleFavoriteMod())
            {
               this.BGSCodeObj.PlaySound("UIMenuPrevNext");
               _loc1_ = Boolean(this.ModListObject.entryList[this.ModListObject.selectedIndex].modTaggedForSearch);
               this.ModListObject.entryList[this.ModListObject.selectedIndex].modTaggedForSearch = _loc1_ ? false : true;
               this.ModListObject.RefreshList();
               this.UpdateButtons();
            }
         }
      }
      
      private function onRepairKit() : void
      {
         if(this.BGSCodeObj.OnRepairKit != null)
         {
            this.BGSCodeObj.OnRepairKit();
         }
      }
      
      private function onWorkbenchRepair() : void
      {
         if(this._allowRepair)
         {
            this.BGSCodeObj.RepairSelectedItem();
         }
      }
      
      private function onInspectRepair() : void
      {
         if(this.eMode == this.INVENTORY_MODE)
         {
            this.BGSCodeObj.InspectSelectedItem();
         }
      }
      
      private function onLockButton() : void
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(EVENT_LOCK_ITEM,{"serverHandleID":this.InventoryListObject.selectedEntry.serverHandleID}));
         GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_OK);
      }
      
      private function onRename() : void
      {
         if(this.allowClearName)
         {
            this.BGSCodeObj.ClearName();
         }
         else if(this.eMode == this.INSPECT_MODE && this.allowRename && !this.enteringText)
         {
            this.enteringText = !this.enteringText;
         }
      }
      
      private function onFilterCraftable() : void
      {
         if(this._inspectMode || this.QuantityModal_mc.opened)
         {
            return;
         }
         this.BGSCodeObj.ToggleCraftable();
         this.filterCommon();
      }
      
      public function onFilterAtx() : void
      {
         if(this._inspectMode || this.QuantityModal_mc.opened)
         {
            return;
         }
         this.BGSCodeObj.ToggleAtx();
         this.filterCommon();
         this._improvedWorkbench.initUI();
      }
      
      private function filterCommon() : void
      {
         var _loc2_:Array = null;
         var _loc1_:Boolean = false;
         switch(this.eMode)
         {
            case this.INVENTORY_MODE:
            case this.SLOTS_MODE:
               _loc1_ = !this.isCrafting && this.ModListObject.hasValidIndex();
               break;
            case this.MOD_MODE:
               _loc1_ = this.ModListObject.hasValidIndex();
               break;
            case this.LEVEL_SELECT_MODE:
               _loc1_ = this.ModListObject.selectedIndex >= 0 && Boolean(this.ModListObject.entryList[this.ModListObject.selectedIndex].hasRequired);
         }
         if(!_loc1_)
         {
            this.InventoryBase_mc.InventoryList_mc.selectedIndex = 0;
            if(this.isCrafting)
            {
               this.EnterCrafting();
            }
            else
            {
               this.EnterModding();
            }
         }
         else
         {
            _loc2_ = new Array();
            this.BGSCodeObj.SwitchMod(this.ModListObject.selectedIndex,_loc2_);
         }
      }
      
      private function onToggleEquip() : void
      {
         if(this._allowEquip)
         {
            this.BGSCodeObj.ToggleItemEquipped();
         }
      }
      
      private function onScrapClickDisabled() : void
      {
         if(this.InventoryListObject.selectedEntry.isTransferLocked)
         {
            GlobalFunc.ShowHUDMessage("$CannotScrapLockedItem");
            GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_CANCEL);
         }
      }
      
      private function onScrapBuildAdd() : void
      {
         var _loc1_:* = undefined;
         if(this._isModeInitialized)
         {
            if(this.strAlternateButtonText)
            {
               this.onAlternateButton();
            }
            else if(this.QuantityModal_mc.opened)
            {
               this.onQuantityAccept();
            }
            else
            {
               switch(this.eMode)
               {
                  case this.INVENTORY_MODE:
                     _loc1_ = this.InventoryListObject.selectedEntry;
                     if(_loc1_ != null)
                     {
                        if(_loc1_.isTransferLocked)
                        {
                           GlobalFunc.ShowHUDMessage("$CannotScrapLockedItem");
                           GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_CANCEL);
                        }
                        else if(_loc1_.count > this.SCRAP_ITEM_COUNT_THRESHOLD)
                        {
                           this.openQuantityModal();
                        }
                        else
                        {
                           this.BGSCodeObj.ScrapItem(this._ScrapQuantity);
                        }
                     }
                     break;
                  case this.MOD_MODE:
                  case this.REQUIREMENTS_MODE:
                     if(this.eMode != this.MOD_MODE && !this.GetModEquipped())
                     {
                        this.BGSCodeObj.OnBuildFailed();
                     }
                     else
                     {
                        this.BGSCodeObj.PlaySound("UIMenuCancel");
                     }
                     break;
                  case this.ITEM_SELECT_MODE:
                     if(this.MiscItemListObject.selectedIndex >= 0)
                     {
                        this.BGSCodeObj.ItemSelect(this.MiscItemListObject.entryList,uint(this.MiscItemListObject.selectedIndex),this.MiscItemListObject.CategoryNameList,uint(Math.log(this.MiscItemListObject.filterer.itemFilter) / Math.log(2)),this.MiscItemListObject.filterer.itemFilter);
                        this.RequirementsListObject.RefreshList();
                     }
               }
            }
         }
      }
      
      private function openQuantityModal() : *
      {
         var _loc2_:uint = 0;
         var _loc1_:* = null;
         var amount:* = 1;
         if(this.eMode == this.INVENTORY_MODE)
         {
            _loc1_ = this.InventoryListObject.selectedEntry;
         }
         if((this.isCrafting || this.eMode == this.LEVEL_SELECT_MODE) && this.RequirementsListObject.craftableQuantity > 0)
         {
            this.QuantityModal_mc.tooltip = "";
            _loc2_ = GlobalFunc.Clamp(this.RequirementsListObject.craftableQuantity,1,this.MAX_CRAFTABLE);
            amount = GlobalFunc.Clamp(this._improvedWorkbench.DefaultCraftAmount,1,_loc2_);
            this.QuantityModal_mc.OpenMenuRange(stage.focus,"$SETQUANTITY",1,_loc2_,amount,0,true);
            stage.focus = this.QuantityModal_mc;
            GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_POPUP);
            this.updateModalActive();
            this.UpdateButtons();
         }
         else if(_loc1_ != null)
         {
            this.QuantityModal_mc.tooltip = "";
            amount = Math.min(this._improvedWorkbench.DefaultCraftAmount,_loc1_.count);
            this.QuantityModal_mc.OpenMenuRange(stage.focus,"$SETQUANTITY",1,_loc1_.count,amount,0,true);
            stage.focus = this.QuantityModal_mc;
            GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_POPUP);
            this.updateModalActive();
            this.UpdateButtons();
         }
      }
      
      private function closeQuantityModal() : *
      {
         stage.focus = this.QuantityModal_mc.prevFocus;
         this.QuantityModal_mc.CloseMenu(true);
         this.updateModalActive();
         this.UpdateButtons();
         this._ScrapQuantity = 1;
      }
      
      private function onQuantityAccept() : *
      {
         var _loc1_:* = undefined;
         if(this.QuantityModal_mc.inTextInputMode)
         {
            this.QuantityModal_mc.updateQuantityInput();
         }
         else
         {
            if(this.eMode == this.INVENTORY_MODE)
            {
               _loc1_ = this.InventoryListObject.selectedEntry;
               if(_loc1_ != null)
               {
                  this._ScrapQuantity = Math.min(_loc1_.count,this.QuantityModal_mc.quantity);
                  this.BGSCodeObj.ScrapItem(this._ScrapQuantity);
               }
            }
            else if(this.isCrafting)
            {
               this.m_SelectedModListEntryIndex = this._eMode == this.LEVEL_SELECT_MODE ? this.ItemLevelListObject.selectedIndex : this.ModListObject.selectedIndex;
               this.m_RestoreSelectedIndex = true;
               this.BGSCodeObj.StartBuildConfirm(this.QuantityModal_mc.quantity);
            }
            this._wasModalJustConfirmed = true;
            this.closeQuantityModal();
         }
      }
      
      private function onQuantityCancel() : *
      {
         if(this.QuantityModal_mc.inTextInputMode)
         {
            this.QuantityModal_mc.CancelTextInput();
         }
         else
         {
            this.m_RestoreSelectedIndex = false;
            this.closeQuantityModal();
         }
      }
      
      private function onAlternateButton() : void
      {
         this.BGSCodeObj.OnAlternateButton();
      }
      
      private function onModButton() : void
      {
         var _loc2_:Boolean = false;
         this.m_RestoreSelectedIndex = false;
         var _loc1_:Object = null;
         if(this.QuantityModal_mc.opened)
         {
            this.onQuantityAccept();
         }
         else
         {
            switch(this.eMode)
            {
               case this.INVENTORY_MODE:
                  if(!this.enteringText)
                  {
                     if(this.InventoryModeToSlotsMode())
                     {
                        this.PushCraftingHierarchy("$$MOD_SLOTS");
                     }
                  }
                  else
                  {
                     this.enteringText = false;
                  }
                  break;
               case this.SLOTS_MODE:
                  if(this.ModSlotListObject.selectedEntry.enabled)
                  {
                     this.ModSlotListObject.SetInactive();
                     this.RequirementsListObject.SetActive(this.ModSlotBase_mc.ModSlotList_mc,"RequirementsListObject");
                     this.ModListObject.SetActive(this.InventoryBase_mc.InventoryList_mc,"ModListObject");
                     this.ModListObject.filtersDuplicates = false;
                     this.SetRightListLabel("$REQUIRES");
                     this.ModListObject.addEventListener(BSScrollingList.SELECTION_CHANGE,this.ModChange);
                     this.InventoryBase_mc.InventoryList_mc.selectedIndex = -1;
                     this.InventoryBase_mc.InventoryList_mc.moveSelectionDown();
                     this.eMode = this.MOD_MODE;
                     this.BGSCodeObj.PlaySound("UIMenuOK");
                     if(this.m_IsCrafting)
                     {
                        _loc1_ = this.ModSlotListObject.entryList[this.ModSlotListObject.selectedIndex];
                     }
                     else
                     {
                        this.PushCraftingHierarchy("$$MODS");
                     }
                  }
                  if(this._isCookingMenu)
                  {
                     this.onModChange();
                  }
                  break;
               case this.MOD_MODE:
                  if(!this.GetModEquipped())
                  {
                     this.m_RestoreSelectedIndex = true;
                     this.m_SelectedModListEntryIndex = this.ModListObject.selectedIndex;
                     if(this.ModListObject.entryList[this.ModListObject.selectedIndex].hasLooseMod)
                     {
                        this.BGSCodeObj.StartLooseModBuildConfirm();
                     }
                     else if(!this._itemLevelData.hasLevels && this.isCrafting)
                     {
                        _loc2_ = Boolean(this.GetIsMTX() || this.GetIsZeus() ? this.GetHasEntitlement() : true);
                        if(this.RequirementsListObject.craftableQuantity > 1 && _loc2_)
                        {
                           this.openQuantityModal();
                        }
                        else
                        {
                           this.BGSCodeObj.StartBuildConfirm();
                        }
                     }
                     else if(!this._itemLevelData.hasLevels && !this.isCrafting)
                     {
                        this.BGSCodeObj.StartBuildConfirm();
                     }
                     else
                     {
                        this.eMode = this.LEVEL_SELECT_MODE;
                        this.ModListObject.SetInactive();
                        this.ItemLevelListObject.SetActive(this.InventoryBase_mc.InventoryList_mc,"ItemLevelListObject");
                        this.LevelChange(new Event(""));
                        _loc1_ = this.ModListObject.entryList[this.ModListObject.selectedIndex];
                     }
                     this.BGSCodeObj.PlaySound("UIMenuOK");
                  }
                  break;
               case this.REQUIREMENTS_MODE:
                  if(this.ChooseComponents.ButtonEnabled)
                  {
                     stage.focus = this.ModSlotBase_mc.ModSlotList_mc;
                     this.ModSlotBase_mc.ModSlotList_mc.selectedIndex = this.ModSlotBase_mc.ModSlotList_mc.filterer.ClampIndex(-1);
                     this.ModSlotBase_mc.ModSlotList_mc.InvalidateData();
                     this.eMode = this.ITEM_SELECT_MODE;
                     this.BGSCodeObj.SetItemSelectValuesForComponents(this.MiscItemListObject.entryList,this.MiscItemListObject.CategoryNameList);
                     this.BGSCodeObj.PlaySound("UIMenuOK");
                  }
                  else
                  {
                     this.BGSCodeObj.PlaySound("UIMenuCancel");
                  }
                  break;
               case this.ITEM_SELECT_MODE:
                  break;
               case this.LEVEL_SELECT_MODE:
                  if(this.RequirementsListObject.craftableQuantity > 1)
                  {
                     this.openQuantityModal();
                  }
                  else
                  {
                     this.BGSCodeObj.StartBuildConfirm();
                  }
            }
         }
         if(_loc1_ != null)
         {
            this.PushCraftingHierarchy(_loc1_.text);
         }
         this.UpdateDescription();
         this.UpdatePerks();
         this.UpdateBackground();
         this.BGSCodeObj.SendTutorialEvent(this.eMode);
      }
      
      private function onTakeButton() : void
      {
         this.BGSCodeObj.TakeItem();
         this.BGSCodeObj.HideMenu();
      }
      
      public function ModModeToInvMode() : void
      {
         this.ModModeToSlotsMode();
         this.PopCraftingHierarchy();
         this.ModListObject.SetInactive();
         this.ModSlotListObject.SetActive(this.ModSlotBase_mc.ModSlotList_mc,"ModSlotListObject");
         this.InventoryListObject.SetActive(this.InventoryBase_mc.InventoryList_mc,"InventoryListObject");
         this.InventoryListObject.selectedIndex = 0;
         this.ModListObject.removeEventListener(BSScrollingList.SELECTION_CHANGE,this.ModChange);
         this.SetRightListLabel("$CURRENT MODS");
         this.eMode = this.INVENTORY_MODE;
         this.BGSCodeObj.PlaySound("UIMenuCancel");
         this.BGSCodeObj.RemoveHighlight();
         this.PopCraftingHierarchy();
      }
      
      public function onBackButton() : void
      {
         if(this.QuantityModal_mc.opened)
         {
            this.onQuantityCancel();
         }
         else
         {
            switch(this.eMode)
            {
               case this.INVENTORY_MODE:
               case this.INSPECT_MODE:
                  if(!this._featuredItemMode)
                  {
                     this.BGSCodeObj.HideMenu();
                     this.BGSCodeObj.PlaySound("UIMenuCancel");
                  }
                  break;
               case this.SLOTS_MODE:
                  if(!this._isCookingMenu)
                  {
                     this.ModListObject.SetInactive();
                     this.ModSlotListObject.SetActive(this.ModSlotBase_mc.ModSlotList_mc,"ModSlotListObject");
                     this.InventoryListObject.SetActive(this.InventoryBase_mc.InventoryList_mc,"InventoryListObject");
                     this.InventoryListObject.selectedIndex = 0;
                     this.ModListObject.removeEventListener(BSScrollingList.SELECTION_CHANGE,this.ModChange);
                     this.SetRightListLabel("$CURRENT MODS");
                     this.eMode = this.INVENTORY_MODE;
                     this.BGSCodeObj.PlaySound("UIMenuCancel");
                     this.BGSCodeObj.RemoveHighlight();
                     this.BGSCodeObj.UpdateItemList();
                     this.PopCraftingHierarchy();
                  }
                  else
                  {
                     this.BGSCodeObj.HideMenu();
                  }
                  break;
               case this.MOD_MODE:
                  this.ModModeToSlotsMode();
                  this.PopCraftingHierarchy();
                  this.BGSCodeObj.PlaySound("UIMenuCancel");
                  break;
               case this.REQUIREMENTS_MODE:
                  this.MiscItemListObject.SetInactive();
                  this.ModListObject.filtersDuplicates = false;
                  this.ModListObject.SetActive(this.InventoryBase_mc.InventoryList_mc,"ModListObject");
                  this.RequirementsListObject.SetActive(this.ModSlotBase_mc.ModSlotList_mc,"RequirementsListObject");
                  this.SetRightListLabel("$REQUIRES");
                  this.ModListObject.addEventListener(BSScrollingList.SELECTION_CHANGE,this.ModChange);
                  this.eMode = this.MOD_MODE;
                  this.PopCraftingHierarchy();
                  this.BGSCodeObj.PlaySound("UIMenuCancel");
                  break;
               case this.ITEM_SELECT_MODE:
                  stage.focus = this.InventoryBase_mc.InventoryList_mc;
                  this.RequirementsListObject.selectedIndex = -1;
                  this.InventoryBase_mc.InventoryList_mc.moveSelectionDown();
                  this.MiscItemListObject.selectedIndex = -1;
                  this.SetRightListLabel("$ITEMS");
                  this.eMode = this.REQUIREMENTS_MODE;
                  this.BGSCodeObj.PlaySound("UIMenuCancel");
                  break;
               case this.LEVEL_SELECT_MODE:
                  this.ItemLevelListObject.selectedIndex = 0;
                  this.LevelChange(new Event(""));
                  this.ItemLevelListObject.SetInactive();
                  this.ModListObject.filtersDuplicates = false;
                  this.ModListObject.SetActive(this.InventoryBase_mc.InventoryList_mc,"ModListObject");
                  this.eMode = this.MOD_MODE;
                  this.PopCraftingHierarchy();
                  this.BGSCodeObj.PlaySound("UIMenuCancel");
            }
         }
      }
      
      public function onRightThumbstickInput(param1:uint) : *
      {
         if(param1 == 1)
         {
            --this.ModSlotBase_mc.ModSlotList_mc.scrollPosition;
         }
         else if(param1 == 3)
         {
            this.ModSlotBase_mc.ModSlotList_mc.scrollPosition += 1;
         }
      }
      
      public function set enteringText(param1:Boolean) : *
      {
         var _loc3_:BSButtonHintData = null;
         this.bEnteringText = param1;
         if(this.bEnteringText)
         {
            this.PrevBtnVisibility = new Array();
         }
         var _loc2_:int = 0;
         for each(_loc3_ in this.InspectModeButtons)
         {
            if(this.bEnteringText)
            {
               this.PrevBtnVisibility.push(_loc3_.ButtonVisible);
               _loc3_.ButtonVisible = false;
            }
            else
            {
               _loc3_.ButtonVisible = this.PrevBtnVisibility[_loc2_];
               _loc2_++;
            }
         }
         if(!this.bEnteringText)
         {
            this.TakeButton.ButtonVisible = this.TakeButtonVisiblity;
            this.ExitButton.ButtonVisible = this.ExitButtonVisiblity;
            this.RenameButton.ButtonVisible = this._allowRename;
            this.PrevButton.ButtonVisible = this.NextButton.ButtonVisible = !this._singleItemInspectMode;
         }
         if(this.bEnteringText)
         {
            this.BGSCodeObj.SetName();
         }
         else if(this.eMode == this.ITEM_SELECT_MODE)
         {
            stage.focus = this.ModSlotBase_mc.ModSlotList_mc;
         }
         else if(stage.focus != this.ModSlotBase_mc.ModSlotList_mc)
         {
            stage.focus = this.InventoryBase_mc.InventoryList_mc;
         }
      }
      
      public function get enteringText() : *
      {
         return this.bEnteringText;
      }
      
      public function GetCurrentModSelected() : Boolean
      {
         return this.ModListObject.entryList.length > 0 ? this.ModListObject.entryList[this.ModListObject.selectedIndex].currentMod == true : false;
      }
      
      public function GetCurrentModAttachable() : Boolean
      {
         return this.ModListObject.entryList.length > this.ModListObject.selectedIndex && this.ModListObject.selectedIndex >= 0 ? this.ModListObject.entryList[this.ModListObject.selectedIndex].hasLooseMod == true : false;
      }
      
      public function UpdateDescription() : *
      {
         var _loc1_:String = "";
         if(this.inspectMode || this.eMode == this.INVENTORY_MODE)
         {
            _loc1_ = this.BGSCodeObj.GetItemDescription();
         }
         else if(this.eMode == this.MOD_MODE || this.eMode == this.LEVEL_SELECT_MODE || this.eMode == this.REQUIREMENTS_MODE)
         {
            if(this.isCrafting)
            {
               _loc1_ = this.BGSCodeObj.GetItemDescription();
            }
            else if(this.InventoryBase_mc.InventoryList_mc.selectedIndex < this.InventoryBase_mc.InventoryList_mc.entryList.length && this.InventoryBase_mc.InventoryList_mc.entryList[this.InventoryBase_mc.InventoryList_mc.selectedIndex] && this.InventoryBase_mc.InventoryList_mc.entryList[this.InventoryBase_mc.InventoryList_mc.selectedIndex].description != undefined)
            {
               _loc1_ = this.InventoryBase_mc.InventoryList_mc.entryList[this.InventoryBase_mc.InventoryList_mc.selectedIndex].description;
            }
         }
         else if(this.eMode == this.SLOTS_MODE && this.ModSlotListObject.selectedEntry && !this.ModSlotListObject.selectedEntry.enabled)
         {
            _loc1_ = this.ModSlotListObject.selectedEntry.tooltip;
         }
         this.itemDescription = _loc1_;
      }
      
      public function startItemSelection() : *
      {
         this.BGSCodeObj.StartItemSelection();
      }
      
      public function RefreshItemCard(param1:Object = null) : *
      {
         this.ItemCardList_mc.onDataChange();
      }
      
      public function OnItemCardUpdated(param1:Event) : *
      {
         var _loc2_:uint = this.ItemCardContainer_mc.ItemCardList_mc.entryCount - 1;
         this.ItemCardContainer_mc.Background_mc.Box_mc.height = this.ITEM_CARD_START_HEIGHT + this.ITEM_CARD_ENTRY_HEIGHT * _loc2_;
         this.ItemCardContainer_mc.Background_mc.Box_mc.y = this.ITEM_CARD_START_Y - this.ITEM_CARD_ENTRY_HEIGHT * _loc2_;
         this.ItemCardContainer_mc.Background_mc.itemStatsLabel_tf.y = this.ITEM_CARD_LABEL_START_Y - (this.ITEM_CARD_ENTRY_HEIGHT - 1) * _loc2_;
         this.ItemCardContainer_mc.Background_mc.StatsLabelBG_mc.y = this.ITEM_CARD_LABEL_START_Y - (this.ITEM_CARD_ENTRY_HEIGHT - 1) * _loc2_ - 1;
      }
      
      public function set itemDescription(param1:String) : *
      {
         var _loc2_:* = undefined;
         if(this.m_DynamicModDescEnabled && this.ModListObject.selectedEntry && Boolean(this.ModListObject.selectedEntry.modProperties))
         {
            this.ModDescriptionBase_mc.gotoAndStop("dynamic");
            this.ModDescriptionBase_mc.DynamicModDescription_mc.entryData = this.ModListObject.selectedEntry.modProperties;
         }
         else
         {
            this.ModDescriptionBase_mc.gotoAndStop("default");
            GlobalFunc.SetText(this.ModDescriptionBase_mc.ModDescription_tf,param1,false);
            ShrinkFontToFit(this.ModDescriptionBase_mc.ModDescription_tf,1);
            _loc2_ = param1 == "" ? 0 : this.ModDescriptionBase_mc.ModDescription_tf.numLines;
         }
      }
      
      private function onDynamicModDescriptionUpdated(param1:Event) : void
      {
         this.ModDescriptionBase_mc.DynamicModDescription_mc.Body_mc.x = (this.ModDescriptionBase_mc.DynamicModDescription_mc.Body_mc.width - this.ModDescriptionBase_mc.DynamicModDescription_mc.displayWidth) / 2;
      }
      
      public function set legendaryItemDescription(param1:String) : *
      {
         var _loc2_:String = param1;
         while(_loc2_.indexOf("%%") != -1)
         {
            _loc2_ = _loc2_.replace("%%","%");
         }
         while(_loc2_.indexOf("\r\n") != -1)
         {
            _loc2_ = _loc2_.replace("\r\n","\n");
         }
         GlobalFunc.SetText(this.LegendaryItemDescription_tf,_loc2_,true);
      }
      
      public function RepositionCurrentModsList() : *
      {
         if(this.CurrentModsListObject.entryList.length)
         {
            this.CurrentModsBase_mc.visible = true;
            this.ModSlotBase_mc.SlotsLabel_tf.visible = false;
         }
         else
         {
            this.CurrentModsBase_mc.visible = false;
            this.ModSlotBase_mc.SlotsLabel_tf.visible = true;
         }
      }
      
      public function SetCraftingHierarchy(param1:String) : *
      {
         this._craftingHierarchy.splice(0);
         this.PushCraftingHierarchy(param1);
      }
      
      public function PushCraftingHierarchy(param1:String) : *
      {
         this._craftingHierarchy.push(param1);
         this.UpdateCraftingHierarchy();
      }
      
      public function PopCraftingHierarchy() : *
      {
         if(this._craftingHierarchy.length > 1)
         {
            this._craftingHierarchy.splice(this._craftingHierarchy.length - 1);
            this.UpdateCraftingHierarchy();
         }
      }
      
      private function UpdateCraftingHierarchy() : *
      {
         var _loc3_:* = undefined;
         var _loc1_:Number = this._craftingHierarchy.length;
         var _loc2_:* = "";
         if(_loc1_ == 1)
         {
            _loc2_ = this._craftingHierarchy[0];
         }
         else
         {
            _loc3_ = 1;
            while(_loc3_ < _loc1_)
            {
               if(_loc3_ > 1)
               {
                  _loc2_ += " > ";
               }
               _loc2_ += this._craftingHierarchy[_loc3_];
               _loc3_++;
            }
         }
         this.CraftingHeirarchy_mc.CraftingHeirarchy_tf.text = _loc2_.toUpperCase();
         if(this.isCrafting)
         {
            this._improvedWorkbench.updateInventoryCount();
         }
      }
      
      internal function frame12() : *
      {
         stop();
      }
      
      internal function frame18() : *
      {
         stop();
      }
      
      internal function frame25() : *
      {
         stop();
      }
      
      internal function frame38() : *
      {
         stop();
      }
   }
}

