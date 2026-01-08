package com.bigpoint.filecollection.finish
{
   import com.bigpoint.filecollection.vo.FileVO;
   
   public class XMLFinisher extends FileCollectionFinisher
   {
      
      public function XMLFinisher()
      {
         super();
      }
      
      override public function start(param1:FileVO) : void
      {
         super.start(param1);
         finish();
      }
      
      public function getXML() : XML
      {
         return new XML(fileVO.data);
      }
   }
}

