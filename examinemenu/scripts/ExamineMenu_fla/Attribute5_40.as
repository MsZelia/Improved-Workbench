package ExamineMenu_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol358")]
   public dynamic class Attribute5_40 extends MovieClip
   {
      
      public var AttributeText_mc:MovieClip;
      
      public function Attribute5_40()
      {
         super();
         addFrameScript(0,this.frame1,82,this.frame83);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame83() : *
      {
         dispatchEvent(new Event("ExamineMenu::DisplayNextAttribute",true));
         stop();
      }
   }
}

