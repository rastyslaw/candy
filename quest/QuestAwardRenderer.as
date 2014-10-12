/**
 * Autor: rastyslaw
 * Date: 04.03.14
 * Time: 12:02
 */
package by.candy.ui.quest
{
import by.candy.nameStorage.GraphNames;

import com.x10.ResourceManager;
import com.x10.gui.Label;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;

public class QuestAwardRenderer extends Sprite
	{
		private var WIDTH_ITEM:int = 130;
		private var HEIGHT_ITEM:int = 80;
		private const GAPX:int = 20;

		private var _rm:ResourceManager;
		private var _index:int;

		public function QuestAwardRenderer(awardXML:XMLList)
		{
			_rm = ResourceManager.instance;

			for each (var xml:XML in awardXML)
			{
				var type:String = xml.@type;
				var count:String = xml.@count;
				switch (type)
				{
					case QuestAward.MONEY:
						getAwardRenderer(_rm.getResourceByName(GraphNames.BIG_GOLD), count, .8);
						break;
					case QuestAward.BONUS:
						getAwardRenderer(_rm.getBitmap("gui", "bns" + xml.@id), count, .8);
						break;
					case QuestAward.BOOSTER:
						getAwardRenderer(_rm.getBitmap("gui", "bst" + xml.@id), count, .8);
						break;
					case QuestAward.LIFE:
						getAwardRenderer(_rm.getBitmap("gui", GraphNames.HEART), count);
						break;
				}
			}

			x = -int(width / 2);
			y = -int(height / 2);
		}

		private function createMask(clip:Sprite, x:Number, y:Number):void
		{
			clip.graphics.beginFill(0, 0);
			clip.graphics.drawRect(x, y, WIDTH_ITEM, HEIGHT_ITEM);
			clip.graphics.endFill();
		}

		private function getAwardRenderer(bm:Bitmap, count:String, scale:Number = 1):void
		{
			var mc:Sprite = new Sprite();
			createMask(mc, mc.x, mc.y);

			if (scale != 1)
			{
				bm.smoothing = true;
				bm.scaleX = bm.scaleY = scale;
			}

			var item:Sprite = new Sprite();

			var label:Label = new Label(count, 36, 0xAC530E);
			label.filters = [new GlowFilter(0xF4F5FB, 1, 6, 6, 6), new DropShadowFilter(1, 45)];
			item.addChild(label);

			var countLabel:Label = new Label("x", 24, 0xAC530E);
			countLabel.filters = [new GlowFilter(0xF4F5FB, 1, 6, 6, 6), new DropShadowFilter(1, 45)];
			countLabel.x = item.width;
			countLabel.y = item.height - countLabel.height - 5;
			item.addChild(countLabel);

			bm.x = int((mc.width - bm.width) / 2);
			bm.y = int((mc.height - bm.height) / 2);
			mc.addChild(bm);
			bm.x = item.width/2;

			mc.addChild(item);
			item.rotation = -10;
			item.y = 22;

			mc.x = _index * 100 + _index * GAPX;

			addChild(mc);
			_index++;
		}

	}
}
