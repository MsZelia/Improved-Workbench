package ExamineMenu_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol362")]
   public dynamic class Attribute1_48 extends MovieClip
   {
      
      public var AttributeText_mc:MovieClip;
      
      public function Attribute1_48()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,43,this.frame44);
      }
      
      internal function frame1() : *
      {
         trace("stop");
         stop();
      }
      
      internal function frame2() : *
      {
         trace("rollon");
      }
      
      internal function frame44() : *
      {
         dispatchEvent(new Event("ExamineMenu::DisplayNextAttribute",true));
         stop();
      }
   }
}

