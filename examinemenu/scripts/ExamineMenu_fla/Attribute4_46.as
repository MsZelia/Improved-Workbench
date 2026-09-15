package ExamineMenu_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol361")]
   public dynamic class Attribute4_46 extends MovieClip
   {
      
      public var AttributeEffect_mc:MovieClip;
      
      public var AttributeText_mc:MovieClip;
      
      public function Attribute4_46()
      {
         super();
         addFrameScript(0,this.frame1,73,this.frame74);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame74() : *
      {
         dispatchEvent(new Event("ExamineMenu::DisplayNextAttribute",true));
         stop();
      }
   }
}

