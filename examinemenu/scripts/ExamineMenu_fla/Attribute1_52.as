package ExamineMenu_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol367")]
   public dynamic class Attribute1_52 extends MovieClip
   {
      
      public var AttributeEffect_mc:MovieClip;
      
      public var AttributeText_mc:MovieClip;
      
      public function Attribute1_52()
      {
         super();
         addFrameScript(0,this.frame1,43,this.frame44);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame44() : *
      {
         dispatchEvent(new Event("ExamineMenu::DisplayNextAttribute",true));
         stop();
      }
   }
}

