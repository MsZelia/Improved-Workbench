package Shared
{
   import Shared.AS3.BSScrollingListEntry;
   
   public class DummyEntryList extends UpdateEventList
   {
      
      protected var _addsDummyEntryOnBlankList:Boolean = false;
      
      protected var _addedDummyEntryOnBlankList:Boolean = false;
      
      protected var _dummyEntryText:String = "$None";
      
      protected var _blankEntryFillTarget:uint = 0;
      
      public function DummyEntryList()
      {
         super();
      }
      
      public function get addsDummyEntryOnBlankList() : Boolean
      {
         return this._addsDummyEntryOnBlankList;
      }
      
      public function set addsDummyEntryOnBlankList(param1:Boolean) : void
      {
         this._addsDummyEntryOnBlankList = param1;
      }
      
      public function get addedDummyEntryOnBlankList() : Boolean
      {
         return this._addedDummyEntryOnBlankList;
      }
      
      public function get dummyEntryText() : String
      {
         return this._dummyEntryText;
      }
      
      public function set dummyEntryText(param1:String) : void
      {
         this._dummyEntryText = param1;
      }
      
      public function get blankEntryFillTarget() : uint
      {
         return this._blankEntryFillTarget;
      }
      
      public function set blankEntryFillTarget(param1:uint) : void
      {
         this._blankEntryFillTarget = param1;
      }
      
      override public function UpdateList() : *
      {
         super.UpdateList();
         var _loc1_:Boolean = false;
         var _loc2_:uint = iListItemsShown;
         this._addedDummyEntryOnBlankList = false;
         if(iListItemsShown == 0 && this._addsDummyEntryOnBlankList)
         {
            this.AddDummyEntry();
            if(ScrollUp != null)
            {
               ScrollUp.visible = scrollPosition > 0;
            }
            if(ScrollDown != null)
            {
               ScrollDown.visible = scrollPosition < iMaxScrollPosition;
            }
            _loc1_ = true;
            _loc2_ = 1;
         }
         if(_loc2_ < this._blankEntryFillTarget)
         {
            this.AddBlankEntries(_loc2_);
            _loc1_ = true;
         }
         if(_loc1_)
         {
            PositionEntries();
         }
         bUpdated = true;
      }
      
      protected function AddBlankEntries(param1:uint) : void
      {
         var _loc2_:BSScrollingListEntry = null;
         var _loc3_:Object = {"text":""};
         var _loc4_:uint = param1;
         while(_loc4_ < this._blankEntryFillTarget)
         {
            _loc2_ = GetClipByIndex(_loc4_);
            if(_loc2_)
            {
               _loc2_.visible = true;
               _loc2_.SetEntryText(_loc3_,strTextOption);
            }
            _loc4_++;
         }
         iListItemsShown = this._blankEntryFillTarget;
      }
      
      protected function AddDummyEntry() : void
      {
         var _loc1_:BSScrollingListEntry = null;
         var _loc2_:Object = null;
         _loc1_ = GetClipByIndex(0);
         if(_loc1_)
         {
            _loc2_ = new Object();
            _loc2_["text"] = this._dummyEntryText;
            _loc1_.visible = true;
            _loc1_.selected = true;
            _loc1_.SetEntryText(_loc2_,strTextOption);
            this._addedDummyEntryOnBlankList = true;
            iListItemsShown = 1;
         }
      }
   }
}

