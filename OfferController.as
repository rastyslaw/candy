/**
 * Autor: rastyslaw
 * Date: 05.03.14
 * Time: 11:18
 */
package by.candy.ui.actions
{
import flash.events.Event;

public class OfferController
	{
		private var _offer:OfferAction;
		private var _offers:Array;
		private var _index:int;

		public function OfferController(offer:AbstractActionIcon, offers:Array)
		{
			_offer = OfferAction(offer);
			_offers = offers;
			_offer.updateLabel(getText());
			_offer.addEventListener(OfferAction.NEXT_OFFER, updateOffer);
		}

		private function updateOffer(event: Event):void {
			_index++;
			if(_index > _offers.length-1){
				_index = 0;
			}
			_offer.update(_offers[_index]);
			_offer.updateLabel(getText());
		}

		private function getText():String {
			return _index+1 + "/" + _offers.length;
		}
	}
}
