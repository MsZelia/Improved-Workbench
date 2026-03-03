package Shared.AS3
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol381")]
   public class PerkClipRequirement extends PerkClipBase
   {
      
      public var Rank_mc:MovieClip;
      
      public var LevelRestricted_mc:MovieClip;
      
      private var m_LastVaultBoyImageName:String;
      
      public function PerkClipRequirement()
      {
         super();
         VaultBoyImageContainer_mc.scaleX = 0.75;
         VaultBoyImageContainer_mc.scaleY = 0.75;
      }
      
      override public function redrawDisplayObject() : void
      {
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Rank_mc.Rank_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this.Rank_mc.Rank_tf.text = "$$Rank: " + m_Rank;
         this.LevelRestricted_mc.visible = !m_IsLevelMet && !m_IsLinked;
         GlobalFunc.SetText(Title_mc.Title_tf,m_PerkName.toUpperCase(),false);
         var _loc1_:Boolean = m_Selected || !m_MostlyHidden;
         if(m_VaultBoyImageName != this.m_LastVaultBoyImageName)
         {
            updateVaultBoyImage(_loc1_);
            this.m_LastVaultBoyImageName = _loc1_ ? m_VaultBoyImageName : "";
         }
      }
   }
}

