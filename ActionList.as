/**
 * Autor: rastyslaw
 * Date: 04.03.14
 * Time: 11:09
 */
package by.candy.ui.actions
{
import caurina.transitions.Tweener;

import flash.display.Sprite;

public class ActionList implements IListContainer
	{
		private const GAPY:int = 10;
		private const DEFAULT_HEGHT_ITEM:int = 135
		private var _mc:Sprite;
		private var _arr:Vector.<AbstractActionIcon>;

		public function ActionList()
		{
			_mc = new Sprite();
			_arr = new Vector.<AbstractActionIcon>();
		}

		public function addIcon(icon:AbstractActionIcon):void
		{
			_arr.push(icon);

			icon.alpha = 0;
			_mc.addChild(icon);

			Tweener.removeTweens(icon);
			Tweener.addTween(icon, {
				time: .5,
				alpha: 1,
				transition: "easeOutCubic"
			});
		}

		public function removeIcon(icon:AbstractActionIcon):void
		{
			var index:int = _arr.indexOf(icon);
			if(index == -1){
				return;
			}
			_arr.splice(index, 1);

			Tweener.removeTweens(icon);
			Tweener.addTween(icon, {
				time: .5,
				alpha: 0,
				transition: "easeOutCubic",
				onComplete: onRemoveComplete,
				onCompleteParams: [icon]
			});
		}

		private function sortingFunction(itemA:AbstractActionIcon, itemB:AbstractActionIcon):int
		{
			if (itemA.item.index < itemB.item.index) {
				return -1;                                              //ITEM A is before ITEM B
			} else if (itemA.item.index > itemB.item.index) {
				return 1;                                               //ITEM A is after ITEM B
			}  else {
				return 0;                                               //ITEM A and ITEM B have same date
			}
		}

//		public function getIconY(value:int):Number
//		{
//			return value * GAP;
//		}

		public function align():void
		{
			var icon:AbstractActionIcon;
			var cumulativeHeight:Number = 20;
			_arr.sort(sortingFunction);

			for (var i:int = 0; i < _arr.length; i++)
			{
				icon = _arr[i];
				Tweener.removeTweens(icon);
				Tweener.addTween(icon, {
					time: .5,
					delay: .5,
					alpha: 1,
					y: cumulativeHeight,
					transition: "easeOutCubic"
				});
				cumulativeHeight += GAPY;
				cumulativeHeight += DEFAULT_HEGHT_ITEM;
			}
		}

		private function onRemoveComplete(icon:AbstractActionIcon):void
		{
			_mc.removeChild(icon);
		}

		public function get length():int
		{
			return _arr.length;
		}

		public function getIconAt(i:int):AbstractActionIcon
		{
			return _arr[i];
		}

		public function get mc():Sprite
		{
			return _mc;
		}
	}
}
