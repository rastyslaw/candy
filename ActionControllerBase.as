/**
 * Autor: rastyslaw
 * Date: 21.04.14
 * Time: 11:02
 */
package by.candy.ui.actions
{
import flash.events.TimerEvent;
import flash.utils.Timer;

public class ActionControllerBase
	{
		protected var _model:ActionModel;
		protected var _view:ActionView;

		private var timer:Timer;

		public function ActionControllerBase(view:ActionView)
		{
			_view = view;
			_model = _view.model;
		}

		public function updateTimer():void
		{
			if(timer == null){
				timer = new Timer(1000);
				timer.addEventListener(TimerEvent.TIMER, updateIcons);
				timer.start();
			}
			if (!timer.running)
			{
				timer.start();
			}
		}

		private function updateIcons(event:TimerEvent):void
		{
			if(_model.actions.length == 0){
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, updateIcons);
				return;
			}
			var active:Boolean;
			for each (var action:AbstractActionIcon in _model.actions)
			{
				if (action.isTime)
				{
					action.update();
					active = true;
				}
			}

			if (!active)
			{
				timer.stop();
			}
		}

		public function destroy():void
		{
			_view = null;
			_model = null;
		}

	}
}
