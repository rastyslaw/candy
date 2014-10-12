/**
 * Autor: rastyslaw
 * Date: 04.03.14
 * Time: 11:02
 */
package by.candy.ui.actions
{
import flash.events.Event;

public class ActionEvent extends Event
	{
		public static const ACTION_COMPLETE:String = "actionComplete";
		public static const QUEST_COMPLETE:String = "questComplete";
		public var _id:int;

		public function ActionEvent(type:String, id:int, bubbles:Boolean=false, cancelable:Boolean = false) {
			_id = id;
			super(type, bubbles, cancelable);
		}

		override public function clone():Event {
			return new ActionEvent(type, _id,  bubbles, cancelable);
		}

	}
}
