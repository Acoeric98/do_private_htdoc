package org.puremvc.as3.patterns.command
{
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.interfaces.INotifier;
   import org.puremvc.as3.patterns.observer.Notifier;
   
   public class MacroCommand extends Notifier implements ICommand, INotifier
   {
      
      private var subCommands:Array;
      
      public function MacroCommand()
      {
         super();
         subCommands = new Array();
         initializeMacroCommand();
      }
      
      final public function execute(param1:INotification) : void
      {
         var _loc2_:Class = null;
         var _loc3_:ICommand = null;
         while(subCommands.length > 0)
         {
            _loc2_ = subCommands.shift();
            _loc3_ = new _loc2_();
            _loc3_.execute(param1);
         }
      }
      
      protected function addSubCommand(param1:Class) : void
      {
         subCommands.push(param1);
      }
      
      protected function initializeMacroCommand() : void
      {
      }
   }
}

