package net.bigpoint.dataInterchange.serialization
{
   import mx.utils.Base64Decoder;
   import mx.utils.Base64Encoder;
   import org.puremvc.as3.patterns.mediator.Mediator;
   
   public class JSONSerializer extends Mediator implements ISerializer
   {
      
      private var encodingEnabled:Boolean = true;
      
      public function JSONSerializer()
      {
         super();
      }
      
      public function serialize(param1:Object) : String
      {
         var _loc3_:Base64Encoder = null;
         var _loc2_:String = JSON.stringify(param1);
         if(this.encodingEnabled)
         {
            _loc3_ = new Base64Encoder();
            _loc3_.encode(_loc2_);
            _loc2_ = _loc3_.toString();
         }
         return _loc2_;
      }
      
      public function unserialize(param1:String) : *
      {
         var decoder:Base64Decoder = null;
         var data:String = param1;
         try
         {
            if(this.encodingEnabled)
            {
               decoder = new Base64Decoder();
               decoder.decode(data);
               data = String(decoder.toByteArray());
            }
            return JSON.parse(data);
         }
         catch(e:Error)
         {
            return null;
         }
      }
   }
}

