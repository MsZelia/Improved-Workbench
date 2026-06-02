package ExamineMenu_fla
{
   import adobe.utils.*;
   import flash.accessibility.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.globalization.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.sensors.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.engine.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol430")]
   public dynamic class ModsBase_26 extends MovieClip
   {
      
      public var ModSlotList_mc:CurrentModList;
      
      public var SlotsLabel_tf:TextField;
      
      public function ModsBase_26()
      {
         super();
         this.__setProp_ModSlotList_mc_ModsBase_ModSlotList_mc_0();
      }
      
      internal function __setProp_ModSlotList_mc_ModsBase_ModSlotList_mc_0() : *
      {
         try
         {
            this.ModSlotList_mc["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.ModSlotList_mc.listEntryClass = "CurrentModListEntry";
         this.ModSlotList_mc.numListItems = 8;
         this.ModSlotList_mc.restoreListIndex = false;
         this.ModSlotList_mc.textOption = "None";
         this.ModSlotList_mc.verticalSpacing = -8;
         try
         {
            this.ModSlotList_mc["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}

