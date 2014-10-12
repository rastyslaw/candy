/**
 * Autor: rastyslaw
 * Date: 04.03.14
 * Time: 11:39
 */
package by.candy.ui.actions
{
import flash.errors.IllegalOperationError;

//Abstract class
	public class CreatorObjects {

		public function CreatorObjects() {}

		public function creating(item:ActionItem):AbstractActionIcon {
			var icon:AbstractActionIcon = createObject(item);
			item.content = icon;
			return icon;
		}

		//Abstract method
		protected function createObject(item:ActionItem):AbstractActionIcon {
			throw new IllegalOperationError("Abstract method must be overridden in a subclass");
			return null;
		}

//-----
	}
}