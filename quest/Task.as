/**
 * Autor: rastyslaw
 * Date: 04.03.14
 * Time: 12:02
 */
package by.candy.ui.quest
{
import by.candy.CandyCore;
import by.candy.nameStorage.Names;
import by.candy.ui.goals.OrderColorsId;
import by.candy.ui.goals.OrderCombinationsId;
import by.candy.ui.goals.OrderFiguresId;
import by.signalengine.managers.DataManager;
import by.signalengine.managers.LocaleManager;

import com.candy.ffmatch3.game.model.common.stat.Settings;
import com.slavshik.utils.replaceStringValues;
import com.x10.gui.image.LoadableImage;

import flash.display.Sprite;
import flash.events.Event;

public class Task
	{
		private var _id:int;
		private var _count:int;
		private var _countFactor:int;
		private var _figureId:int;
		private var _colorId:int;
		private var _combinationId:int;
		private var _action:String;
		private var _text:String;
		private var _level:int;
		private var _progress:int;
		private var _icon:Sprite;
		private var _ticket:String;
		private var _ticketImageUrl:String;

		public function Task(data:XML)
		{
			_id = data.@id;
			_action = data.action;
			_ticket = data.ticket;
			_count = data.count;
			level = data.param;
			_countFactor = data.countFactor;
			_figureId = data.figureId;

			if(_figureId == 0){
				_figureId = OrderFiguresId.getRandomFigure();
			}

			if(_combinationId == 0){
				_combinationId = OrderCombinationsId.getRandomCombination();
			}

			if(_colorId == 0){
				_colorId = OrderColorsId.getRandomColor();
			}

			if(action == QuestType.PASS_LEVEL_ITEM){
				ticketImageUrl = getTicketImage(ticket);
			}

			_colorId = data.colorId;
			_combinationId = data.combinationId;
		}


		public function get id():int
		{
			return _id;
		}

		public function get count():int
		{
			return _count;
		}

		public function get action():String
		{
			return _action;
		}

		public function get text():String
		{
			return _text;
		}

		public function get level():int
		{
			return _level;
		}

		public function get countFactor():int
		{
			return _countFactor;
		}

		public function get combinationId():int
		{
			return _combinationId;
		}

		public function get colorId():int
		{
			return _colorId;
		}

		public function get figureId():int
		{
			return _figureId;
		}

		public function get progress():int
		{
			return _progress;
		}

		public function set progress(value:int):void
		{
//			switch(_action){
//				case QuestType.PASS_LEVEL:
//				case QuestType.PASS_LEVEL_NEXT:
//				case QuestType.PASS_LEVEL_RAND:
//				case QuestType.PASS_LEVEL_ITEM:
//					return;
//				break;
//			}
			_progress = value;
		}

		public function get icon():Sprite
		{
			return _icon;
		}

		public function set figureId(value:int):void
		{
			_figureId = value;
			_icon = QuestUtil.getFigureRenderer(_figureId);
		}

		public function set combinationId(value:int):void
		{
			_combinationId = value;
			_icon = QuestUtil.getCombinationRenderer(_combinationId);
		}

		public function set colorId(value:int):void
		{
			_colorId = value;
			_icon = QuestUtil.getColorRenderer(_colorId);
		}

		public function set count(value:int):void
		{
			_count = value;
		}

		public function set level(value:int):void
		{
			_level = value;
			_text = replaceStringValues(LocaleManager.instance.getString("ID_QUEST_" + _action), _level);
			if(_level > Settings.BONUS_LEVELS_START){
				_text = replaceStringValues(LocaleManager.instance.getString("ID_QUEST_" + _action + "_bonus"), _level - Settings.BONUS_LEVELS_START);
			}
		}

		public function get ticket():String
		{
			return _ticket;
		}

		public function get ticketImageUrl():String
		{
			return _ticketImageUrl;
		}

		private function getTicketImage(value: String):String
		{
			var xml:XML = DataManager.instance.getValue(Names.GAME_XML);
			return CandyCore.instance.flashVars["server_url"] + xml.game.tickets.ticket.(@id == value).@image;
		}

		public function set ticketImageUrl(value:String):void
		{
			_ticketImageUrl = value;
			_icon = new Sprite();
			var loadableImage:LoadableImage = new LoadableImage(_ticketImageUrl, true);
			loadableImage.addEventListener(LoadableImage.LOAD_COMPLETE, onloadableImageComplete);
		}

		private function onloadableImageComplete(event: Event):void
		{
			var loadableImage:LoadableImage = event.currentTarget as LoadableImage;
			loadableImage.removeEventListener(LoadableImage.LOAD_COMPLETE, onloadableImageComplete);
			loadableImage.bitmap.smoothing = true;
			loadableImage.imageLoader.x = 0;
			loadableImage.imageLoader.y = 0;  
			loadableImage.scaleX = loadableImage.scaleY = .3;
			_icon.addChild(loadableImage);
		}
	}
}
