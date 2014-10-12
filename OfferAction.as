/**
 * Autor: rastyslaw
 * Date: 04.03.14
 * Time: 12:02
 */
package by.candy.ui.actions
{
import by.candy.utils.WallPostManager;
import by.signalengine.managers.LocaleManager;

import com.x10.gui.Label;
import com.x10.gui.image.LoadableImage;
import com.x10.social.AbstractAPI;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

public class OfferAction extends AbstractActionIcon
	{
		public static const NEXT_OFFER:String = "nextOffer";
		private var _icon:LoadableImage;
		private var _offer:Offer;
		private var _label:TextField;

		public function OfferAction(item:ActionItem)
		{
			super(item);
		}

		override protected function init():void
		{
			_offer = new Offer(item.data);
			_icon = new LoadableImage(_offer.icon);
			_container.addChild(_icon);
			tooltipText = LocaleManager.instance.getString("ID_TOOLTIP_ACTION_OFFER");

			var textFormat:TextFormat = new TextFormat("font1", 20, 0xffffff);
			textFormat.align = TextFormatAlign.CENTER;
			_label = new TextField();
			_label.width = 50;
			_label.height = 26;
			_label.embedFonts = true;
			_label.defaultTextFormat = textFormat;
			_label.mouseEnabled = false;
			_container.addChild(_label);
			_label.filters = [new GlowFilter(0x000000, .8)];

			_label.visible = false;

			var _title:Label = new Label(LocaleManager.instance.getString("ID_GET"), 15, 0xffffff, _container.width, TextFormatAlign.CENTER);
			_title.x = -_container.width * .5;
			_title.y = 2;
			_container.addChild(_title);
			_title.filters = [new GlowFilter(0x000000, .6)];

			var _free:Label = new Label(LocaleManager.instance.getString("ID_FREE"), 15, 0xffffff, _container.width, TextFormatAlign.CENTER);
			_free.x = -_container.width * .5;
			_free.y = _title.y + 15;
			_container.addChild(_free);
			_free.filters = [new GlowFilter(0x000000, .6)];
		}

		override protected function onClickAction(event:MouseEvent):void
		{
			WallPostManager.instance.showOffers(_offer.id, 1, onComplete);
		}

		private function onComplete(value:int):void
		{
			if (value != AbstractAPI.ORDER_SUCCESS)
			{
				dispatchEvent(new Event(NEXT_OFFER));
			}
		}

		override protected function redraw(data:Object):void
		{
			item.data = data;
			_container.removeChild(_icon);
			_offer = new Offer(item.data);
			_icon = new LoadableImage(_offer.icon);
			_container.addChildAt(_icon, 0);
		}

		public function updateLabel(text:String):void
		{
			_label.text = text;
			_label.x = (2 * BORDER_SIZE - _label.width) / 2 - 5;    //  FIXME:  stupid shift fix with unknown cause. Deal with it for now & fix it later.
			_label.y = -BORDER_SIZE - 20;
		}
	}
}