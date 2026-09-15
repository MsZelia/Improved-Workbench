package
{
   import Shared.AS3.BSAsync;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol377")]
   public class LegendaryCraftingFanfare extends MovieClip
   {
      
      public var NewAnim_mc:MovieClip;
      
      public var Attribute1_mc:MovieClip;
      
      public var Attribute2_mc:MovieClip;
      
      public var Attribute3_mc:MovieClip;
      
      public var Attribute4_mc:MovieClip;
      
      public var Attribute5_mc:MovieClip;
      
      public var TopAttribute2_mc:MovieClip;
      
      public var TopAttribute3_mc:MovieClip;
      
      public var TopAttribute4_mc:MovieClip;
      
      public var TopAttribute5_mc:MovieClip;
      
      private const FANFARE_DISPLAYED:String = "ExamineMenu::DisplayNextAttribute";
      
      private var m_AttributeClips:Vector.<MovieClip>;
      
      private var m_TopAttributeClips:Vector.<MovieClip>;
      
      private var m_AttributeText:Array;
      
      private var m_NextAttribute:uint = 0;
      
      private var m_ShardStarCount:uint = 0;
      
      private var m_IsLegendaryMod:Boolean = false;
      
      public function LegendaryCraftingFanfare()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,85,this.frame86);
         this.m_AttributeClips = new <MovieClip>[this.Attribute1_mc,this.Attribute2_mc,this.Attribute3_mc,this.Attribute4_mc,this.Attribute5_mc];
         this.m_TopAttributeClips = new <MovieClip>[this.Attribute1_mc,this.TopAttribute2_mc,this.TopAttribute3_mc,this.TopAttribute4_mc,this.TopAttribute5_mc];
         var _loc1_:* = this.m_AttributeClips.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            TextFieldEx.setTextAutoSize(this.m_TopAttributeClips[_loc2_].AttributeText_mc.Attribute_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            TextFieldEx.setTextAutoSize(this.m_AttributeClips[_loc2_].AttributeText_mc.Attribute_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
            _loc2_++;
         }
      }
      
      private function checkStarCount(param1:String) : int
      {
         var _loc2_:RegExp = /[¬]/g;
         return param1.match(_loc2_).length;
      }
      
      private function sortAttribute(param1:String, param2:String) : int
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = param1.indexOf("§") != -1;
         var _loc5_:* = param2.indexOf("§") != -1;
         if(_loc4_ && !_loc5_)
         {
            _loc3_ = 1;
         }
         else if(!_loc4_ && _loc5_)
         {
            _loc3_ = -1;
         }
         else
         {
            _loc6_ = this.checkStarCount(param1);
            _loc7_ = this.checkStarCount(param2);
            if(_loc6_ < _loc7_)
            {
               _loc3_ = -1;
            }
            else if(_loc6_ > _loc7_)
            {
               _loc3_ = 1;
            }
         }
         return _loc3_;
      }
      
      public function ShowFanfare(param1:String) : void
      {
         var _loc3_:int = 0;
         removeEventListener(this.FANFARE_DISPLAYED,this.displayNextAttribute);
         this.clearAnim();
         this.m_NextAttribute = 0;
         this.m_ShardStarCount = 0;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = int(param1.charCodeAt(_loc2_).toString(16));
            if(_loc3_ == -54)
            {
               ++this.m_ShardStarCount;
            }
            else if(_loc3_ == 20 || _loc3_ == 0)
            {
               break;
            }
            _loc2_++;
         }
         this.m_IsLegendaryMod = this.m_ShardStarCount > 0;
         if(this.m_IsLegendaryMod)
         {
            this.m_AttributeText = new Array(1);
            this.m_AttributeText[0] = param1.slice(this.m_ShardStarCount + 1,param1.length);
         }
         else
         {
            this.m_AttributeText = param1.split(/\r|\n/);
            if(this.m_AttributeText[this.m_AttributeText.length - 1] == "")
            {
               this.m_AttributeText.pop();
            }
            this.m_AttributeText.sort(this.sortAttribute);
         }
         if(this.m_AttributeText.length > 0 && this.m_AttributeText[0] != "")
         {
            addEventListener(this.FANFARE_DISPLAYED,this.displayNextAttribute);
            gotoAndPlay("rollOn");
            this.NewAnim_mc.gotoAndPlay("rollOn");
         }
      }
      
      private function getCurrentAttribute() : MovieClip
      {
         var _loc1_:MovieClip = null;
         if(this.m_ShardStarCount > 0 && this.m_ShardStarCount - 1 < this.m_TopAttributeClips.length)
         {
            _loc1_ = this.m_TopAttributeClips[this.m_ShardStarCount - 1];
         }
         else if(this.m_ShardStarCount == 0 && this.m_NextAttribute < this.m_AttributeClips.length && this.m_NextAttribute < this.m_AttributeText.length)
         {
            _loc1_ = this.m_AttributeClips[this.m_NextAttribute];
         }
         return _loc1_;
      }
      
      private function displayNextAttribute(param1:Event) : void
      {
         var currentAttributeClip:MovieClip = null;
         var aEvent:Event = param1;
         currentAttributeClip = this.getCurrentAttribute();
         if(currentAttributeClip)
         {
            BSAsync.Await(currentAttributeClip,BSAsync.AWAIT_FRAME_LABEL,function():*
            {
               var _loc1_:int = m_IsLegendaryMod ? int(m_ShardStarCount - 1) : int(m_NextAttribute);
               GlobalFunc.PlayMenuSound("UIFanfareLegendaryCrafted0" + _loc1_);
               currentAttributeClip.AttributeText_mc.Attribute_tf.text = m_AttributeText[m_IsLegendaryMod ? 0 : _loc1_];
               currentAttributeClip.AttributeEffect_mc.visible = m_IsLegendaryMod || checkStarCount(m_AttributeText[_loc1_]) > 0;
               if(m_IsLegendaryMod)
               {
                  m_ShardStarCount = m_TopAttributeClips.length + 1;
               }
               else
               {
                  ++m_NextAttribute;
               }
            },"rollOn");
            currentAttributeClip.gotoAndPlay("rollOn");
         }
         else
         {
            gotoAndPlay("rollOff");
            removeEventListener(this.FANFARE_DISPLAYED,this.displayNextAttribute);
         }
      }
      
      private function clearAnim() : void
      {
         gotoAndStop("off");
         this.NewAnim_mc.gotoAndStop("off");
         var _loc1_:* = 0;
         while(_loc1_ < this.m_AttributeClips.length)
         {
            this.m_AttributeClips[_loc1_].gotoAndStop("off");
            this.m_TopAttributeClips[_loc1_].gotoAndStop("off");
            _loc1_++;
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
      
      internal function frame86() : *
      {
         gotoAndStop("off");
         this.NewAnim_mc.gotoAndStop("off");
         this.Attribute1_mc.gotoAndStop("off");
         this.Attribute2_mc.gotoAndStop("off");
         this.Attribute3_mc.gotoAndStop("off");
         this.Attribute4_mc.gotoAndStop("off");
         this.Attribute5_mc.gotoAndStop("off");
         this.Attribute2_mc.gotoAndStop("off");
         this.Attribute3_mc.gotoAndStop("off");
         this.Attribute4_mc.gotoAndStop("off");
         this.Attribute5_mc.gotoAndStop("off");
      }
   }
}

