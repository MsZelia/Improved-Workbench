package Shared.AS3
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.setTimeout;
   
   public class BSAsync extends EventDispatcher
   {
      
      public static const AWAIT_NEXT_FRAME:int = 0;
      
      public static const AWAIT_FRAME_LABEL:int = 1;
      
      public static const AWAIT_MILLISECONDS:int = 2;
      
      public function BSAsync()
      {
         super();
      }
      
      public static function Await(param1:MovieClip, param2:int, param3:Function, ... rest) : void
      {
         var nextFrameClosure:Function = null;
         var frameLabelClosure:Function = null;
         var aFuture:MovieClip = param1;
         var aType:int = param2;
         var aClosure:Function = param3;
         switch(aType)
         {
            case AWAIT_NEXT_FRAME:
               nextFrameClosure = function():*
               {
                  aFuture.removeEventListener(Event.ENTER_FRAME,nextFrameClosure);
                  aClosure();
               };
               aFuture.addEventListener(Event.ENTER_FRAME,nextFrameClosure);
               break;
            case AWAIT_FRAME_LABEL:
               frameLabelClosure = function():*
               {
                  if(aFuture.currentFrameLabel == rest[0])
                  {
                     aFuture.removeEventListener(Event.FRAME_CONSTRUCTED,frameLabelClosure);
                     aClosure();
                  }
               };
               aFuture.addEventListener(Event.FRAME_CONSTRUCTED,frameLabelClosure);
               break;
            case AWAIT_MILLISECONDS:
               setTimeout(aClosure,rest[0]);
               break;
            default:
               aClosure();
         }
      }
   }
}

