/**
 * Autor: rastyslaw
 * Date: 04.03.14
 * Time: 12:02
 */
package by.candy.ui.actions
{
	import by.candy.CandyCore;
	import by.candy.TooltipController;
	import by.signalengine.managers.DataManager;

	import caurina.transitions.Tweener;

	import com.candy.ffmatch3.field.model.tutor.actions.base.HintArrow;
	import com.x10.ResourceManager;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	public class AbstractActionIcon extends Sprite
	{
		public static const TIME_ARROW:int = 4;
		public static const BORDER_SIZE:int = 50;

		private var _item:ActionItem;
		private var _arrow:HintArrow;
		private var _rm:ResourceManager;

		public var isTime:Boolean;

		protected var _check:Bitmap;
		protected var _container:Sprite;
		protected var _tooltipController:TooltipController;
		protected var tooltipText:String;
		protected var _dataManager:DataManager;
		protected var _core:CandyCore;
		protected var _rotateTimer:Timer;

		public function AbstractActionIcon(item:ActionItem)
		{
			_dataManager = DataManager.instance;
			_core = CandyCore.instance;
			initContainer(item);
			init();
			createHide();
			createArrow();
			updateCheck();
			createTween();
			createTooltip();
		}

		private function initContainer(item:ActionItem):void
		{
			_item = item;

			_container = new Sprite();
			createMask();
			addChild(_container);
			initRotatingGlow();
			buttonMode = true;
			//mouseChildren = false;
			_rm = ResourceManager.instance;
			addEventListener(MouseEvent.CLICK, onClickAction);
		}

		protected function initRotatingGlow():void
		{
			_rotateTimer = new Timer(30);
			_rotateTimer.addEventListener(TimerEvent.TIMER, onRotate);
			_rotateTimer.start();
		}

		protected function onRotate(event:TimerEvent):void
		{

		}

		private function createHide():void
		{
			if (_item.hidden)
			{
				_container.x += _container.width * .5;
				_container.addEventListener(MouseEvent.MOUSE_OVER, showContainer);
				_container.addEventListener(MouseEvent.MOUSE_OUT, hideContainer);
			}
		}

		private function showContainer(event:MouseEvent):void
		{
			Tweener.removeTweens(_container);
			_container.rotation = 0;
			Tweener.addTween(_container, {time: .5, x: 0, transition: "easeInOutCubic"});
		}

		private function hideContainer(event:MouseEvent):void
		{
			Tweener.removeTweens(_container);
			_container.rotation = 0;
			Tweener.addTween(_container, {time: .5, x: _container.width * .5, transition: "easeInOutCubic"});
		}

		protected function createMask():void
		{
			_container.graphics.beginFill(0, 0);
			_container.graphics.drawRect(-BORDER_SIZE, -BORDER_SIZE, 2 * BORDER_SIZE, 2 * BORDER_SIZE);
			_container.graphics.endFill();
		}

		private function createTooltip():void
		{
			if (tooltipText == null)
			{
				return;
				//throw new IllegalOperationError("Abstract method must be overridden in a subclass");
			}
			_tooltipController = new TooltipController(_container, tooltipText, _item.location == ActionLocationId.RIGHT ? ActionLocationId.LEFT : ActionLocationId.RIGHT, "", new Point(BORDER_SIZE, BORDER_SIZE));
		}

		protected function init():void
		{
			throw new IllegalOperationError("Abstract method must be overridden in a subclass");
		}

		protected function createTween():void
		{
			if (item.tween)
			{
				Tweener.addCaller(_container, {delay: 4, time: Math.random() * 10, count: 1, transition: "linear", onComplete: addTween});
			}
		}

		public function addTween():void
		{
			Tweener.removeTweens(_container);
			Tweener.addTween(_container, {time: .3, rotation: 5, transition: "easeInOutCubic"});
			Tweener.addTween(_container, {delay: .3, time: .3, rotation: -5, transition: "easeInOutCubic"});
			Tweener.addTween(_container, {delay: .6, time: .3, rotation: 0, transition: "easeInOutCubic", onComplete: createTween});
		}

		public function createArrow():void
		{
			if (_arrow != null || !_item.showArrow)
			{
				return;
			}
			_arrow = new HintArrow();

			_arrow.x = _container.x - width * .5;

			_arrow.scaleY = .8;
			_arrow.scaleX = .8;

			if (_item.location == ActionLocationId.RIGHT)
			{
				_arrow.x -= width * .5;
			}
			else
			{
				_arrow.x += width * .5;
				_arrow.scaleX *= -1;
			}

			_arrow.animateArrow();

			addChild(_arrow);
			_arrow.mouseEnabled = _arrow.mouseChildren = false;

			Tweener.addCaller(_arrow, {
				time: TIME_ARROW,
				count: 1,
				transition: "linear",
				onComplete: destroyArrow
			});
		}

		protected function destroyArrow():void
		{
			if (_arrow != null)
			{
				removeChild(_arrow);
				_arrow.destroy();
				_arrow = null;
			}
		}

		protected function onClickAction(event:MouseEvent):void
		{
			throw new IllegalOperationError("Abstract method must be overridden in a subclass");
		}

		public function destroy():void
		{
			Tweener.removeTweens(_container);
			isTime = false;
			destroyArrow();
			removeEventListener(MouseEvent.CLICK, onClickAction);

			if(_rotateTimer!=null){
				_rotateTimer.stop();
				_rotateTimer.removeEventListener(TimerEvent.TIMER, onRotate);
			}

			if (_tooltipController != null)
			{
				_tooltipController.destroy();
			}
			if (_item.hidden)
			{
				_container.removeEventListener(MouseEvent.MOUSE_OUT, hideContainer);
				_container.removeEventListener(MouseEvent.MOUSE_OVER, showContainer);
			}
			_container.removeChildAt(0);
			removeChild(_container);
			//parent.removeChild(this);
			_container = null;

			_item = null;
		}

		public function update(obj:Object = null):void
		{
			Tweener.addTween(_container, {time: .5, alpha: 0, onComplete: onUpdateCompleteTween, onCompleteParams: [obj]});
		}

		protected function redraw(obj:Object):void
		{
			throw new IllegalOperationError("Abstract method must be overridden in a subclass");
		}

		private function onUpdateCompleteTween(data:Object):void
		{
			redraw(data);
			Tweener.addTween(_container, {time: .5, alpha: 1});
		}

		public function get item():ActionItem
		{
			return _item;
		}

		public function updateCheck():void
		{
			if (_item.complete)
			{
				if (_check == null)
				{
					_check = ResourceManager.instance.getBitmap("gui", "hints_checksmall");
					_check.smoothing = true;
					_container.addChild(_check);
				}
			}
			else
			{
				if (_check != null)
				{
					_container.removeChild(_check);
					_check = null;
				}
			}
		}

		public function get rm():ResourceManager
		{
			return _rm;
		}

		override public function get width():Number
		{
			return _container.width;
		}
	}
}