/**
 * Autor: rastyslaw
 * Date: 04.03.14
 * Time: 12:02
 */
package by.candy.ui.quest
{
import by.candy.nameStorage.Names;
import by.candy.ui.actions.*;
import by.candy.utils.Utils;

import caurina.transitions.Tweener;

import com.x10.gui.Label;

import flash.filters.GlowFilter;
import flash.text.TextFormatAlign;

public class QuestEventAction extends QuestAction
{
	private const BLINK_PERIOD: int = 3600;
	protected var time:int;
	private var _timeLabel:Label;
	private var isRed:Boolean;

	public function QuestEventAction(item:ActionItem)
	{
		super(item);
	}

	override protected function init():void
	{
		isTime = true;
		super.init();
		createTimer();
	}

	private function createTimer():void
	{
		var date:Date = new Date();
		date.setTime(Utils.dateParser(questData.timeEnd));
		var timeEndTimeStamp:int = Utils.convertDateToEpoch(date);
		if(timeEndTimeStamp < 0){
			timeEndTimeStamp *= -1;
		}
		var currentTime:int =  int(_dataManager.getValue(Names.TIME));
		time = timeEndTimeStamp - currentTime;

		createTimerLabel();
	}

	override public function update(obj:Object = null):void
	{
		if(_timeLabel == null){
			return;
		}

		time--;
		if(time < 0)
		{
			_core.dispatch(ActionEvent.QUEST_COMPLETE, {action: this});
			return;
		}
		_timeLabel.text = Utils.convertToHHMMSS(time);
		dispatchEvent(new QuestEvent(QuestEvent.TIMER_UPDATE, time));

		if(time <= BLINK_PERIOD)
		{
			if(!isRed){
				isRed = true;
				_timeLabel.filters = [new GlowFilter(0xffffff, 1, 3, 3, 16)];
				createRedTween();
			}
		}
		if(isRed){
			_timeLabel.color = 0xC22121;
		}
		super.update(obj);  
	}

	private function createRedTween():void
	{
		Tweener.addTween(_timeLabel, {time:.3, alpha:.6, transition: "linear"});
		Tweener.addTween(_timeLabel, {delay:.3, time:.3, alpha:1, transition: "linear", onComplete: createRedTween});
	}

	protected function createTimerLabel():void
	{
		_timeLabel = new Label(Utils.convertToHHMMSS(time), 16, 0xFFFFFF, _container.width+20, TextFormatAlign.CENTER);
		_timeLabel.filters = [new GlowFilter(0x000000, .6)];
		_container.addChild(_timeLabel);
		_timeLabel.x = -_bmp.width * .5 - 10;
		_timeLabel.y = _bmp.height * .5 - 10;
	}

	override public function destroy():void
	{
		Tweener.removeTweens(_timeLabel);
		super.destroy();
	}
}
}