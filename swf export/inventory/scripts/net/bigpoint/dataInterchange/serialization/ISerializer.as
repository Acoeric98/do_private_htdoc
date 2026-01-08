package net.bigpoint.dataInterchange.serialization
{
   public interface ISerializer
   {
      
      function serialize(param1:Object) : String;
      
      function unserialize(param1:String) : *;
   }
}

