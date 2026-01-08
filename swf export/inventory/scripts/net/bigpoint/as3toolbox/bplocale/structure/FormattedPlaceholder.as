package net.bigpoint.as3toolbox.bplocale.structure
{
   public class FormattedPlaceholder extends Placeholder
   {
      
      private var _format:Placeholder;
      
      public function FormattedPlaceholder()
      {
         super();
      }
      
      public function get format() : Placeholder
      {
         return this._format;
      }
      
      public function set format(param1:*) : void
      {
         if(param1 is Placeholder)
         {
            this._format = param1;
            return;
         }
         if(param1 is String)
         {
            this._format = Placeholder.convertToPlaceholder(param1);
            return;
         }
         throw new Error(param1 + " is neither a Placeholder, nor a String.");
      }
      
      override public function link() : void
      {
         super.link();
         if(this._format !== null)
         {
            this._format.link();
         }
      }
   }
}

