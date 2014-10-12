/**
 * Autor: rastyslaw
 * Date: 27.02.14
 * Time: 12:50
 */
package by.candy.ui.actions
{
	public class Offer
	{
		private var _id:int;
		private var _title:String;
		private var _description:String;
		private var _img:String;
		private var _bonus:int;
		private var _icon:String;

		public function Offer(obj:Object) {
			_id = obj.id;
			_title = obj.title;
			_description = obj.description;
			_img = obj.img;
			_bonus = obj.bonus;
			_icon = obj.icon;
		}

		public function get id():int
		{
			return _id;
		}

		public function get title():String
		{
			return _title;
		}

		public function get description():String
		{
			return _description;
		}

		public function get img():String
		{
			return _img;
		}

		public function get bonus():int
		{
			return _bonus;
		}

		public function get icon():String
		{
			return _icon;
		}
	}
}