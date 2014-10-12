/**
 * Autor: rastyslaw
 * Date: 04.03.14
 * Time: 12:02
 */
package by.candy.ui.actions
{
import by.candy.nameStorage.ElementNames;
import by.signalengine.managers.LocaleManager;
import by.signalengine.signals.GUIModuleSignal;

import caurina.transitions.Tweener;

import com.x10.gui.Label;

import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

public class SaleAction extends PromoAction
{
	public function SaleAction(item:ActionItem)
	{
		super(item);
	}

	override protected function init():void
	{
		super.init();

		isTime = false;

		_bmp.y = -10;

		var label:Label = new Label(LocaleManager.instance.getString("ID_DISCOUNT_ACTION"), 20);
		label.rotation = -12;
		image.addChild(label);
		_container.addChild(image);
		label.filters = [new DropShadowFilter(1, 45, 0x000000, 0.5, 4, 4, 2)];

		label.x = -label.width*.5;
		label.y = label.height*.5;
	}

	override protected function setCoordinate():void
	{
		this.x = 260;
		this.y = 70;
	}

	override protected function activateTooltip():void
	{
		//
	}

	override protected function createTimer():void
	{
		//
	}

	override protected function createTween():void
	{
		Tweener.addCaller(_container, {delay: 2, time: Math.random() * 5, count: 1, transition: "linear", onComplete: addTween});
	}

	override protected function onClickAction(event:MouseEvent):void
	{
		_core.dispatch(GUIModuleSignal.SHOW_WINDOW,  {id: ElementNames.BUY_MONEY_ACTION_WINDOW, item: item});
	}
}
}