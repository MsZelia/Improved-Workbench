package
{
   import Shared.AS3.BSScrollingListEntry;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol303")]
   public class DynamicModDescriptionEntry extends BSScrollingListEntry
   {
      
      public static var AdvancedModDescMode:Boolean = false;
      
      public var Arrow_mc:MovieClip;
      
      public var ValueText_mc:MovieClip;
      
      public var StatText_tf:TextField;
      
      private const SYMBOLS_MODE_SPACING:uint = 20;
      
      private const NUMBERS_MODE_SPACING:uint = 25;
      
      private const NUMBERS_VALUE_SPACING:uint = 5;
      
      private const TEXT_ONLY_MODE_SPACING:uint = 10;
      
      private const VALUE_TEXT_SPACING:uint = 3;
      
      public function DynamicModDescriptionEntry()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3);
      }
      
      override public function SetEntryText(param1:Object, param2:String) : *
      {
         var _loc3_:String = null;
         if(param1.isFlag)
         {
            gotoAndStop("textOnly");
         }
         else
         {
            gotoAndStop(AdvancedModDescMode ? "numbers" : "symbols");
         }
         this.StatText_tf.text = param1.displayName;
         Sizer_mc.x = 0;
         if(param1.isFlag)
         {
            Sizer_mc.width = this.StatText_tf.x + this.StatText_tf.textWidth + this.TEXT_ONLY_MODE_SPACING;
         }
         else if(AdvancedModDescMode)
         {
            _loc3_ = param1.value;
            _loc3_ = parseFloat(_loc3_) > 0 ? "+" + _loc3_ : _loc3_;
            _loc3_ = param1.isPercentage ? _loc3_ + "%" : _loc3_;
            this.ValueText_mc.gotoAndStop(param1.isPositive ? "blue" : "red");
            this.ValueText_mc.ValueText_tf.text = _loc3_;
            this.ValueText_mc.ValueText_tf.width = this.ValueText_mc.ValueText_tf.textWidth + this.VALUE_TEXT_SPACING;
            this.StatText_tf.x = this.ValueText_mc.ValueText_tf.textWidth + this.NUMBERS_VALUE_SPACING;
            Sizer_mc.width = this.ValueText_mc.ValueText_tf.textWidth + this.StatText_tf.textWidth + this.NUMBERS_MODE_SPACING;
         }
         else
         {
            if(parseFloat(param1.value) > 0)
            {
               this.Arrow_mc.gotoAndStop(param1.isPositive ? "GoodIncrease" : "BadIncrease");
            }
            else
            {
               this.Arrow_mc.gotoAndStop(param1.isPositive ? "GoodDecrease" : "BadDecrease");
            }
            Sizer_mc.width = this.Arrow_mc.width + this.StatText_tf.textWidth + this.SYMBOLS_MODE_SPACING;
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
      
      internal function frame3() : *
      {
         stop();
      }
   }
}

