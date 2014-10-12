/**
 * Autor: rastyslaw
 * Date: 04.03.14
 * Time: 16:32
 */
package by.candy.ui.quest
{
	import by.candy.CandyCore;
	import by.candy.nameStorage.GraphNames;
import by.candy.nameStorage.Names;
import by.candy.ui.actions.AbstractActionIcon;
import by.candy.ui.actions.ActionEvent;
import by.candy.utils.AwardParser;
import by.candy.utils.Utils;
import by.candy.utils.WallPostManager;
import by.signalengine.managers.DataManager;
import by.signalengine.managers.LocaleManager;
import by.signalengine.signals.ConnectionSignal;
import by.signalengine.signals.GUIModuleSignal;
import by.signalengine.signals.MapModuleSignal;
import by.signalengine.ui.elements.Button;
import by.signalengine.ui.elements.Element;
import by.signalengine.ui.elements.Window;

import com.slavshik.utils.replaceStringValues;
import com.x10.ResourceManager;
import com.x10.gui.Label;
import com.x10.social.AbstractAPI;
import com.x10.social.Profile;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.filters.GlowFilter;
import flash.geom.Rectangle;
import flash.text.TextFormatAlign;

import org.bytearray.display.ScaleBitmap;

public class QuestWindow extends Window
	{
		private var _questItem:Quest;
		private const GAP:int = 6;
		private var _icon:AbstractActionIcon;
		private var _time:int;
		private var _timeLabel:Label;
		private var _dm:DataManager;
		private var _timerLabel:Label;
		private var _topClip:Sprite;
		private var jumpToLevel:int;
		private var timerCont:Sprite;
		private var timerInPosition:Boolean;

		public function QuestWindow(xmlNode:XML, params:Object)
		{
			_questItem = params.item.data;
			_icon = params.item.content;

			super(xmlNode, params);
			params.onClose = closeAction;
			params.shareAction = shareAction;
			params.okAction = completeAction;
			params.tempAction = completeAction;
		}

		override public function init():void
		{
			super.init();

			getElementById("num_label", true).elementXML.@text = LocaleManager.instance.getString(_questItem.title);
			var _rm:ResourceManager = ResourceManager.instance;
			_dm = DataManager.instance;

			var info:Element = getElementById("info", true);

			_topClip = new Sprite();
			info.content = _topClip;

			var cumulativeHeight:int = 0;

			if(_questItem.event){
				var date:Date = new Date();
				date.setTime(Utils.dateParser(_questItem.timeEnd));
				var timeEndTimeStamp:int = Utils.convertDateToEpoch(date);
				if(timeEndTimeStamp < 0){
					timeEndTimeStamp *= -1;
				}
				var currentTime:int =  int(_dm.getValue(Names.TIME));
				_time = timeEndTimeStamp - currentTime;

				_icon.addEventListener(QuestEvent.TIMER_UPDATE, updateTimer);

				timerCont = new Sprite();
				_timerLabel = new Label(LocaleManager.instance.getString("ID_TIMER_QUEST") + " ", 22);
				timerCont.addChild(_timerLabel);

				_timeLabel = new Label("", 22);
				_timeLabel.x = _timerLabel.x + _timerLabel.width;
				timerCont.addChild(_timeLabel);

				timerCont.filters = [new GlowFilter(0x000000, .6)];

				timerCont.y = cumulativeHeight;
				_topClip.addChild(timerCont);
				cumulativeHeight = cumulativeHeight + timerCont.height + GAP;
			}

			var npcContainer:Element = getElementById("npc_container", true);
			var npcBmp:Bitmap = _rm.getBitmap("gui", _questItem.npc.image);
			npcContainer.elementXML.@l = 40 - npcBmp.width/2;
			npcContainer.content = npcBmp;
			npcContainer.update();

			var bubble:Sprite = new Sprite();
			var bubbleBmp:Bitmap = _rm.getResourceByName(GraphNames.DIALOG);
			var bgBM:Bitmap = new ScaleBitmap(bubbleBmp.bitmapData);
			bgBM.scale9Grid = new Rectangle(60, 60, 1, 1);
			bubble.addChild(bgBM);
			var bubbleLabel:Label = new Label("", 18, 0x3A76C6, bubble.width *.8, TextFormatAlign.CENTER);
			bubble.addChild(bubbleLabel);
			bubble.y = cumulativeHeight;
			_topClip.addChild(bubble);

			var taskRenderer:QuestTaskRenderer = new QuestTaskRenderer(_questItem.tasks);
			_topClip.addChild(taskRenderer);
//			if(taskRenderer.numItem == 1){
//				taskRenderer.y = 23;
//			}

			var okButton:Button = getElementById("okBtn", true) as Button;
			var shareButton:Button = getElementById("shareBtn", true) as Button;
			var tempButton:Button = getElementById("tempBtn", true) as Button;

			var okButtonLabel:Label = getElementContentById("okBtnTf", true) as Label;
			var tempButtonLabel:Label = getElementContentById("tempBtnTf", true) as Label;

			if (_questItem.complete)
			{
				getElementById("num_label", true).elementXML.@text = LocaleManager.instance.getString("ID_QUEST_COMPLETE_TITLE");
				tempButtonLabel.text = LocaleManager.instance.getString("ID_TAKE");
				okButton.elementXML.@visible = false;
				tempButton.elementXML.@visible = shareButton.elementXML.@visible = true;
				tempButton.elementXML.@r = 66;
				getElementById("shareBtnTf", true).elementXML.@text = LocaleManager.instance.getString("ID_REPORT");
				bubbleLabel.text = LocaleManager.instance.getString(_questItem.descriptionComplete);
			}
			else
			{
				tempButton.elementXML.@visible = shareButton.elementXML.@visible = false;
				okButton.elementXML.@visible = true;
				okButton.elementXML.@r = 166;
				okButtonLabel.text = LocaleManager.instance.getString("ID_TAKE");
				checkTaskLevel();
				if(jumpToLevel != 0){
					okButtonLabel.text = LocaleManager.instance.getString("ID_COMING_UP_POPUP_BUTTON_LABEL");
				} else {
					okButtonLabel.text = LocaleManager.instance.getString("ID_OK");
				}
				bubbleLabel.text = LocaleManager.instance.getString(_questItem.description);
			}
		    bgBM.height = bubbleLabel.height + 20;
			bubbleLabel.x = (bubble.width - bubbleLabel.width) * .5;
			bubbleLabel.y = (bubble.height - bubbleLabel.height) * .5;

			cumulativeHeight = cumulativeHeight + bubble.height + GAP;
			taskRenderer.y = cumulativeHeight;

			var awardContainer:Sprite = new Sprite();
			var awardBmp:Bitmap = _rm.getResourceByName(GraphNames.QUEST_BACK_AWARD);
			var awardBM:Bitmap = new ScaleBitmap(awardBmp.bitmapData);
			awardBM.scale9Grid = new Rectangle(60, 60, 1, 1);
			awardBM.width = _topClip.width;
			awardContainer.addChild(awardBM);

			var rewardRenderer:QuestAwardRenderer = new QuestAwardRenderer(_questItem.award);
			rewardRenderer.x = (awardContainer.width - rewardRenderer.width)/2;
			rewardRenderer.y = (awardContainer.height - rewardRenderer.height)/2;
			awardContainer.addChild(rewardRenderer);

			cumulativeHeight = cumulativeHeight + taskRenderer.height + GAP;
			awardContainer.y = cumulativeHeight;
			_topClip.addChild(awardContainer);

			//elementXML.@height = (_topClip.height + 30 <= npcBmp.height) ? npcBmp.height + 125 : _topClip.height + 160;
			elementXML.@height = _topClip.height + 160;
			getElementById("back1", true).elementXML.@height = int(elementXML.@height) - 40;

			update();
		}

		private function checkTaskLevel():void
		{
			for each (var task:Task in _questItem.tasks){
				if(task.progress < task.count && task.level != 0) {
					if(jumpToLevel == 0){
						jumpToLevel = task.level;
					}
				}
			}
		}

		private function updateTimer(event: QuestEvent):void
		{
			_time = event.value;
			if(_time == 0)
			{
				closeAction();
				return;
			}
			updateTimeLabel();
		}

		private function updateTimeLabel():void
		{
			_timeLabel.text = Utils.convertToHHMMSS(_time);
			if(!timerInPosition){
				timerInPosition = true;
				timerCont.x = (_topClip.width - timerCont.width) * .5;
			}
		}

		private function closeAction():void 
		{
			core.dispatch(GUIModuleSignal.HIDE_WINDOW, params);
		}

		private function toTargetLevel():void
		{
			if(jumpToLevel != 0){
				core.dispatch(MapModuleSignal.SCROLL_MAP, {level: jumpToLevel});
			}
		}

		private function completeAction():void
		{
			if (!_questItem.complete)
			{
				toTargetLevel();
				closeAction();
				return; 
			}
			getElementContentById("okBtn", true).enabled = false;
			core.dispatch(ActionEvent.QUEST_COMPLETE, {action: _icon});
			core.dispatch(ConnectionSignal.SEND_REQUEST, {
				c: "quest",
				a: "finishQuest",
				p: { questId: _questItem.id },
				callback: onServerResponce,
				session_key: CandyCore.instance.flashVars["session_key"]
			});
		}

		private function onServerResponce(result: Object):void
		{
			if(result.success == 0){
				return;
			}
			if(result.award != null){
				if( result.award["money"] != undefined){
					delete result.award["money"]; 
				}
				AwardParser.addAward(result.award);
			}
			getElementContentById("okBtn", true).enabled = true;
			closeAction();
		}

		private function shareAction():void
		{
			var profile:Profile = _dm.getValue(Names.PROFILE);
			var postMessage:String = replaceStringValues(Utils.gender(LocaleManager.instance.getString("ID_QUEST_COMPLETE"), profile.sex), LocaleManager.instance.getString(_questItem.title));
			WallPostManager.instance.completeQuest(_questItem.npc.photo, postMessage);
			core.subscribe(WallPostManager.POST_COMPLETE, onPostCompleteLevel);
		}

		private function onPostCompleteLevel(result: Object):void
		{
			core.unsubscribe(WallPostManager.POST_COMPLETE, onPostCompleteLevel);
			if(result.value == AbstractAPI.PUBLISH_SUCCESS){
				completeAction();
			}
		}

		override public function destroy():void
		{
			if(_icon != null){
				_icon.removeEventListener(QuestEvent.TIMER_UPDATE, updateTimer);
			}
			super.destroy();
		}
	}

}