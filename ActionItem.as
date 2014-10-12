/**
 * Autor: rastyslaw
 * Date: 04.03.14
 * Time: 11:44
 */
package by.candy.ui.actions
{
	public class ActionItem
	{
		private var _data:*;
		private var _type:String;
		private var _showArrow:Boolean;
		private var _index:int;
		private var _complete:Boolean;
		private var _tween:Boolean;
		private var _content:AbstractActionIcon;
		private var _hidden:Boolean;
		private var _location:String;

		public function ActionItem(type:String, index:int, data:* = null, showArrow:Boolean = false, tween:Boolean = false, location:String = ActionLocationId.RIGHT, hidden:Boolean = false)
		{
			_type = type;
			_data = data;
			_index = index;
			_showArrow = showArrow;
			_tween = tween;
			_location = location;
			_hidden = hidden;
		}

		public function get data():*
		{
			return _data;
		}

		public function set data(value:*):void
		{
			_data = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function get showArrow():Boolean
		{
			return _showArrow;
		}

		public function get index():int
		{
			return _index;
		}

		public function get complete():Boolean
		{
			return _complete;
		}

		public function set complete(value:Boolean):void
		{
			_complete = value;
		}

		public function get tween():Boolean
		{
			return _tween;
		}

		public function get content():AbstractActionIcon
		{
			return _content;
		}

		public function set content(value:AbstractActionIcon):void
		{
			_content = value;
		}

		public function get location():String
		{
			return _location;
		}

		public function get hidden():Boolean
		{
			return _hidden;
		}
	}
}
