package net.bigpoint.as3toolbox.bplocale.structure
{
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class ReferencePlaceholder extends Placeholder
   {
      
      private var _static:Boolean = false;
      
      private var _quantity:* = null;
      
      private var _reference:Object;
      
      public function ReferencePlaceholder()
      {
         super();
      }
      
      public function get quantity() : *
      {
         return this._quantity;
      }
      
      public function set quantity(param1:*) : void
      {
         this._quantity = Placeholder.parseIntParameter(param1);
         if(this._quantity is int)
         {
            this._static = true;
         }
      }
      
      public function get reference() : Object
      {
         return this._reference;
      }
      
      public function set reference(param1:Object) : void
      {
         this._reference = param1;
      }
      
      override public function link() : void
      {
         var _loc1_:String = null;
         var _loc2_:Item = null;
         super.link();
         if(!this._static && this._quantity is Placeholder)
         {
            (this._quantity as Placeholder).link();
         }
         if(this._reference is String)
         {
            _loc1_ = this._reference as String;
            _loc2_ = BPLocale.getItemObject(_loc1_);
            if(this._static)
            {
               this._reference = _loc2_.getContent(this._quantity);
            }
            else
            {
               this._reference = _loc2_;
            }
         }
      }
      
      override public function getText(param1:Dictionary) : String
      {
         var _loc2_:Item = null;
         if(this._reference is Content)
         {
            return (this._reference as Content).getText(param1);
         }
         if(this._reference is Item)
         {
            _loc2_ = this._reference as Item;
            if(this._quantity == null)
            {
               return _loc2_.getContent(param1,param1[SystemPlaceholder.SYSTEM_QUANTITY]);
            }
            return _loc2_.getContent(param1,retrieveIntParameter(this._quantity,param1));
         }
         throw new Error("Couldn\'t resolve reference " + this._reference + " of ReferencePlaceholder " + name + ".");
      }
   }
}

