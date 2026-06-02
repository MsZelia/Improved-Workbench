package ExamineMenu_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol371")]
   public dynamic class NEWAnim_49 extends MovieClip
   {
      
      public function NEWAnim_49()
      {
         super();
         addFrameScript(0,this.frame1,6,this.frame7,25,this.frame26);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame7() : *
      {
         dispatchEvent(new Event("ExamineMenu::DisplayNextAttribute",true));
      }
      
      internal function frame26() : *
      {
         stop();
      }
   }
}

