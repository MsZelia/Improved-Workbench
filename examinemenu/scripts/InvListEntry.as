package
{
   import Shared.AS3.ItemListEntryBase;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.DropShadowFilter;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol86")]
   public class InvListEntry extends ItemListEntryBase
   {
      
      public var EquipIconInstance:MovieClip;
      
      public var FavoriteIconInstance:MovieClip;
      
      public var BestIconInstance:MovieClip;
      
      public var LockIcon_mc:MovieClip;
      
      public var SetBonusIcon_mc:MovieClip;
      
      public var ATXCost_mc:MovieClip;
      
      public var ItemLockIcon_mc:MovieClip;
      
      public function InvListEntry()
      {
         super();
      }
      
      override public function SetEntryText(param1:Object, param2:String) : *
      {
         var _loc3_:String = null;
         super.SetEntryText(param1,param2);
         if(param1.accountedFor != null && param1.requiredCount != null)
         {
            _loc3_ = param1.text + " " + param1.accountedFor + "/" + param1.requiredCount;
         }
         else
         {
            _loc3_ = param1.text;
         }
         var _loc4_:* = GlobalFunc.BuildLegendaryStarsGlyphString(param1);
         if(param1.text != undefined)
         {
            GlobalFunc.SetText(textField,param1.count > 1 ? _loc3_ + _loc4_ + " (" + param1.count + ")" : _loc3_ + _loc4_,true);
         }
         var _loc5_:Boolean = Boolean(param1.enabled) || Boolean(param1.hasRequired) || param1.equipState > 0;
         if(selected)
         {
            textField.filters = [];
            if(_loc5_)
            {
               textField.textColor = 1580061;
            }
            else
            {
               textField.textColor = 6315576;
            }
         }
         else
         {
            if(!_loc5_)
            {
               textField.textColor = 5661031;
            }
            textField.filters = [new DropShadowFilter(2,135,0,1,1,1,1,BitmapFilterQuality.HIGH)];
         }
         this.EquipIconInstance.visible = param1.equipState > 0 && !(ExamineMenu.IsTransferLockingFeatureEnabled && param1.isTransferLocked);
         this.FavoriteIconInstance.visible = param1.favorite;
         this.BestIconInstance.visible = param1.bestInClass;
         this.SetBonusIcon_mc.visible = param1.isSetItem;
         this.ItemLockIcon_mc.visible = Boolean(param1.isTransferLocked) && ExamineMenu.IsTransferLockingFeatureEnabled;
         if(this.ItemLockIcon_mc.visible)
         {
            this.ItemLockIcon_mc.gotoAndStop(param1.isTransferLocked && ExamineMenu.IsTransferLockingFeatureEnabled && param1.equipState > 0 ? "isEquipped" : "isUnequipped");
         }
         if(this.SetBonusIcon_mc.visible)
         {
            this.SetBonusIcon_mc.gotoAndStop(Boolean(param1.isSetBonusActive) && param1.equipState > 0 ? "active" : "inactive");
         }
         var _loc6_:uint = this.textField.getLineMetrics(0).width + this.textField.x + 5;
         if(this.SetBonusIcon_mc.visible)
         {
            this.SetBonusIcon_mc.x = _loc6_;
            _loc6_ += this.SetBonusIcon_mc.width + 5;
         }
         if(this.FavoriteIconInstance.visible)
         {
            this.FavoriteIconInstance.x = _loc6_;
         }
         this.LockIcon_mc.visible = false;
         SetColorTransform(this.EquipIconInstance,this.selected);
         SetColorTransform(this.FavoriteIconInstance,this.selected);
         SetColorTransform(this.BestIconInstance,this.selected);
         SetColorTransform(this.SetBonusIcon_mc,this.selected);
         SetColorTransform(this.ItemLockIcon_mc,this.selected);
         if(this.ATXCost_mc != null)
         {
            if(param1.isMTX && !param1.hasEntitlement && param1.mtxPrice != null)
            {
               if(param1.mtxPrice > 0)
               {
                  this.ATXCost_mc.ATXCost_tf.text = param1.mtxPrice + "¢";
               }
               else
               {
                  this.ATXCost_mc.ATXCost_tf.text = "$FREE!";
               }
               SetColorTransform(this.ATXCost_mc,this.selected);
               this.ATXCost_mc.ATXCost_tf.textColor = textField.textColor;
               this.ATXCost_mc.ATXCost_tf.filters = textField.filters;
               this.ATXCost_mc.visible = true;
            }
            else
            {
               this.ATXCost_mc.visible = false;
            }
         }
      }
   }
}

