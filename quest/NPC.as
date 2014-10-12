/**
 * Autor: rastyslaw
 * Date: 04.03.14
 * Time: 12:02
 */
package by.candy.ui.quest
{
	public class NPC
	{
		private var _id:int;
		private var _title:String;
		private var _icon:String;
		private var _image:String;
		private var _photo:String;

		public function NPC(id:int, data:XMLList)
		{
			_id = id;
			_title = data.title == undefined ? "" : data.title;
			_icon = data.icon == undefined ? "quests_icons_candy" : data.icon;
			_image = data.image;
			_photo = data.photo;
		}

		public function get id():int
		{
			return _id;
		}

		public function get title():String
		{
			return _title;
		}

		public function get icon():String
		{
			return _icon;
		}

		public function get image():String
		{
			return _image;
		}

		public function get photo():String
		{
			return _photo;
		}
	}
}
