/**
 * Autor: rastyslaw
 * Date: 21.04.14
 * Time: 11:02
 */
package by.candy.ui.actions
{
import by.candy.CandyCore;
import by.candy.nameStorage.Names;
import by.signalengine.managers.DataManager;

import flash.events.Event;
import flash.events.EventDispatcher;

public class ActionModel extends EventDispatcher
	{
		public static const ADD_ACTION:String = "addAction";
		public static var QUEST_UPDATE_STARTED:Boolean = false;
		public static var START_BASE_OFFER_LEVEL:int;
		public static var START_OFFERS_LEVEL:int;

		public var excludedPromo:Array;
		public var flashVars:Object;
		public var dm:DataManager;
		private var _hiddenPromo:Array;
		public var gameXML:XML;
		private var _promo:Array;
		public var offers:Array;
		private var _actions:Vector.<AbstractActionIcon>;
		public var creator:CreatorObjects;

		public var offersCreated:Boolean;
		public var firstCreated:Boolean;
		public var freeToPayCreated:Boolean;
		public var showingOffers:Boolean;

		public var actionTypes:Array;

		public function ActionModel() {
			readConst();
		}

		private function readConst():void
		{
			dm = DataManager.instance;
			flashVars = CandyCore.instance.flashVars;
			gameXML = dm.getValue(Names.GAME_XML);
			_promo = dm.getValue(Names.PROMO);
			_hiddenPromo = dm.getValue(Names.HIDDEN_PROMO);
			START_BASE_OFFER_LEVEL = gameXML.game.settings.startFirst;
			START_OFFERS_LEVEL = gameXML.game.settings.startOffers;

			_actions = new <AbstractActionIcon>[];

			creator = new IconCreator();

			excludedPromo = [IconCreator.EXTRALIFE];

			actionTypes = [IconCreator.PROMO_EVENT, IconCreator.ACTIVE_PROMO];
			parseOffers();
		}

		public function checkShowingOffers():void
		{
//			var roles:Array = DataManager.instance.getValue(Names.ROLES);
//			if (roles.indexOf(RolesId.ADMIN) == -1 && roles.indexOf(RolesId.MODERATOR) == -1)
//			{
//				return;
//			}

			var payments:int = dm.getValue(Names.PAYMENTS);
			if (payments > int(gameXML.clientConfig.offerPaymentsLimit))
			{
				return;
			}

			showingOffers = true;
		}

		private function parseOffers():void
		{
			//offers = JSON.decode(decodeURIComponent(CandyCore(core).flashVars["offersObj"]));
			offers = [];
			if (flashVars["offers"] != null && flashVars['offers'].length > 0)
			{
				var offersArray:Array = flashVars['offers'].split("}{");

				for (var i:int = 0; i < offersArray.length; i++)
				{
					var offerString:String = offersArray[i];

					var offerFields:Array = offerString.split("|");

					offers.push(
							{
								id: offerFields[0],
								title: offerFields[1],
								description: offerFields[2],
								img: decodeURIComponent(offerFields[3]), 
								bonus: offerFields[4],
								track: offerFields[5],
								icon: decodeURIComponent(offerFields[6]),
								popup: decodeURIComponent(offerFields[7])
							});
				}
			}
			dm.setValue(Names.OFFERS, offers);
		}

		public function get hiddenPromo():Array
		{
			return _hiddenPromo != null ? _hiddenPromo : [];
		}

		public function get promo():Array
		{
			return _promo != null ? _promo : [];
		}

		public function get actions():Vector.<AbstractActionIcon>
		{
			return _actions;
		}

		public function addActions(value:AbstractActionIcon):void
		{
			_actions.push(value);
			dispatchEvent(new Event(ADD_ACTION));
		}
	}
}
