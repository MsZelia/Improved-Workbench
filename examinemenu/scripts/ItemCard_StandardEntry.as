package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol119")]
   public dynamic class ItemCard_StandardEntry extends ItemCard_Entry
   {
      
      public function ItemCard_StandardEntry()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3);
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

