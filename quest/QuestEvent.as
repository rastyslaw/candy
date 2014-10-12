/**
 * Autor: rastyslaw
 * Date: 04.03.14
 * Time: 11:02
 */
package by.candy.ui.quest
{
import flash.events.Event;

public class QuestEvent extends Event
	{
		public static const ITEM_COLLECT:String = "itemCollect";
		public static const TIMER_UPDATE:String = "timerUpdate";

		private var _value:int;
		private var _url:String;

		public function QuestEvent(type:String, id:int, url:String = null, bubbles:Boolean=false, cancelable:Boolean = false) {
			_value = id;
			_url = url;
			super(type, bubbles, cancelable);
		}

		override public function clone():Event {
			return new QuestEvent(type, _value, _url, bubbles, cancelable);
		}

		public function get value():int
		{
			return _value;
		}

		public function get url():String
		{
			return _url;
		}
	}
}
