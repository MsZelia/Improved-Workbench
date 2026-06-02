package
{
   import Shared.AS3.ItemListEntryBase;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol26")]
   public class ModListEntry extends ItemListEntryBase
   {
      
      private static const ENTRY_BORDER_ALPHA:Number = 0.25;
      
      public var count:TextField;
      
      public var taggedIcon_mc:MovieClip;
      
      public var ItemLockIcon_mc:MovieClip;
      
      public function ModListEntry()
      {
         super();
      }
      
      override public function SetEntryText(param1:Object, param2:String) : *
      {
         var _loc4_:String = null;
         var _loc5_:* = false;
         super.SetEntryText(param1,param2);
         var _loc3_:* = Math.log(param1.filterIndex) / Math.log(2);
         if(param1.usedCount != undefined && param1.componentCountA != undefined && _loc3_ < param1.componentCountA.length)
         {
            if(param1.componentCountA[_loc3_] == undefined)
            {
               param1.componentCountA[_loc3_] = 0;
            }
            this.count.text = (param1.usedCount * param1.componentCountA[_loc3_]).toString() + "/" + param1.componentCountA[_loc3_];
         }
         else
         {
            this.count.text = "";
         }
         if(param1.accountedFor != null && param1.requiredCount != null)
         {
            _loc4_ = param1.text + " " + (!ExamineMenu.TransferLockSettingAllowCraftingUse && param1.unlockedAccountedFor != null ? param1.unlockedAccountedFor : param1.accountedFor) + "/" + param1.requiredCount;
            _loc5_ = !(param1.betcText != true && (!ExamineMenu.TransferLockSettingAllowCraftingUse && param1.unlockedAccountedFor != null ? param1.unlockedAccountedFor : param1.accountedFor) < param1.requiredCount);
         }
         else
         {
            if(Boolean(param1.isMTX) || Boolean(param1.isMtx) || Boolean(param1.isZeus))
            {
               _loc5_ = param1.enabled !== false && param1.hasRequired !== false && Boolean(param1.hasEntitlement);
            }
            else
            {
               _loc5_ = param1.betcText == true || Boolean(param1.enabled) || Boolean(param1.hasRequired);
            }
            _loc4_ = param1.text;
         }
         if(param1.text != undefined)
         {
            if(param1.betcText == true)
            {
               GlobalFunc.SetText(textField,"$More...",false);
               this.count.text = "";
               if(param1.validUnshownMod != true)
               {
                  _loc5_ = false;
               }
            }
            else
            {
               GlobalFunc.SetText(textField,param1.count > 1 ? _loc4_ + " (" + param1.count + ")" : _loc4_,false);
            }
         }
         var _loc6_:Boolean = false;
         if(!ExamineMenu.TransferLockSettingAllowCraftingUse && param1.isTransferLocked && param1.accountedFor != null && param1.unlockedAccountedFor != null && param1.requiredCount != null)
         {
            _loc6_ = param1.unlockedAccountedFor < param1.requiredCount && param1.accountedFor >= param1.requiredCount;
         }
         if(!_loc5_)
         {
            textField.textColor = 5661031;
         }
         else
         {
            textField.textColor = 16777163;
         }
         if(param1 != null && param1.isTransferLocked && !ExamineMenu.TransferLockSettingAllowCraftingUse)
         {
            textField.textColor = 16777163;
         }
         if(param1.taggedForSearch == true)
         {
            this.taggedIcon_mc.visible = true;
         }
         else
         {
            this.taggedIcon_mc.visible = false;
         }
         if(this.ItemLockIcon_mc != null)
         {
            this.ItemLockIcon_mc.visible = param1 != null && Boolean(param1.isTransferLocked) && !ExamineMenu.TransferLockSettingAllowCraftingUse;
         }
         border.alpha = ENTRY_BORDER_ALPHA;
      }
   }
}

