package Shared.AS3.Styles
{
   import Shared.AS3.BSScrollingList;
   
   public class ExamineMenu_CurrentModListStyle
   {
      
      public static var listEntryClass_Inspectable:String = "CurrentModListEntry";
      
      public static var numListItems_Inspectable:uint = 10;
      
      public static var textOption_Inspectable:String = BSScrollingList.TEXT_OPTION_SHRINK_TO_FIT;
      
      public static var restoreListIndex_Inspectable:Boolean = false;
      
      public static var verticalSpacing_Inspectable:Number = 0.5;
       
      
      public function ExamineMenu_CurrentModListStyle()
      {
         super();
      }
   }
}
