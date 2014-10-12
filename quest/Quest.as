/**
 * Autor: rastyslaw
 * Date: 04.03.14
 * Time: 12:02
 */
package by.candy.ui.quest
{
import by.candy.ui.actions.*;

import flash.events.EventDispatcher;

public class Quest extends EventDispatcher
	{
		private var _id:int;
		private var _npc:NPC;
		private var _event:Boolean;
		private var _tasks:Vector.<Task>;
		private var _timeStart:String;
		private var _timeEnd:String;
		private var _title:String;
		private var _description:String;
		private var _descriptionComplete:String;
		private var _award:XMLList;

		public function Quest(id:int, tasksObj:Object, data:XMLList, npcList:XMLList)
		{
			_id = id;

			var npcXML:XMLList = npcList.npc.(@id == String(data.npc));
			_npc = new NPC(data.npc, npcXML);

			_timeStart = data.timeStart;
			_timeEnd = data.timeEnd;

			if(_timeEnd != ""){
				_event = true;
			}

			_title = data.title;
			_description = data.description;
			_descriptionComplete = data.descriptionComplete;

			_tasks = new <Task>[];
			var tasksList:XMLList = data.tasks.task;
			for each(var task:XML in tasksList){
				_tasks.push(new Task(task));
			}
			updateTasks(tasksObj);
			_award = data.award.item;
		}

		public function get complete():Boolean
		{
			var i:int;
			for each(var task:Task in _tasks) {
				if(task.progress < task.count) {
					return false;
				}
				i++;
				if(i == QuestTaskRenderer.TASK_LIMIT){
					return true;
				}
			}
			return true;
		}

		public function get id():int
		{
			return _id;
		}

		public function get npc():NPC
		{
			return _npc;
		}

		public function get tasks():Vector.<Task>
		{
			return _tasks;
		}

		public function updateTasks(data: Object):void
		{
			var tastObj:Object;
			for each(var task:Task in _tasks){
				tastObj = data[task.id];
				if(task.action == QuestType.PASS_LEVEL_ITEM && task.progress < tastObj.progress && ActionModel.QUEST_UPDATE_STARTED){
					dispatchEvent(new QuestEvent(QuestEvent.ITEM_COLLECT, tastObj.progress - task.progress, task.ticketImageUrl));
				}
				task.progress = tastObj.progress;
				if(tastObj.level != undefined){
					task.level = tastObj.level;
				}
				if(tastObj.count != undefined){
					task.count = tastObj.count;
				}
				if(tastObj.figureId != undefined){
					task.figureId = tastObj.figureId;
				}
				if(tastObj.colorId != undefined){
					task.colorId = tastObj.colorId;
				}
				if(tastObj.combinationId != undefined){
					task.combinationId = tastObj.combinationId;
				}
			}
		}

		public function get timeStart():String
		{
			return _timeStart;
		}

		public function get timeEnd():String
		{
			return _timeEnd;
		}

		public function get title():String
		{
			return _title;
		}

		public function get description():String
		{
			return _description;
		}

		public function get descriptionComplete():String
		{
			return _descriptionComplete;
		}

		public function get award():XMLList
		{
			return _award;
		}

		public function get event():Boolean
		{
			return _event;
		}
	}
}
