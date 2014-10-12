/**
 * Autor: rastyslaw
 * Date: 21.04.14
 * Time: 11:02
 */
package by.candy.ui.actions
{
import by.candy.CandyCore;
import by.candy.module.AppSizeModule;
import by.candy.nameStorage.ElementNames;
import by.candy.nameStorage.Names;
import by.candy.signal.AppSizeManagerSignal;
import by.candy.ui.quest.Quest;
import by.signalengine.module.GUIModule;
import by.signalengine.ui.elements.Element;

import flash.display.DisplayObjectContainer;

public class ActionView
	{
		private var _module:ActionModule;
		private var _model:ActionModel;

		private var _containers:Vector.<IListContainer>;
		private var _actionList:IListContainer;
		private var _promoList:IListContainer;
		private var _questList:IListContainer;

		private const ACTIONS_LIST_RIGHT_MARGIN: int = -50;

		private var _appSizeModule: AppSizeModule;
		private var _core: CandyCore;

		public function ActionView(module:ActionModule)
		{
			_appSizeModule = AppSizeModule.instance;
			_core = CandyCore.instance;

			assignAppSizeHandlers();

			_module = module;
			_model = _module.model;
			_containers = new <IListContainer>[];
		}

		public function createContainers(viewElement:Element):void
		{
			var childContainer:Element;
			if (_actionList == null)
			{
				_actionList = new ActionList();
				_containers.push(_actionList);
				_module.createBaseActions();
			}
			_actionList.align();

			childContainer = viewElement.getElementById(ElementNames.ACTIONS_LIST, true);
			if (childContainer != null)
			{
				childContainer.content.addChild(_actionList.mc);

				delete(childContainer.elementXML.@r);
				childContainer.elementXML.@l = _appSizeModule.appWidth + ACTIONS_LIST_RIGHT_MARGIN;

				childContainer.update();
			}

			if (_questList == null)
			{
				_questList = new ActionList();
				_containers.push(_questList);
				createQuests(_model.dm.getValue(Names.QUESTS));
			}
			_questList.align();

			childContainer = viewElement.getElementById(ElementNames.QUESTS_LIST, true);
			if (childContainer != null)
			{
				childContainer.content.addChild(_questList.mc);
			}

			if (_promoList == null)
			{
				_promoList = new PromoList();
				_containers.push(_promoList);
				_module.createActions();
			}
			_promoList.align();
			childContainer = viewElement.getElementById(ElementNames.PROMO_LIST, true);
			if (childContainer != null)
			{
				childContainer.content.addChild(_promoList.mc);
			}
			refreshArrow();
		}

		public function createQuests(data:Object):void
		{
			if(data == null){
				return;
			}
			for(var id:String in data){ 
				createQuest(id, data[id]);
			}
			updateQuest(data);
		}

		public function createQuest(id:String, data:Object):void
		{
			var quest:Quest = new Quest(int(id), data.tasks, _model.gameXML.quests.quest.(@id == id), _model.gameXML.questNpc);
			var type:String = IconCreator.QUEST;
			if(quest.event){
				type = IconCreator.QUEST_EVENT;
			}
			var item:ActionItem = new ActionItem(type, ActionPriory.OTHER, quest, false, true, ActionLocationId.LEFT);
			var icon:AbstractActionIcon = _model.creator.creating(item);
			_questList.addIcon(icon);
			_model.addActions(icon);
		}

		public function updateQuest(data:Object):void
		{
			var icon:AbstractActionIcon;
			for (var i:int; i < _questList.length; i++){
				icon = _questList.getIconAt(i);
				updateProgress(icon, data);
			}

			var quests:Object = _model.dm.getValue(Names.QUESTS);

			for(var key:String in data){
				if(quests[key] == undefined){
					createQuest(key, data[key]);
				}
			}
			_questList.align();
			_model.dm.setValue(Names.QUESTS, data);
			ActionModel.QUEST_UPDATE_STARTED = true;
		}

		private function updateProgress(icon:AbstractActionIcon, data:Object):void
		{
			var quest:Quest = icon.item.data;
			for(var id:String in data){
				if(quest.id == int(id)){
					icon.update(data[id]);
					return;
				}
			}
		}

		public function createPromo(promoValue:int, type:String, time:int = 0):void
		{
			if (_model.hiddenPromo.indexOf(promoValue) != -1 || _model.promo.indexOf(promoValue) != -1)
			{
				return;
			}
			var promoData:Promo = new Promo(_model.gameXML.exchange.promo.(int(@id) == promoValue)[0]);
			promoData.time = time;
			if (_model.excludedPromo.indexOf(promoData.type) != -1)
			{
				return;
			}
			var myUid:int = _model.dm.getValue(Names.UID);
			if ((myUid % 2 == 0 && promoData.parity == 1) || (myUid % 2 != 0 && promoData.parity == 0))
			{
				return;
			}
			var item:ActionItem;
			var isAction:Boolean;
			if (promoData.type != "")
			{
				isAction = _model.actionTypes.indexOf(promoData.type) != -1;
				item = new ActionItem(promoData.type, ActionPriory.OTHER, promoData); 
			}
			else
			{
				isAction = _model.actionTypes.indexOf(type) != -1;
				item = new ActionItem(type, ActionPriory.OTHER, promoData);
			}
			var icon:AbstractActionIcon = _model.creator.creating(item);
			if(isAction){
				_actionList.addIcon(icon);
				_actionList.align();
			} else {
				_promoList.addIcon(icon); 
			}
			_model.addActions(icon);
		}

		public function clearFromContainer(action:AbstractActionIcon):void
		{
			action.destroy();
			_promoList.removeIcon(action);
			_actionList.removeIcon(action);
		}

		private function refreshArrow():void
		{
			for each(var action:AbstractActionIcon in _model.actions)
			{
				if (action.item.showArrow)
				{
					action.createArrow();
				}
			}
		}

		public function clearContainerContent():void
		{
			var parentContainer:DisplayObjectContainer;
			for each (var container:IListContainer in _containers)
			{
				parentContainer = container.mc.parent;
				if (parentContainer != null)
				{
					parentContainer.removeChild(container.mc);
				}
			}
		}

		private function assignAppSizeHandlers():void
		{
			_core.subscribe(AppSizeManagerSignal.APP_FULLSCREEN_CHANGED, onAppFullScreenSizeChangeHandler);
		}

		private function unassignAppSizeHandlers():void
		{
			_core.unsubscribe(AppSizeManagerSignal.APP_FULLSCREEN_CHANGED, onAppFullScreenSizeChangeHandler);
		}

		private function onAppSizeChangeHandler(params:Object = null):void
		{
		}

		private function onAppFullScreenSizeChangeHandler(params:Object = null):void
		{
			const actionListContainer: Element = GUIModule.instance.currentView.getElementById(ElementNames.ACTIONS_LIST, true) as Element;

			if(actionListContainer != null)
			{
				delete(actionListContainer.elementXML.@r);
				actionListContainer.elementXML.@l = _appSizeModule.appWidth + ACTIONS_LIST_RIGHT_MARGIN;
				actionListContainer.update();
			}
		}

		public function get model():ActionModel
		{
			return _model;
		}

		public function get component():ActionModule
		{
			return _module;
		}

		public function get containers():Vector.<IListContainer>
		{
			return _containers;
		}

		public function get actionList():IListContainer
		{
			return _actionList;
		}

		public function get promoList():IListContainer
		{
			return _promoList;
		}

		public function get questList():IListContainer
		{
			return _questList;
		}
	}
}
