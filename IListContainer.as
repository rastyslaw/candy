/**
 * Autor: rastyslaw
 * Date: 11.03.14
 * Time: 17:37
 */
package by.candy.ui.actions
{
import flash.display.Sprite;

public interface IListContainer	{

		function addIcon(icon:AbstractActionIcon):void
		function removeIcon(icon:AbstractActionIcon):void
		function getIconAt(i:int):AbstractActionIcon
		function get mc():Sprite
		function align():void
		function get length():int
	}
}
