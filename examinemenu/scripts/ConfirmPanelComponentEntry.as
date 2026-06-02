package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class ConfirmPanelComponentEntry extends MovieClip
   {
      
      public static var bTransferLockSettingAllowCraftingUse:Boolean = false;
      
      public var textField:TextField;
      
      public var Background_mc:MovieClip;
      
      public var FavoritedIcon_mc:MovieClip;
      
      public var ItemLockIcon_mc:MovieClip;
      
      private var ComponentName:String;
      
      private var ComponentRequiredCount:uint;
      
      private var ComponentInventoryCount:uint;
      
      private var ComponentFavorited:Boolean;
      
      private var ComponentDisplayColor:uint = 0;
      
      private var UnlockedAccountedFor:uint;
      
      private var IsTransferLocked:Boolean;
      
      public function ConfirmPanelComponentEntry(param1:*)
      {
         super();
         this.ComponentName = param1;
         this.ComponentRequiredCount = 0;
         this.ComponentInventoryCount = uint.MAX_VALUE;
         this.UnlockedAccountedFor = uint.MAX_VALUE;
         this.IsTransferLocked = false;
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.textField,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setNoTranslate(this.textField,true);
      }
      
      public function get componentName() : String
      {
         return this.ComponentName;
      }
      
      public function get componentRequiredCount() : uint
      {
         return this.ComponentRequiredCount;
      }
      
      public function set componentRequiredCount(param1:uint) : *
      {
         this.ComponentRequiredCount = param1;
         this.UpdateText();
      }
      
      public function get componentInventoryCount() : uint
      {
         return this.ComponentInventoryCount;
      }
      
      public function set componentInventoryCount(param1:uint) : *
      {
         this.ComponentInventoryCount = param1;
         this.UpdateText();
      }
      
      public function get componentFavorited() : Boolean
      {
         return this.ComponentFavorited;
      }
      
      public function set componentFavorited(param1:Boolean) : *
      {
         this.ComponentFavorited = param1;
         this.UpdateFavoritedIcon();
      }
      
      public function set componentDisplayColor(param1:uint) : *
      {
         this.ComponentDisplayColor = param1;
         this.UpdateText();
      }
      
      public function get unlockedAccountedFor() : uint
      {
         return this.UnlockedAccountedFor;
      }
      
      public function set unlockedAccountedFor(param1:uint) : *
      {
         this.UnlockedAccountedFor = param1;
         this.UpdateText();
      }
      
      public function get isTransferLocked() : Boolean
      {
         return this.IsTransferLocked;
      }
      
      public function set isTransferLocked(param1:Boolean) : *
      {
         this.IsTransferLocked = param1;
         this.UpdateText();
      }
      
      public function UpdateText() : *
      {
         var _loc2_:* = null;
         var _loc4_:String = null;
         var _loc1_:uint = !ConfirmPanelComponentEntry.bTransferLockSettingAllowCraftingUse && this.UnlockedAccountedFor < uint.MAX_VALUE ? this.UnlockedAccountedFor : this.ComponentInventoryCount;
         if(_loc1_ < uint.MAX_VALUE)
         {
            _loc2_ = this.ComponentName + " (" + Math.min(_loc1_,this.ComponentRequiredCount).toString() + "/" + this.ComponentRequiredCount.toString() + ")";
         }
         else if(this.ComponentRequiredCount > 1)
         {
            _loc2_ = this.ComponentName + " (" + this.ComponentRequiredCount.toString() + ")";
         }
         else
         {
            _loc2_ = this.ComponentName;
         }
         if(this.ComponentDisplayColor > 0)
         {
            _loc4_ = this.ComponentDisplayColor.toString(16);
            _loc2_ = "<font color=\"#" + _loc4_ + "\">" + _loc2_ + "</font>";
         }
         GlobalFunc.SetText(this.textField,_loc2_,true);
         var _loc3_:Boolean = !ConfirmPanelComponentEntry.bTransferLockSettingAllowCraftingUse && this.IsTransferLocked && this.UnlockedAccountedFor < this.ComponentRequiredCount && this.ComponentInventoryCount >= this.ComponentRequiredCount;
         this.textField.alpha = _loc1_ < this.ComponentRequiredCount && !_loc3_ ? GlobalFunc.DIMMED_ALPHA : 1;
         if(this.Background_mc != null)
         {
            this.Background_mc.visible = this.ComponentName != "";
         }
         if(this.ItemLockIcon_mc != null)
         {
            this.ItemLockIcon_mc.visible = this.IsTransferLocked && !ConfirmPanelComponentEntry.bTransferLockSettingAllowCraftingUse;
         }
      }
      
      public function UpdateFavoritedIcon() : *
      {
         this.FavoritedIcon_mc.visible = this.ComponentFavorited;
      }
   }
}

