package ExamineMenu_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol361")]
   public dynamic class Attribute2_47 extends MovieClip
   {
      
      public var AttributeText_mc:MovieClip;
      
      public function Attribute2_47()
      {
         super();
         addFrameScript(0,this.frame1,59,this.frame60,62,this.frame63);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame60() : *
      {
         dispatchEvent(new Event("ExamineMenu::DisplayNextAttribute",true));
      }
      
      internal function frame63() : *
      {
         stop();
      }
   }
}

