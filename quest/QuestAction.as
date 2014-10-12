/**
 * Autor: rastyslaw
 * Date: 04.03.14
 * Time: 12:02
 */
package by.candy.ui.quest
{
import by.candy.nameStorage.ElementNames;
import by.candy.ui.actions.*;
import by.signalengine.module.GUIModule;
import by.signalengine.signals.GUIModuleSignal;

import com.x10.ResourceManager;

import flash.display.Bitmap;
import flash.events.MouseEvent;

public class QuestAction extends AbstractActionIcon
{
	protected var _bmp:Bitmap;
	protected var questData:Quest;
	protected var _itemEvent:QuestEvent;

	public function QuestAction(item:ActionItem)
	{
		super(item);
	}

	override protected function init():void
	{
		questData = item.data;

		questData.addEventListener(QuestEvent.ITEM_COLLECT, onItemCollected);

		_bmp = rm.getBitmap("gui", questData.npc.icon);
		_bmp.x = -_bmp.width / 2;
		_bmp.y = -_bmp.height / 2;
		_bmp.smoothing = true;
		_container.addChild(_bmp);
		tooltipText = questData.npc.title;
	}

	override public function update(obj:Object = null):void
	{
		if(obj == null || obj.tasks == undefined){
			return;
		}
		questData.updateTasks(obj.tasks);
		if (questData.complete) {
			onOpenQuestWindow();
		}
		updateCheck();
	}

	override public function updateCheck():void
	{
		if (questData.complete) {
			if (_check == null) {
				_check = ResourceManager.instance.getBitmap("gui", "hints_checksmall");
				_check.smoothing = true;
				_container.addChild(_check);
			}
		}
		else {
			if (_check != null) {
				_container.removeChild(_check);
				_check = null;
			}
		}
	}

	override protected function onClickAction(event:MouseEvent):void
	{
		_core.dispatch(GUIModuleSignal.SHOW_WINDOW, {id: ElementNames.QUEST_WINDOW, item: item});
	}

	private function checkOpenQuestWindow(param: Object):void
	{
		if (GUIModule.instance.getWindows().length == 0)
		{
			_core.unsubscribe(GUIModuleSignal.HIDE_TOP_WINDOW, checkOpenQuestWindow);
			_core.unsubscribe(GUIModuleSignal.HIDE_WINDOW, checkOpenQuestWindow);
			onClickAction(null);
		}
	}

	private function checkCloseWindow(param: Object):void
	{
		if (GUIModule.instance.getWindows().length == 0)
		{
			_core.unsubscribe(GUIModuleSignal.HIDE_TOP_WINDOW, checkCloseWindow);
			_core.unsubscribe(GUIModuleSignal.HIDE_WINDOW, checkCloseWindow);
			_core.dispatch(GUIModuleSignal.SHOW_WINDOW, {id: ElementNames.GET_PRESENT_WINDOW, award: {item: _itemEvent.value, url: _itemEvent.url}});
		}
	}

	private function onOpenQuestWindow():void
	{
		if (GUIModule.instance.getWindows().length > 0)
		{
			_core.subscribe(GUIModuleSignal.HIDE_TOP_WINDOW, checkOpenQuestWindow);
			_core.subscribe(GUIModuleSignal.HIDE_WINDOW, checkOpenQuestWindow);
		}
		else
		{
			onClickAction(null);
		}
	}

	private function onItemCollected(event: QuestEvent):void
	{
		if (GUIModule.instance.getWindows().length > 0)
		{
			_itemEvent = event;
			_core.subscribe(GUIModuleSignal.HIDE_TOP_WINDOW, checkCloseWindow);
			_core.subscribe(GUIModuleSignal.HIDE_WINDOW, checkCloseWindow);
		}
		else
		{
			_core.dispatch(GUIModuleSignal.SHOW_WINDOW, {id: ElementNames.GET_PRESENT_WINDOW,  award: {item: _itemEvent.value, url: _itemEvent.url}});
		}
	}

	override public function destroy():void
	{
		_core.unsubscribe(GUIModuleSignal.HIDE_TOP_WINDOW, checkCloseWindow);
		_core.unsubscribe(GUIModuleSignal.HIDE_WINDOW, checkCloseWindow);

		_core.unsubscribe(GUIModuleSignal.HIDE_TOP_WINDOW, checkOpenQuestWindow);
		_core.unsubscribe(GUIModuleSignal.HIDE_WINDOW, checkOpenQuestWindow);

		questData.removeEventListener(QuestEvent.ITEM_COLLECT, onItemCollected);
		super.destroy();
	}
}
}