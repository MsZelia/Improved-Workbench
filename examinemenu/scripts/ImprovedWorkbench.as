package
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.QuantityMenu;
   import Shared.GlobalFunc;
   import com.adobe.serialization.json.*;
   import com.brokenfunction.json.JsonDecoderAsync;
   import flash.events.*;
   import flash.filters.*;
   import flash.net.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   
   public class ImprovedWorkbench
   {
      
      public static var Debug:Boolean = false;
      
      public static var DEBUG_SELECTION:Boolean = false;
      
      private static const MAX_CRAFTABLE:uint = 255;
      
      public static const VERSION:String = "1.7.4";
      
      public static const MOD_NAME:String = "ImprovedWorkbench";
      
      public static const CONFIG_FILE_LOCATION:String = "../ImprovedWorkbenchConfig.json";
      
      public static var LEGENDARY_LOAD_FILE_LOCATION:String = "../LegendaryMods.ini";
      
      public static const LEGENDARY_MOD_LOCALIZED:Array = ["LEGENDARY MOD","MOD LÉGENDAIRE","MÓDULO LEGENDARIO","LEGENDÄRE","MODIFICA LEGGENDARIA","LEGENDARNA MODYFIKACJA","MOD LENDÁRIO","ЛЕГЕНДАРНЫЙ МОДУЛЬ","Легендарный модуль","レジェンダリーモジュール","전설적인 개조","传奇改装件","傳奇改造配件"];
      
      public static const LEGENDARY_MOD_CURRENTLY_REGEX:* = /(Currently|Aktuell|Actualmente|Valeur actuelle|Attuale|現在|현재|Obecnie|Atualmente|Сейчас|当前效果为|目前為).*$/;
      
      public static const LEGENDARY_MOD_ARMOR_REGEX:* = /(ARMOR|Rüstung|Armadura|Armure|Armatura|アーマー|방어구|Pancerz|Броня|装甲|裝甲)/i;
      
      public static const LEGENDARY_MOD_POWER_ARMOR_REGEX:* = /(POWER ARMOR|Motorisierte Rüstung|Servoarmadura|Armure assistée|Corazza atomica|パワーアーマー|파워 아머|Pancerz wspomagany|Силовая броня|动力装甲|動力裝甲)/i;
      
      public static const LEGENDARY_MOD_WEAPONS_REGEX:* = /(WEAPONS|Waffen|Armas|Armes|Armi|武器|무기|UZBROJENIE|BROŃ BIAŁA|Оружие|ОРУЖИЕ)/i;
      
      public static const LEGENDARY_MOD_RAPID_REGEX:* = /(Rapid|Rapidité|Veloz|Schnell|Rapido|Dynamiczny|Стремительное|迅速な|재빠른|速射)/i;
      
      private var _config:Object = null;
      
      private var _examineMenu:Object = null;
      
      private var _legendaryModsFromIni:Object = null;
      
      public var EnableRepairAll:Boolean = true;
      
      public var ShowDurability:Boolean = true;
      
      public var ImprovedQuantityMenu:Boolean = true;
      
      public var EnableQuickRepairButton:Boolean = true;
      
      public var DefaultCraftAmount:uint = 1;
      
      public var ShowInventoryItemCount:Boolean = true;
      
      private var hasScannedLegendaryMods:* = false;
      
      private var legendaryModKeepList:* = [];
      
      private var legendaryModBlockList:* = [];
      
      private var timer:Timer;
      
      private var isUIinit:Boolean = false;
      
      private var inventoryCounts:* = {};
      
      private var ExamineMenuMode:String = "";
      
      private var PerksUIData:*;
      
      private var LegendaryPerksMenuData:*;
      
      private var perkCards_tf:TextField;
      
      private var perkCardsData:* = {};
      
      private var usedRepairKit:Boolean = false;
      
      private var CustomWorkbenchRepairHotkey:int = 0;
      
      private var CustomRepairKitRepairHotkey:int = 0;
      
      public function ImprovedWorkbench(examineMenu:Object)
      {
         super();
         this._examineMenu = examineMenu;
         loadConfig();
         this.PerksUIData = BSUIDataManager.GetDataFromClient("PerksUIData").data;
         this.LegendaryPerksMenuData = BSUIDataManager.GetDataFromClient("LegendaryPerksMenuData").data;
         BSUIDataManager.Subscribe("PerksUIData",initPerkCardsConfig);
         BSUIDataManager.Subscribe("LegendaryPerksMenuData",initPerkCardsConfig);
         this._examineMenu.stage.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
      }
      
      public static function ShowMessage(param1:String) : void
      {
         GlobalFunc.ShowHUDMessage("[" + MOD_NAME + " v" + VERSION + "] " + param1);
      }
      
      public static function toString(param1:Object) : String
      {
         return new JSONEncoder(param1).getString();
      }
      
      public static function getApiData(param1:String) : Object
      {
         try
         {
            return BSUIDataManager.GetDataFromClient(param1).data;
         }
         catch(e:Error)
         {
         }
         return {"message":"Error extracting data for " + param1};
      }
      
      private static function parseNumber(obj:Object, defaultValue:Object = 0) : Number
      {
         if(obj != null)
         {
            var value:* = Number(obj);
            if(!isNaN(value))
            {
               return value;
            }
         }
         return defaultValue;
      }
      
      private static function indexOfCaseInsensitiveString(arr:Array, searchingIn:String, fromIndex:uint = 0) : int
      {
         var uppercaseSearchString:String = searchingIn.toUpperCase();
         var arrayLength:uint = arr.length;
         var index:uint = fromIndex;
         while(index < arrayLength)
         {
            var element:* = arr[index];
            if(element is String && uppercaseSearchString.indexOf(element.toUpperCase()) != -1)
            {
               return index;
            }
            index++;
         }
         return -1;
      }
      
      private static function countInString(str:String, char:String) : int
      {
         var count:int = 0;
         var i:int = str.length - 1;
         while(i >= 0)
         {
            if(str.charAt(i) == char)
            {
               count++;
            }
            i--;
         }
         return count;
      }
      
      private static function replaceInString(str:String, oldStr:String, newStr:String) : String
      {
         return str.split(oldStr).join(newStr);
      }
      
      private static function trimString(str:String) : String
      {
         var len:int = str.length;
         if(len == 0)
         {
            return str;
         }
         var first:int = 0;
         var last:int = len - 1;
         while(first < len && str.charAt(first) == " ")
         {
            first++;
         }
         if(first == last)
         {
            return str;
         }
         while(last >= 0 && str.charAt(last) == " ")
         {
            last--;
         }
         return str.substring(first,last + 1);
      }
      
      public function get Config() : *
      {
         return this._config;
      }
      
      public function keyUpHandler(event:Event) : void
      {
         if(event.keyCode == CustomRepairKitRepairHotkey)
         {
            if(_examineMenu.BGSCodeObj.OnRepairKit != null)
            {
               _examineMenu.BGSCodeObj.OnRepairKit();
               _examineMenu.displayError("RepairKitRepair hotkey");
            }
         }
         if(event.keyCode == CustomWorkbenchRepairHotkey)
         {
            this._examineMenu.BGSCodeObj.RepairSelectedItem();
            _examineMenu.displayError("WorkbenchRepair hotkey");
         }
      }
      
      private function loadConfig() : void
      {
         var loaderComplete:Function;
         var url:URLRequest = null;
         var loader:URLLoader = null;
         try
         {
            loaderComplete = function(param1:Event):void
            {
               var _loc2_:Object = new JSONDecoder(loader.data,true).getValue();
               _config = _loc2_;
               ShowDurability = Boolean(_config.showDurabilityValue);
               EnableRepairAll = Boolean(_config.enableExamineRepairAll);
               EnableQuickRepairButton = Boolean(_config.enableQuickRepairButton);
               ImprovedQuantityMenu = Boolean(_config.enableImprovedQuantityMenu);
               ShowInventoryItemCount = Boolean(_config.showInventoryItemCount);
               Debug = Boolean(_config.debug);
               DEBUG_SELECTION = Boolean(_config.debugSelection);
               if(_config.defaultCraftAmount && !isNaN(_config.defaultCraftAmount))
               {
                  DefaultCraftAmount = GlobalFunc.Clamp(uint(_config.defaultCraftAmount),1,MAX_CRAFTABLE);
               }
               initPerkCardsConfig(null);
               if(_config.customRepairKitRepairHotkey && !isNaN(_config.customRepairKitRepairHotkey))
               {
                  CustomRepairKitRepairHotkey = int(_config.customRepairKitRepairHotkey);
               }
               if(_config.customWorkbenchRepairHotkey && !isNaN(_config.customWorkbenchRepairHotkey))
               {
                  CustomWorkbenchRepairHotkey = int(_config.customWorkbenchRepairHotkey);
               }
               _examineMenu.displayError(MOD_NAME + " " + VERSION + " Config file loaded");
               init();
               _examineMenu.displayError("Initialized");
               if(!_config.hideLoadMessage)
               {
                  ShowMessage("Config file loaded!");
               }
            };
            url = new URLRequest(CONFIG_FILE_LOCATION);
            loader = new URLLoader();
            loader.load(url);
            loader.addEventListener(Event.COMPLETE,loaderComplete);
         }
         catch(e:Error)
         {
            ShowMessage("Error loading config: " + e);
         }
      }
      
      private function init() : *
      {
         ItemCard_Entry.zel_ShowDurability = ShowDurability;
         QuantityMenu.zel_ImprovedMenu = ImprovedQuantityMenu;
         BSUIDataManager.Subscribe("ExamineMenuMode",function(event:FromClientDataEvent):*
         {
            ExamineMenuMode = event.data.mode;
            if(ExamineMenuMode == "crafting")
            {
               initLegendaryModTracking();
            }
            else if(ExamineMenuMode == "inspect")
            {
               if(!usedRepairKit && _config.autoUseRepairKit != null && Boolean(_config.autoUseRepairKit.enabled))
               {
                  usedRepairKit = true;
                  setTimeout(useRepairKit,100);
               }
            }
            if(perkCards_tf != null)
            {
               perkCards_tf.visible = ExamineMenuMode != "inspect";
            }
         });
         if(this.ShowInventoryItemCount)
         {
            BSUIDataManager.Subscribe("PlayerInventoryData",mapInventory);
         }
      }
      
      private function useRepairKit() : void
      {
         if(false)
         {
            _examineMenu.displayError("entries: " + toString(_examineMenu.ItemCardList_mc.InfoObj));
         }
         if(_config.autoUseRepairKit.conditionUnder == null || isNaN(_config.autoUseRepairKit.conditionUnder))
         {
            _config.autoUseRepairKit.conditionUnder = 10;
         }
         if(_examineMenu.repairKitCount < 1)
         {
            _examineMenu.displayError("AutoUseRepairKit cancelled: no repair kits!");
            return;
         }
         var isWeaponOrArmor:Boolean = false;
         var isValid:Boolean = false;
         var i:int = _examineMenu.ItemCardList_mc.InfoObj.length - 1;
         while(i >= 0)
         {
            if(_examineMenu.ItemCardList_mc.InfoObj[i].text == "$health")
            {
               if(!(_examineMenu.ItemCardList_mc.InfoObj[i].currentHealth != -1 && _examineMenu.ItemCardList_mc.InfoObj[i].maximumHealth != 4294967295 && 100 * _examineMenu.ItemCardList_mc.InfoObj[i].currentHealth / _examineMenu.ItemCardList_mc.InfoObj[i].maximumHealth <= _config.autoUseRepairKit.conditionUnder))
               {
                  _examineMenu.displayError("AutoUseRepairKit cancelled: durability: " + _examineMenu.ItemCardList_mc.InfoObj[i].value + " > " + _config.autoUseRepairKit.conditionUnder);
                  break;
               }
               _examineMenu.displayError("AutoUseRepairKit: durability: " + _examineMenu.ItemCardList_mc.InfoObj[i].value + " <= " + _config.autoUseRepairKit.conditionUnder);
               if(_examineMenu.BGSCodeObj.OnRepairKit != null)
               {
                  isValid = true;
               }
            }
            else if(_examineMenu.ItemCardList_mc.InfoObj[i].text == "$dmg" || _examineMenu.ItemCardList_mc.InfoObj[i].text == "$dr")
            {
               isWeaponOrArmor = true;
            }
            i--;
         }
         if(isValid)
         {
            if(isWeaponOrArmor)
            {
               _examineMenu.BGSCodeObj.OnRepairKit();
               if(Boolean(_config.autoUseRepairKit.exitAfterRepair))
               {
                  setTimeout(_examineMenu.onBackButton,_config.autoUseRepairKit.exitDelay == null || isNaN(_config.autoUseRepairKit.exitDelay) ? 100 : _config.autoUseRepairKit.exitDelay);
               }
            }
            else
            {
               _examineMenu.displayError("AutoUseRepairKit cancelled: item is not weapon or armor!");
            }
         }
      }
      
      private function initPerkCardsTextField() : void
      {
         var cfg:* = _config.perkCardsConfig.textField || {};
         if(cfg.x == null || isNaN(cfg.x))
         {
            cfg.x = 0;
         }
         if(cfg.y == null || isNaN(cfg.y))
         {
            cfg.y = 400;
         }
         if(cfg.textSize == null || isNaN(cfg.textSize))
         {
            cfg.textSize = 20;
         }
         if(cfg.textFont == null)
         {
            cfg.textFont = "$MAIN_Font";
         }
         if(cfg.textAlign == null)
         {
            cfg.textAlign = "left";
         }
         cfg.textColor = cfg.textColor == null ? (cfg.textColor = 16777179) : int(cfg.textColor);
         this.perkCards_tf = new TextField();
         this.perkCards_tf.x = cfg.x;
         this.perkCards_tf.y = cfg.y;
         this.perkCards_tf.width = 500;
         this.perkCards_tf.height = 500;
         this.perkCards_tf.autoSize = TextFieldAutoSize.LEFT;
         this.perkCards_tf.multiline = true;
         this.perkCards_tf.selectable = false;
         this.perkCards_tf.mouseWheelEnabled = false;
         this.perkCards_tf.mouseEnabled = false;
         this.perkCards_tf.visible = false;
         var font:TextFormat = new TextFormat(cfg.textFont,cfg.textSize,cfg.textColor);
         font.align = cfg.textAlign;
         this.perkCards_tf.defaultTextFormat = font;
         this.perkCards_tf.setTextFormat(font);
         this.perkCards_tf.filters = Boolean(cfg.textShadow) ? [new DropShadowFilter(2,45,0,1,1,1,1,BitmapFilterQuality.HIGH)] : [];
         GlobalFunc.SetText(this.perkCards_tf,"",false);
         this._examineMenu.addChild(this.perkCards_tf);
      }
      
      private function initPerkCardsConfig(event:*) : void
      {
         if(_config == null || _config.perkCardsConfig == null || !_config.perkCardsConfig.enabled)
         {
            return;
         }
         if(PerksUIData == null || PerksUIData.perkCardDataA == null || PerksUIData.perkCardDataA.length == 0)
         {
            return;
         }
         if(LegendaryPerksMenuData == null || LegendaryPerksMenuData.perksArray == null || LegendaryPerksMenuData.perksArray.length == 0)
         {
            return;
         }
         if(_config.perkCardsConfig.perkCards == null || _config.perkCardsConfig.perkCards.length == 0)
         {
            this._examineMenu.displayError("PerkCardsConfig error: perkCards not found");
            return;
         }
         if(this.perkCards_tf != null)
         {
            return;
         }
         this.initPerkCardsTextField();
         var i:int = 0;
         while(i < PerksUIData.perkCardDataA.length)
         {
            if(_config.perkCardsConfig.perkCards.indexOf(PerksUIData.perkCardDataA[i].text) != -1)
            {
               if(PerksUIData.perkCardDataA[i].equipped)
               {
                  perkCardsData[PerksUIData.perkCardDataA[i].text] = PerksUIData.perkCardDataA[i].rank + 1;
               }
            }
            i++;
         }
         i = 0;
         while(i < PerksUIData.teammateCardDataA.length)
         {
            if(_config.perkCardsConfig.perkCards.indexOf(PerksUIData.teammateCardDataA[i].text) != -1)
            {
               if(PerksUIData.teammateCardDataA[i].equipped)
               {
                  if(perkCardsData[PerksUIData.teammateCardDataA[i].text] == null || perkCardsData[PerksUIData.teammateCardDataA[i].text] < PerksUIData.teammateCardDataA[i].rank + 1)
                  {
                     perkCardsData[PerksUIData.teammateCardDataA[i].text] = PerksUIData.teammateCardDataA[i].rank + 1;
                  }
               }
            }
            i++;
         }
         i = 0;
         while(i < LegendaryPerksMenuData.perksArray.length)
         {
            if(_config.perkCardsConfig.legendaryPerkCards.indexOf(LegendaryPerksMenuData.perksArray[i].perkName) != -1)
            {
               if(LegendaryPerksMenuData.perksArray[i].equipped)
               {
                  perkCardsData[LegendaryPerksMenuData.perksArray[i].perkName] = LegendaryPerksMenuData.perksArray[i].currentRank + 1;
               }
            }
            i++;
         }
         var formatEquipped:* = null;
         if(_config.perkCardsConfig.colorEquipped != null && !isNaN(_config.perkCardsConfig.colorEquipped))
         {
            formatEquipped = new TextFormat();
            formatEquipped.color = _config.perkCardsConfig.colorEquipped;
         }
         var formatUnequipped:* = null;
         if(_config.perkCardsConfig.colorUnequipped != null && !isNaN(_config.perkCardsConfig.colorUnequipped))
         {
            formatUnequipped = new TextFormat();
            formatUnequipped.color = _config.perkCardsConfig.colorUnequipped;
         }
         var applyFormats:* = [];
         var currentLineStartIndex:int = 0;
         this.perkCards_tf.text = _config.perkCardsConfig.headerText || "";
         if(this.perkCards_tf.text.length > 0)
         {
            this.perkCards_tf.text += "\n";
         }
         i = 0;
         while(i < _config.perkCardsConfig.perkCards.length)
         {
            currentLineStartIndex = this.perkCards_tf.text.length;
            if(perkCardsData[_config.perkCardsConfig.perkCards[i]] != null)
            {
               if(!_config.perkCardsConfig.showOnlyUnequipped)
               {
                  this.perkCards_tf.text += " " + _config.perkCardsConfig.formatEquipped.replace("{name}",_config.perkCardsConfig.perkCards[i]).replace("{rank}",perkCardsData[_config.perkCardsConfig.perkCards[i]]) + "\n";
                  if(formatEquipped != null)
                  {
                     applyFormats.push({
                        "format":formatEquipped,
                        "startIndex":currentLineStartIndex + 1,
                        "endIndex":this.perkCards_tf.text.length - 1
                     });
                  }
               }
            }
            else if(!_config.perkCardsConfig.showOnlyEquipped)
            {
               this.perkCards_tf.text += " " + _config.perkCardsConfig.formatUnequipped.replace("{name}",_config.perkCardsConfig.perkCards[i]).replace("{rank}","") + "\n";
               if(formatUnequipped != null)
               {
                  applyFormats.push({
                     "format":formatUnequipped,
                     "startIndex":currentLineStartIndex + 1,
                     "endIndex":this.perkCards_tf.text.length - 1
                  });
               }
            }
            i++;
         }
         i = 0;
         while(i < _config.perkCardsConfig.legendaryPerkCards.length)
         {
            currentLineStartIndex = this.perkCards_tf.text.length;
            if(perkCardsData[_config.perkCardsConfig.legendaryPerkCards[i]] != null)
            {
               if(!_config.perkCardsConfig.showOnlyUnequipped)
               {
                  this.perkCards_tf.text += " " + _config.perkCardsConfig.formatEquipped.replace("{name}",_config.perkCardsConfig.legendaryPerkCards[i]).replace("{rank}",perkCardsData[_config.perkCardsConfig.legendaryPerkCards[i]]) + "\n";
                  if(formatEquipped != null)
                  {
                     applyFormats.push({
                        "format":formatEquipped,
                        "startIndex":currentLineStartIndex + 1,
                        "endIndex":this.perkCards_tf.text.length - 1
                     });
                  }
               }
            }
            else if(!_config.perkCardsConfig.showOnlyEquipped)
            {
               this.perkCards_tf.text += " " + _config.perkCardsConfig.formatUnequipped.replace("{name}",_config.perkCardsConfig.legendaryPerkCards[i]).replace("{rank}","") + "\n";
               if(formatUnequipped != null)
               {
                  applyFormats.push({
                     "format":formatUnequipped,
                     "startIndex":currentLineStartIndex + 1,
                     "endIndex":this.perkCards_tf.text.length - 1
                  });
               }
            }
            i++;
         }
         i = 0;
         while(i < applyFormats.length)
         {
            this.perkCards_tf.setTextFormat(applyFormats[i].format,applyFormats[i].startIndex,applyFormats[i].endIndex);
            i++;
         }
         this.perkCards_tf.visible = ExamineMenuMode != "inspect";
         _examineMenu.displayError("Perk Cards Config initialized!");
      }
      
      public function initUI() : void
      {
         if(isUIinit || !Config || !Config.uiConfig || !Config.uiConfig.enabled)
         {
            _examineMenu.alpha = 1;
            return;
         }
         isUIinit = true;
         if(Boolean(Config.uiConfig.hideVignette))
         {
            if(getQualifiedClassName(_examineMenu.getChildAt(1)) == "flash.display::MovieClip")
            {
               _examineMenu.getChildAt(1).visible = false;
            }
         }
         if(Boolean(Config.uiConfig.hideBackground))
         {
            _examineMenu.CenterShadedBG_mc.visible = false;
            _examineMenu.ItemCardContainer_mc.Background_mc.visible = false;
         }
         if(Boolean(Config.uiConfig.hideHeader))
         {
            _examineMenu.Header_mc.visible = false;
         }
         if(Config.uiConfig.ItemName)
         {
            var x:Number = parseNumber(Config.uiConfig.ItemName.x);
            var y:Number = parseNumber(Config.uiConfig.ItemName.y);
            var align:String = Config.uiConfig.ItemName.align;
            _examineMenu.ItemName_tf.x += x;
            _examineMenu.ItemName_tf.y += y;
            setAlignment(_examineMenu.ItemName_tf,align);
         }
         if(Config.uiConfig.ItemDescription)
         {
            x = parseNumber(Config.uiConfig.ItemDescription.x);
            y = parseNumber(Config.uiConfig.ItemDescription.y);
            align = Config.uiConfig.ItemDescription.align;
            _examineMenu.LegendaryItemDescription_tf.x += x;
            _examineMenu.LegendaryItemDescription_tf.y += y;
            setAlignment(_examineMenu.LegendaryItemDescription_tf,align);
         }
         if(Config.uiConfig.ItemCard)
         {
            x = parseNumber(Config.uiConfig.ItemCard.x);
            y = parseNumber(Config.uiConfig.ItemCard.y);
            _examineMenu.ItemCardContainer_mc.x += x;
            _examineMenu.ItemCardContainer_mc.y += y;
         }
         if(Config.uiConfig.Inventory)
         {
            x = parseNumber(Config.uiConfig.Inventory.x);
            y = parseNumber(Config.uiConfig.Inventory.y);
            _examineMenu.InventoryBase_mc.x += x;
            _examineMenu.InventoryBase_mc.y += y;
         }
         if(Config.uiConfig.CraftingHierarchy)
         {
            x = parseNumber(Config.uiConfig.CraftingHierarchy.x);
            y = parseNumber(Config.uiConfig.CraftingHierarchy.y);
            _examineMenu.CraftingHeirarchy_mc.x += x;
            _examineMenu.CraftingHeirarchy_mc.y += y;
         }
         if(Config.uiConfig.KnownMods)
         {
            x = parseNumber(Config.uiConfig.KnownMods.x);
            y = parseNumber(Config.uiConfig.KnownMods.y);
            _examineMenu.KnownModsInfo_mc.x += x;
            _examineMenu.KnownModsInfo_mc.y += y;
         }
         if(Config.uiConfig.ModDescription)
         {
            x = parseNumber(Config.uiConfig.ModDescription.x);
            y = parseNumber(Config.uiConfig.ModDescription.y);
            _examineMenu.ModDescriptionBase_mc.x += x;
            _examineMenu.ModDescriptionBase_mc.y += y;
         }
         if(Config.uiConfig.Mods)
         {
            x = parseNumber(Config.uiConfig.Mods.x);
            y = parseNumber(Config.uiConfig.Mods.y);
            _examineMenu.CurrentModsBase_mc.x += x;
            _examineMenu.CurrentModsBase_mc.y += y;
            _examineMenu.ModSlotBase_mc.x += x;
            _examineMenu.ModSlotBase_mc.y += y;
         }
         if(Config.uiConfig.PerksLabel)
         {
            x = parseNumber(Config.uiConfig.PerksLabel.x);
            y = parseNumber(Config.uiConfig.PerksLabel.y);
            _examineMenu.perkPanelLabel_mc.x += x;
            _examineMenu.perkPanelLabel_mc.y += y;
         }
         if(Config.uiConfig.PerksPanel1)
         {
            x = parseNumber(Config.uiConfig.PerksPanel1.x);
            y = parseNumber(Config.uiConfig.PerksPanel1.y);
            _examineMenu.PerkPanel0_mc.x += x;
            _examineMenu.PerkPanel0_mc.y += y;
         }
         if(Config.uiConfig.PerksPanel2)
         {
            x = parseNumber(Config.uiConfig.PerksPanel2.x);
            y = parseNumber(Config.uiConfig.PerksPanel2.y);
            _examineMenu.PerkPanel1_mc.x += x;
            _examineMenu.PerkPanel1_mc.y += y;
         }
         _examineMenu.alpha = 1;
         _examineMenu.ItemName_tf.alpha = 1;
         _examineMenu.LegendaryItemDescription_tf.alpha = 1;
         _examineMenu.ItemCardContainer_mc.alpha = 1;
         _examineMenu.InventoryBase_mc.alpha = 1;
         _examineMenu.CraftingHeirarchy_mc.alpha = 1;
         _examineMenu.ModDescriptionBase_mc.alpha = 1;
         _examineMenu.KnownModsInfo_mc.alpha = 1;
         _examineMenu.CurrentModsBase_mc.alpha = 1;
         _examineMenu.ModSlotBase_mc.alpha = 1;
         _examineMenu.perkPanelLabel_mc.alpha = 1;
         _examineMenu.PerkPanel0_mc.alpha = 1;
         _examineMenu.PerkPanel1_mc.alpha = 1;
         _examineMenu.displayError("UI Config initialized!");
         if(Config.debugChildren)
         {
            var i:int = 0;
            while(i < _examineMenu.numChildren)
            {
               _examineMenu.displayError(i + ":" + getQualifiedClassName(_examineMenu.getChildAt(i)));
               if(i == Config.uiConfig.testId)
               {
                  if(_examineMenu.getChildAt(i).visible != null && _examineMenu.getChildAt(i).visible != undefined)
                  {
                     _examineMenu.getChildAt(i).visible = false;
                     _examineMenu.displayError("alpha set");
                  }
                  else
                  {
                     _examineMenu.displayError("alpha not set");
                  }
               }
               i++;
            }
         }
      }
      
      public function mapInventory(event:*) : void
      {
         if(event == null || event.data == null || event.data.InventoryList == null || event.data.InventoryList.length == 0)
         {
            _examineMenu.displayError("mapInventory: InventoryList not found!");
            return;
         }
         inventoryCounts = {};
         var i:int = 0;
         while(i < event.data.InventoryList.length)
         {
            var item:* = event.data.InventoryList[i];
            var parts:* = item.text.split("x");
            if(/.+x[0-9]+/.test(item.text))
            {
               var itemText:String = item.text.replace(/\s*x[0-9]+/,"");
            }
            else if(item.text.indexOf("¢") != -1)
            {
               itemText = item.text.replace(/\s*¢/,"");
            }
            else
            {
               itemText = item.text;
            }
            if(inventoryCounts[itemText] > 0)
            {
               inventoryCounts[itemText] += item.count;
            }
            else
            {
               inventoryCounts[itemText] = item.count;
            }
            i++;
         }
         _examineMenu.displayError("Inventory count mapped!");
         updateInventoryCount();
      }
      
      public function updateInventoryCount() : void
      {
         if(!this.ShowInventoryItemCount || ExamineMenuMode != "crafting")
         {
            return;
         }
         var i:int = 0;
         while(i < _examineMenu.InventoryBase_mc.InventoryList_mc.entryList.length)
         {
            var count:* = inventoryCounts[_examineMenu.InventoryBase_mc.InventoryList_mc.entryList[i].text.replace(/\s*x[0-9]+/,"").replace(/\s*¢/,"")];
            if(count > 0)
            {
               _examineMenu.InventoryBase_mc.InventoryList_mc.entryList[i].text += " (" + count + ")";
            }
            i++;
         }
         _examineMenu.InventoryBase_mc.InventoryList_mc.InvalidateData();
      }
      
      private function setAlignment(obj:*, align:String) : void
      {
         if(obj != null && (align == "left" || align == "right" || align == "center"))
         {
            var textFormat:* = obj.getTextFormat();
            if(textFormat != null)
            {
               textFormat.align = align;
               obj.defaultTextFormat = textFormat;
               obj.setTextFormat(textFormat);
            }
         }
      }
      
      private function onSubUpdated(param1:Event) : *
      {
         var data:String = toString(param1);
         this._examineMenu.displayError("Event listener data for: " + Config.testMethod);
         this._examineMenu.displayError(data);
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         if(!Debug)
         {
            return false;
         }
         if(Config.debugKeys)
         {
            this._examineMenu.displayError("Event: " + param1 + " (" + param2 + ")");
         }
         if(param1 == "Up")
         {
            if(Config.testMethod != null)
            {
               var apiData:* = getApiData(Config.testMethod);
               var data:String = toString(apiData);
               this._examineMenu.displayError("Retrieve data for: " + Config.testMethod);
               this._examineMenu.displayError(data);
            }
         }
         else if(param1 == "Down")
         {
            var _i:* = 0;
         }
         else if(param1 == "Left")
         {
            this._examineMenu.displayError("CLS",true);
         }
         else if(param1 == "Right")
         {
            if(Config.childrenOf)
            {
               if(this._examineMenu[Config.childrenOf] == null)
               {
                  this._examineMenu.displayError(Config.childrenOf + " not found in examinemenu");
               }
               else
               {
                  this._examineMenu.displayError("Children of: " + Config.childrenOf);
                  for(var i in this._examineMenu[Config.childrenOf])
                  {
                     this._examineMenu.displayError(i + " : " + this._examineMenu[Config.childrenOf][i] + " : " + getQualifiedClassName(this._examineMenu[Config.childrenOf][i]));
                  }
               }
            }
            if(Config.exec)
            {
               this._examineMenu.displayError("exec");
               i = 0;
               while(i < Config.exec.length)
               {
                  this._examineMenu.displayError("exec0: " + Config.exec[i] + ", " + Config.exec[i].length);
                  this._examineMenu.displayError(Config.exec[i] + " in: " + this._examineMenu);
                  this._examineMenu.displayError(Config.exec[i] in this._examineMenu);
                  if("length" in Config.exec[i])
                  {
                     var j:int = 0;
                     this._examineMenu.displayError("exec1: " + Config.exec[i][j]);
                     while(j < Config.exec[i].length)
                     {
                        this._examineMenu.displayError(Config.exec[i][j] + ": " + toString(this._examineMenu.getChildByName(Config.exec[i]).getChildByName(Config.exec[i][j])));
                        j++;
                     }
                  }
                  else
                  {
                     this._examineMenu.displayError(Config.exec[i] + ": " + toString(this._examineMenu.getChildByName(Config.exec[i])));
                  }
                  i++;
               }
            }
            this._examineMenu.displayError("exec not found");
         }
         return false;
      }

      private function initLegendaryModTracking() : *
      {
         if(_config == null || _config.legendaryModTrackingConfig == null || !_config.legendaryModTrackingConfig.enabled)
         {
            return;
         }
         if(_config.legendaryModTrackingConfig.keepList != null)
         {
            this.legendaryModKeepList = _config.legendaryModTrackingConfig.keepList.map(function(mod:*):*
            {
               return mod.toLowerCase();
            });
            this._examineMenu.displayError("Legendary Mods to Keep: " + this.legendaryModKeepList.join(", "));
         }
         if(_config.legendaryModTrackingConfig.blockList != null)
         {
            this.legendaryModBlockList = _config.legendaryModTrackingConfig.blockList.map(function(mod:*):*
            {
               return mod.toLowerCase();
            });
            this._examineMenu.displayError("Legendary Mods to Block: " + this.legendaryModBlockList.join(", "));
         }
         setTimeout(loadExistingItemsmodIni,25);
         setTimeout(writeLegendaryModsToFile,100);
      }
      
      private function writeLegendaryModsToFile() : *
      {
         if(ExamineMenuMode != "crafting")
         {
            this._examineMenu.displayError("Examine menu mode not crafting (" + ExamineMenuMode + "), saving Legendary mods cancelled!");
            return;
         }
         if(this.hasScannedLegendaryMods)
         {
            return;
         }
         if(!this.isSfeDefined() && !Config.SFEENABLED)
         {
            this._examineMenu.displayError("Cannot find SFE, saving Legendary mods cancelled!");
            return;
         }
         this.hasScannedLegendaryMods = true;
         var legendaryModsList1:* = this.getAvailableLegendaryMods();
         this._examineMenu.onFilterAtx();
         var legendaryModsList2:* = this.getAvailableLegendaryMods(true);
         this._examineMenu.onFilterAtx();
         if(Config.debugList)
         {
            this._examineMenu.displayError("1st list: " + legendaryModsList1.length);
            var out:String = "";
            for each(l in legendaryModsList1)
            {
               out += l.fullName + ", ";
            }
            this._examineMenu.displayError(out);
            out = "";
            for each(l in legendaryModsList2)
            {
               out += l.fullName + ", ";
            }
            this._examineMenu.displayError("2nd list: " + legendaryModsList2.length);
            this._examineMenu.displayError(out);
         }
         if(legendaryModsList1.length >= legendaryModsList2.length)
         {
            var allLegendaryMods:Array = legendaryModsList1;
            var learnedLegendaryMods:Array = legendaryModsList2;
         }
         else
         {
            allLegendaryMods = legendaryModsList2;
            learnedLegendaryMods = legendaryModsList1;
         }
         if(allLegendaryMods.length == 0)
         {
            this._examineMenu.displayError("No legendary mods data found!");
            return;
         }
         var learnedLegendaryModNamesDict:* = {};
         var i:* = 0;
         while(i < learnedLegendaryMods.length)
         {
            var currentMod:Object = learnedLegendaryMods[i];
            learnedLegendaryModNamesDict[currentMod.fullName] = true;
            i++;
         }
         var j:* = 0;
         while(j < allLegendaryMods.length)
         {
            currentMod = allLegendaryMods[j];
            currentMod.isLearned = Boolean(learnedLegendaryModNamesDict[currentMod.fullName]);
            var currentModName:* = trimString(replaceInString(currentMod.fullName.toLowerCase(),"¬",""));
            currentMod.isKept = this.legendaryModKeepList.indexOf(currentMod.fullName) != -1 || this.legendaryModKeepList.indexOf(currentModName) != -1;
            j++;
         }
         var characterName:* = BSUIDataManager.GetDataFromClient("CharacterNameData").data.characterName;
         if(!characterName)
         {
            return;
         }
         if(_legendaryModsFromIni != null)
         {
            _legendaryModsFromIni.version = VERSION;
            if(!_legendaryModsFromIni.characterInventories)
            {
               _legendaryModsFromIni.characterInventories = {};
            }
            _legendaryModsFromIni.characterInventories[characterName] = {"legendaryMods":allLegendaryMods};
            this.writeData(new JSONEncoder(_legendaryModsFromIni).getString());
         }
         else
         {
            var data:* = {
               "version":VERSION,
               "modName":MOD_NAME
            };
            data.characterInventories = {};
            data.characterInventories[characterName] = {"legendaryMods":allLegendaryMods};
            this.writeData(new JSONEncoder(data).getString());
         }
      }
      
      private function getAvailableLegendaryMods(doNotSkip:Boolean = false) : Object
      {
         var legendaryModIndexes:Array = [];
         var i:* = 0;
         while(i < this._examineMenu.ModSlotListObject.entryList.length)
         {
            var slotName:* = this._examineMenu.ModSlotListObject.entryList[i].slotName;
            if(indexOfCaseInsensitiveString(LEGENDARY_MOD_LOCALIZED,slotName) != -1)
            {
               legendaryModIndexes.push(i);
            }
            i++;
         }
         if(legendaryModIndexes.length == 0)
         {
            return [];
         }
         var modSlotStartingIndex:* = this._examineMenu.ModSlotListObject.selectedIndex || 0;
         var modListStartingIndex:* = this._examineMenu.ModListObject.selectedIndex || 0;
         var learnedModsList:* = [];
         var craftLegendaryModsIndex:* = 0;
         while(craftLegendaryModsIndex < legendaryModIndexes.length)
         {
            this._examineMenu.ModSlotListObject.selectedIndex = legendaryModIndexes[craftLegendaryModsIndex];
            this._examineMenu.ModSlotListObject.selectedEntry;
            if(legendaryModIndexes[craftLegendaryModsIndex] == this._examineMenu.ModSlotListObject.selectedIndex)
            {
               var j:* = 0;
               while(j < this._examineMenu.ModListObject.entryList.length)
               {
                  this._examineMenu.ModListObject.selectedIndex = j;
                  var legendaryMod:* = doNotSkip ? this._examineMenu.ModListObject.entryList[j] : this._examineMenu.ModListObject.selectedEntry;
                  if(j == this._examineMenu.ModListObject.selectedIndex || doNotSkip)
                  {
                     var legendaryModFullName:* = legendaryMod.text;
                     var legendaryModStars:* = countInString(legendaryModFullName,"¬");
                     var legendaryModName:* = trimString(replaceInString(legendaryModFullName,"¬",""));
                     var legendaryModDesc:* = {};
                     var descParts:* = legendaryMod.description.split("\n");
                     var k:* = 0;
                     var isBlocked:* = this.legendaryModBlockList.indexOf(legendaryModName.toLowerCase()) != -1;
                     while(!isBlocked && k < descParts.length)
                     {
                        var part:* = descParts[k].replace(LEGENDARY_MOD_CURRENTLY_REGEX,"").replace(/^\s+|\s+$/g,"");
                        if(part.length != 0)
                        {
                           var endOfBracketIndex:* = part.indexOf("] ");
                           if(endOfBracketIndex > -1)
                           {
                              var findPowerArmorIndex:int = int(part.search(LEGENDARY_MOD_POWER_ARMOR_REGEX));
                              var findArmorIndex:int = int(part.search(LEGENDARY_MOD_ARMOR_REGEX));
                              var findWeaponsIndex:int = int(part.search(LEGENDARY_MOD_WEAPONS_REGEX));
                              if(findPowerArmorIndex > -1 && findPowerArmorIndex < endOfBracketIndex)
                              {
                                 legendaryModDesc.powerArmor = part.slice(endOfBracketIndex + 2);
                              }
                              else if(findArmorIndex > -1 && findArmorIndex < endOfBracketIndex)
                              {
                                 legendaryModDesc.armor = part.slice(endOfBracketIndex + 2);
                              }
                              else if(findWeaponsIndex > -1 && findWeaponsIndex < endOfBracketIndex)
                              {
                                 legendaryModDesc.weapons = part.slice(endOfBracketIndex + 2);
                              }
                              else
                              {
                                 legendaryModDesc["unknown_" + k] = part;
                              }
                           }
                           else if(legendaryModName.search(LEGENDARY_MOD_RAPID_REGEX) > -1)
                           {
                              legendaryModDesc.ranged = part;
                              legendaryModDesc.melee = part.replace("25%","40%");
                           }
                           else if(!legendaryModDesc.all)
                           {
                              legendaryModDesc.all = part;
                           }
                           else
                           {
                              legendaryModDesc["unknown_" + k] = part;
                           }
                        }
                        k++;
                     }
                     if(!isBlocked)
                     {
                        learnedModsList.push({
                           "fullName":legendaryModFullName,
                           "stars":legendaryModStars,
                           "name":legendaryModName,
                           "description":legendaryModDesc
                        });
                     }
                  }
                  j++;
               }
            }
            craftLegendaryModsIndex++;
         }
         this._examineMenu.ModSlotListObject.selectedIndex = modSlotStartingIndex;
         this._examineMenu.ModListObject.selectedIndex = modListStartingIndex;
         return learnedModsList;
      }
      
      public function isSfeDefined() : Boolean
      {
         return this._examineMenu.__SFCodeObj != null && this._examineMenu.__SFCodeObj.call != null;
      }
      
      protected function writeData(data:String) : void
      {
         try
         {
            if(this.isSfeDefined())
            {
               this._examineMenu.__SFCodeObj.call("writeLegendaryModsFile",data);
               this._examineMenu.displayError("Done saving Legendary mods!");
            }
            else
            {
               this._examineMenu.displayError("Cannot find SFE, writing to file cancelled!");
            }
         }
         catch(e:Error)
         {
            this._examineMenu.displayError("Error saving Legendary mods! " + e);
         }
      }
      
      private function loadExistingItemsmodIni() : void
      {
         var loaderComplete:Function;
         var url:URLRequest;
         var loader:URLLoader;
         if(ExamineMenuMode != "crafting")
         {
            _examineMenu.displayError("loadExistingItemsmodIni cancelled!");
            return;
         }
         if(_legendaryModsFromIni != null)
         {
            return;
         }
         url = null;
         loader = null;
         try
         {
            loaderComplete = function(param1:Event):void
            {
               var data:Object;
               var decoder:JsonDecoderAsync;
               var regex:RegExp;
               try
               {
                  if(loader.data.search(/\"modName\":\s*\"ImprovedWorkbench\"/) != -1)
                  {
                     decoder = new JsonDecoderAsync(loader.data,false);
                     if(!decoder.process())
                     {
                        _examineMenu.displayError("JSONDecoderAsync error: " + decoder.result);
                     }
                     else
                     {
                        _legendaryModsFromIni = decoder.result;
                     }
                  }
                  else
                  {
                     _examineMenu.displayError("Existing LegendaryMods not loaded, invalid extractor mod name");
                  }
               }
               catch(e:Error)
               {
                  _examineMenu.displayError("Error parsing existing LegendaryMods file " + e);
               }
               if(_legendaryModsFromIni)
               {
                  _examineMenu.displayError("Legendary mods data loaded! " + LEGENDARY_LOAD_FILE_LOCATION);
               }
               else
               {
                  _examineMenu.displayError("Legendary mods data not loaded!");
               }
            };
            url = new URLRequest(LEGENDARY_LOAD_FILE_LOCATION);
            loader = new URLLoader();
            loader.addEventListener(Event.COMPLETE,loaderComplete);
            loader.load(url);
         }
         catch(e:Error)
         {
            _examineMenu.displayError("Error loading existing LegendaryMods file: " + e.getStackTrace());
         }
      }
   }
}

