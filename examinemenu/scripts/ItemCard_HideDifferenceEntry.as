package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol258")]
   public class ItemCard_HideDifferenceEntry extends ItemCard_Entry
   {
      
      public function ItemCard_HideDifferenceEntry()
      {
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3);
         super();
      }
      
      override public function PopulateEntry(param1:Object) : *
      {
         if(totalFrames > 1)
         {
            gotoAndStop(param1.difference != 0 ? (param1.difference > 0 ? "good" : "bad") : "default");
         }
         super.PopulateEntry(param1);
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

