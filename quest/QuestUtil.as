/**
 * Autor: rastyslaw
 * Date: 04.03.14
 * Time: 12:02
 */
package by.candy.ui.quest
{
import by.candy.nameStorage.GraphNames;
import by.candy.nameStorage.Names;
import by.candy.ui.goals.OrderColorsId;
import by.candy.ui.goals.OrderCombinationsId;
import by.candy.ui.goals.OrderFiguresId;
import by.signalengine.managers.DataManager;

import com.x10.ResourceManager;

import flash.display.Bitmap;
import flash.display.Sprite;

public class QuestUtil
	{
		private static var _instance:QuestUtil;
		private var _dm:DataManager;
		private var _gameXML:XML;

		public static function getInstance():QuestUtil
		{
			if (_instance == null)
			{
				_instance = new QuestUtil();
			}
			return _instance;
		}


		public function QuestUtil()
		{
			_dm = DataManager.instance;
			_gameXML = _dm.getValue(Names.GAME_XML);
		}

		public function getQuestXML(id:int):XML
		{
			var figuresXML:XMLList = _gameXML.questFigures.figure;
			for each (var xml:XML in figuresXML)
			{
				if (int(xml.@id) == id)
				{
					return xml;
				}
			}
			return null;
		}

		public static function random(min:Number, max: Number): int
		{
			return min +  Math.random() * max;
		}

		public static function getColorRenderer(color:int):Sprite
		{
			var mc:Sprite = new Sprite();
			var bmp:Bitmap;
			var bmpAdd:Bitmap;

			switch (color)
			{
				case OrderColorsId.ANY:
					bmp = ResourceManager.instance.getResourceByName("exp1");
				break;

				case OrderColorsId.RED:
					bmp = ResourceManager.instance.getTextureTile("sc_0020_Red-Candy-01.png");
				break;

				case OrderColorsId.BLUE:
					bmp = ResourceManager.instance.getTextureTile("sc_0022_Blue-candy-01.png");
				break;

				case OrderColorsId.GREEN:
					bmp = ResourceManager.instance.getTextureTile("sc_0024_Layer-1.png");
				break;

				case OrderColorsId.PURPLE:
					bmp = ResourceManager.instance.getTextureTile("sc_0019_Purple-Candy-01.png");
				break;

				case OrderColorsId.YELLOW:
					bmp = ResourceManager.instance.getTextureTile("sc_0023_Layer-2.png");
				break;

				case OrderColorsId.ORANGE:
					bmp = ResourceManager.instance.getTextureTile("sc_0021_E02-copy.png");
				break;
			}

			if (bmp != null)
			{
				mc.addChild(bmp);
				if (bmpAdd != null)
				{
					mc.addChild(bmpAdd);
				}
			}

			return mc;
		}

		public static function getFigureRenderer(figure:int):Sprite
		{
			var mc:Sprite = new Sprite();
			var bmp:Bitmap;
			var bmpAdd:Bitmap;

			switch (figure)
			{
				case OrderFiguresId.TWIST:
					bmp = ResourceManager.instance.getTextureTile("task_twist");
				break;

				case OrderFiguresId.BEAR:
					bmp = ResourceManager.instance.getTextureTile("task_bear");
				break;

				case OrderFiguresId.JOKER:
					bmp = ResourceManager.instance.getTextureTile("task_rainbow");
				break;
			}

			if (bmp != null)
			{
				mc.addChild(bmp);
				if (bmpAdd != null)
				{
					mc.addChild(bmpAdd);
				}
			}
			return mc;
		}

		public static function getCombinationRenderer(combination:int):Sprite
		{
			var mc:Sprite = new Sprite();
			var bmp:Bitmap;
			var bmpAdd:Bitmap;

			switch (combination)
			{
				case OrderCombinationsId.TWIST_TWIST:
					bmp = ResourceManager.instance.getTextureTile("task_twist");
					bmpAdd = ResourceManager.instance.getTextureTile("task_twist");
				break;

				case OrderCombinationsId.BEAR_TWIST:
					bmp = ResourceManager.instance.getTextureTile("task_twist");
					bmpAdd = ResourceManager.instance.getTextureTile("task_bear");
				break;

				case OrderCombinationsId.JOKER_TWIST:
					bmp = ResourceManager.instance.getTextureTile("task_twist");
					bmpAdd = ResourceManager.instance.getTextureTile("task_rainbow");
				break;

				case OrderCombinationsId.BEAR_BEAR:
					bmp = ResourceManager.instance.getTextureTile("task_bear");
					bmpAdd = ResourceManager.instance.getTextureTile("task_bear");
				break;

				case OrderCombinationsId.JOKER_BEAR:
					bmp = ResourceManager.instance.getTextureTile("task_bear");
					bmpAdd = ResourceManager.instance.getTextureTile("task_rainbow");
				break;

				case OrderCombinationsId.JOKER_JOKER:
					bmp = ResourceManager.instance.getTextureTile("task_rainbow");
					bmpAdd = ResourceManager.instance.getTextureTile("task_rainbow");
				break;
			}

			if (bmp != null)
			{
				bmp.x = 0;
				mc.addChild(bmp);
				if (bmpAdd != null)
				{
					var plus:Bitmap =  ResourceManager.instance.getResourceByName(GraphNames.PLUS);
					mc.addChild(plus);
					plus.x = bmp.x + bmp.width - plus.width/2;
					plus.y = (mc.height - plus.height)/2;
					bmpAdd.x = plus.x + plus.width/2;
					mc.addChildAt(bmpAdd, 0);
				}
			}

			return mc;
		}
	}
}
