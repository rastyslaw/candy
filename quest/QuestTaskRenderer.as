/**
 * Autor: rastyslaw
 * Date: 04.03.14
 * Time: 12:02
 */
package by.candy.ui.quest
{
import by.candy.nameStorage.GraphNames;

import com.candy.ffmatch3.game.model.common.stat.Settings;
import com.x10.ResourceManager;
import com.x10.gui.Label;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.geom.Rectangle;

import flashx.textLayout.formats.TextAlign;

import org.bytearray.display.ScaleBitmap;

public class QuestTaskRenderer extends Sprite
	{
		public static const TASK_LIMIT:int = 4;

		private var WIDTH_ITEM:int = 370;
		private var HEIGHT_ITEM:int = 50;
		private var MAX_HEIGHT_ICON:int = 34;
		private var startPositionX:int = 5;
		private var _numItem:int;

		public function QuestTaskRenderer(tasks:Vector.<Task>)
		{
			var i:int;
			var task:Task
			for each (task in tasks){
				if(task.icon != null){
					startPositionX = 70;
					break;
				}
				i++;
				if(i == TASK_LIMIT) break;
			}
			for each (task in tasks){
				if(task.action == QuestType.PASS_LEVEL_ITEM){
					startPositionX = 70;
				}
				createItem(task.text, task.progress, task.count, task.icon, _numItem);
				_numItem++;
				if(_numItem == TASK_LIMIT) return;
			}
		}

		private function createMask(clip:Sprite, x:Number, y:Number):void
		{
			clip.graphics.beginFill(0, 0);
			clip.graphics.drawRect(x, y, WIDTH_ITEM, HEIGHT_ITEM);
			clip.graphics.endFill();
		}

		private function createItem(text:String, count:int, total:int, icon:Sprite, childIndex:int):void
		{
			var mc:Sprite = new Sprite();
			createMask(mc, mc.x, mc.y);

			var iconCont:Sprite = new Sprite();
			if(icon != null){
				if(icon.height > MAX_HEIGHT_ICON){
					icon.scaleX = icon.scaleY = MAX_HEIGHT_ICON/icon.height;
				}

				var iconBM:Bitmap = ResourceManager.instance.getResourceByName(GraphNames.QUEST_TASKS_BG);
				iconCont.addChild(iconBM);

				icon.x = (iconCont.width - icon.width) * .5;
				icon.y = (iconCont.height - icon.height) * .5;
				iconCont.addChild(icon);

				mc.addChild(iconCont);
				iconCont.x = (startPositionX - iconCont.width) * .5;
			}
			var label:Label = new Label(text, 18, 0xffffff, 0, TextAlign.LEFT);
			label.x = startPositionX;
			mc.addChild(label);

			label.filters = [Settings.dsFilter];

			mc.x = 10;
			mc.y = childIndex * HEIGHT_ITEM;

			var tasks:Sprite = new Sprite();

			if(count < total){ 
				var tasksBmp:Bitmap = ResourceManager.instance.getResourceByName(GraphNames.RAITNUM);
				var taslsBM:Bitmap = new ScaleBitmap(tasksBmp.bitmapData);
				taslsBM.scale9Grid = new Rectangle(20, 20, 1, 1);
				taslsBM.width = 70;
				tasks.addChild(taslsBM);

				var taskLabel:Label = new Label(count + "/" + total, 16, 0xffffff);
				taskLabel.x = (tasks.width - taskLabel.width) * .5;
				taskLabel.y = (tasks.height - taskLabel.height) * .5;
				tasks.addChild(taskLabel);
				taskLabel.filters = [new DropShadowFilter(1, 45, 0x000000, .6)];

				tasks.x = WIDTH_ITEM - tasks.width - 15;
			} else {
				var checkBmp:Bitmap = ResourceManager.instance.getResourceByName(GraphNames.CHECK3);
				checkBmp.smoothing = true;
				tasks.addChild(checkBmp);
				label.textField.textColor = 0xE7F3A3;
				tasks.x = WIDTH_ITEM - tasks.width - 20;
			}


			var backBitmap:Bitmap = ResourceManager.instance.getResourceByName(GraphNames.QUEST_BACK_TAST);
			var back:Bitmap = new ScaleBitmap(backBitmap.bitmapData);
			back.scale9Grid = new Rectangle(20, 20, 1, 1);
			back.x = mc.x;
			back.y = mc.y;
			back.height = mc.height;
			addChildAt(back, 0);

			label.y = (back.height - label.height) * .5;
			if(iconCont != null){
				iconCont.y = (mc.height - iconCont.height) * .5 + 3;
			}

			tasks.y = (mc.height - tasks.height) * .5;
			mc.addChild(tasks);

			addChild(mc);
		}

		public function get numItem():int
		{
			return _numItem;
		}
	}
}
