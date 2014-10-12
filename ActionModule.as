/**
 * Autor: rastyslaw
 * Date: 04.03.14
 * Time: 11:02
 */
package by.candy.ui.actions
{
import by.candy.Console;
import by.candy.nameStorage.Names;
import by.candy.ui.quest.Quest;
import by.signalengine.Core;
import by.signalengine.module.BaseModule;
import by.signalengine.module.GUIModule;
import by.signalengine.signals.GUIModuleSignal;
import by.signalengine.signals.GlobalSignal;
import by.signalengine.ui.elements.Element;

import com.adobe.serialization.json.JSON;
import com.x10.Utils;
import com.x10.social.Platform;
import com.x10.social.Profile;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

public class ActionModule extends BaseModule
	{
		protected var _model:ActionModel;
		protected var _view:ActionView;
		private var _actionController:ActionControllerBase;

		private var _offerController:OfferController;
		private var freeToPayOffers:Object;

		public function ActionModule(core:Core)
		{
			super(core);
			core.subscribe(GUIModuleSignal.INIT, onInit);
		}

		private function onInit(params:Object):void
		{
			_model = new ActionModel();
			_view = new ActionView(this);
			_actionController = new ActionControllerBase(_view);

			_model.addEventListener(ActionModel.ADD_ACTION, onAddAction);
			core.subscribe(GlobalSignal.DATA_UPDATED, onDataUpdated);
			core.subscribe(GUIModuleSignal.CHANGE_VIEW, onViewChanged);
			core.subscribe(ActionEvent.ACTION_COMPLETE, onCompleteAction);
			core.subscribe(ActionEvent.QUEST_COMPLETE, onCompleteQuest);
			core.subscribe(GlobalSignal.DATA_UPDATED, onDataUpdate);
		}

		private function onDataUpdated(params: Object):void
		{
			if (params.key == Names.QUEST_UPDATE)
			{
				_view.updateQuest(params.value);
			}
		}

		public function addSpecialOffer():void
		{
			if(_model.freeToPayCreated){
				return;
			}
			var profile:Profile = _model.dm.getValue(Names.PROFILE);
			var urlString:String = "http://www.freetopay.ru/get_vk_banners.php?lead_ids=" +
					_model.flashVars['offerFullList'] + "&sex=" +
					(profile.sex == "2" ? "m" : "f") +
					"&age=" + Utils.getVKAge(profile.birthdate).toString() +
					"&sid=272" +
					"&uid=" + profile.uid;

			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorEventHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderSecurityErrorEventHandler);

			try
			{
				urlLoader.load(new URLRequest(urlString));
			}
			catch (error:Error)
			{
				Console.trace("error", "Unable to load freeToPay URL");
			}
		}

		private function onAddAction(event: Event):void
		{
			_actionController.updateTimer();
		}

		private function loaderCompleteHandler(event: Event):void
		{
			freeToPayOffers = JSON.decode(event.target.data);
			freeToPay();
		}

		public function freeToPay():void
		{
			if (_model.flashVars['platform'] == Platform.VKONTAKTE && freeToPayOffers != null)
			{
				Console.trace("info", freeToPayOffers.toString());

				if (freeToPayOffers.Status == "OK")
				{
					var specialOfferObject:SpecialOffer;
					var offers:Array = freeToPayOffers.Offers;
					if (offers.length != 0)
					{
						specialOfferObject = new SpecialOffer(freeToPayOffers);

						var item:ActionItem = new ActionItem(IconCreator.SPECIAL_OFFER, ActionPriory.SPECIAL_OFFER, specialOfferObject);
						var icon:AbstractActionIcon = _model.creator.creating(item);
						_view.actionList.addIcon(icon);
						_model.addActions(icon);
						_model.freeToPayCreated = true;
						_view.actionList.align();
					}
				}
			}
		}

		private function loaderIOErrorEventHandler(event:IOErrorEvent):void
		{
			Console.trace("error", event.text);
		}

		private function loaderSecurityErrorEventHandler(event:SecurityErrorEvent):void
		{
			Console.trace("error", event.text);
		}

		private function onViewChanged(param:Object):void
		{
			var viewElement:Element = GUIModule.instance.currentView;
			if (viewElement == null)
			{
				return;
			}
			if (viewElement.elementXML.@id == Names.MENU)
			{
				_view.createContainers(viewElement);
			}
			else if (viewElement.elementXML.@id == Names.GAME)
			{
				_view.clearContainerContent();
			}
		}

		private function onCompleteAction(param:Object):void
		{
			for each(var action:AbstractActionIcon in _model.actions)
			{
				if (action == param.action)
				{
					_model.actions.splice(_model.actions.indexOf(action), 1);
					_view.clearFromContainer(action);
					action = null;
				}
			}
			_view.actionList.align();
		}

		private function onCompleteQuest(param:Object):void
		{
			for each(var action:AbstractActionIcon in _model.actions)
			{
				if (action == param.action)
				{
					_model.actions.splice(_model.actions.indexOf(action), 1);
					_view.questList.removeIcon(action);
					var quests:Object = _model.dm.getValue(Names.QUESTS);
					delete quests[String(Quest(action.item.data).id)];
					_model.dm.setValue(Names.QUESTS, quests);
				}
			}
			_view.questList.align();
		}

		private function createPlayFriendsAction():void
		{
			var level:int = int(_model.dm.getValue(Names.LEVEL));
			if (_model.dm.getValue(Names.BASE_OFFER) != null || _model.firstCreated)
			{
				return;
			}
			if (level < ActionModel.START_BASE_OFFER_LEVEL)
			{
				core.subscribe(GlobalSignal.DATA_UPDATED, onLevelChanged);
				return;
			}

			var item:ActionItem = new ActionItem(IconCreator.FIRST, ActionPriory.FIRST, null, true, true);
			var icon:AbstractActionIcon = _model.creator.creating(item);
			_view.actionList.addIcon(icon);
			_model.addActions(icon);
			_model.firstCreated = true;
		}

		private function onLevelChanged(params:Object):void
		{
			if (params.key != Names.LEVEL)
			{
				return;
			}
			core.unsubscribe(GUIModuleSignal.CHANGE_VIEW, onLevelChanged);
			createBaseActions();
		}

		private function onDataUpdate(params:Object = null):void
		{
			if (params.key == Names.PROMO_EVENT || params.key == Names.PROMO_ACTIVE)
			{
				createActions();
			}
		}

		public function createActions():void
		{
			var promoEvents:Object = _model.dm.getValue(Names.PROMO_EVENT);
			var activePromo:Array = _model.dm.getValue(Names.PROMO_ACTIVE);

			if (promoEvents != null)
			{
				createPromoEvent(promoEvents);
			}

			if (activePromo != null)
			{
				createActivePromo(activePromo);
			}
			//GUIModule.instance.currentView.getElementById(ElementNames.TOP_PANEL, true).update();
		}

		private function createPromoEvent(promoEvents:Object):void
		{
			for (var key:String in promoEvents)
			{
				_view.createPromo(int(key), IconCreator.PROMO_EVENT, int(promoEvents[key]));
			}
		}

		private function createActivePromo(activePromo:Array):void
		{
			var len:int = activePromo.length;
			for (var i:int = 0; i < len; i++)
			{
				_view.createPromo(activePromo[i], IconCreator.ACTIVE_PROMO);
			}
		}

		public function createBaseActions():void
		{
			core.unsubscribe(GlobalSignal.DATA_UPDATED, onLevelChanged);
			createPlayFriendsAction();
			_model.checkShowingOffers();
			createOffers();
		}

//		private function update():void
//		{
//			for each(var action:AbstractActionIcon in _actions){
//				if(action.item.complete){
//					creator.removing(action);
//				}
//			}
//		}

		private function createOffers():void
		{
			if (!_model.showingOffers)
			{
				return;
			}

			if (_model.offers == null || _model.offers.length == 0 || _model.offersCreated)
			{
				return;
			}

			var level:int = int(_model.dm.getValue(Names.LEVEL));
			if (level < ActionModel.START_OFFERS_LEVEL)
			{
				core.subscribe(GlobalSignal.DATA_UPDATED, onLevelChanged);
				return;
			}

			var item:ActionItem = new ActionItem(IconCreator.OFFER, ActionPriory.OFFER, _model.offers[0]);
			var action:AbstractActionIcon = _model.creator.creating(item);
			_view.actionList.addIcon(action);
			_model.addActions(action);
			_model.offersCreated = true;
			_offerController = new OfferController(action, _model.offers);
		}

		public function get model():ActionModel
		{
			return _model;
		}

		public function get actionController():ActionControllerBase
		{
			return _actionController;
		}
	}
}