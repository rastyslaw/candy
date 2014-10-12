/**
 * Autor: rastyslaw
 * Date: 04.03.14
 * Time: 11:42
 */
package by.candy.ui.actions
{
import by.candy.ui.quest.QuestAction;
import by.candy.ui.quest.QuestEventAction;

public class IconCreator extends CreatorObjects {

		public static const FIRST:String            = "play_with_friends";
		public static const PROMO_EVENT:String      = "promoEvent";
		public static const ACTIVE_PROMO:String     = "activePromo";
		public static const OFFER:String            = "offer";
		public static const SALE:String             = "sale";
		public static const EXTRALIFE:String        = "extraLife";
		public static const SPECIAL_OFFER:String    = "specialOffer";
		public static const QUEST:String            = "quest";
		public static const QUEST_EVENT:String      = "questEvent";

		override protected function createObject(item:ActionItem):AbstractActionIcon {
			switch(item.type) {
				case FIRST:
					return new FirstAction(item);
				break;
				case PROMO_EVENT:
					return new PromoEventAction(item);
				break;
				case ACTIVE_PROMO:
					return new ActivePromoAction(item);
				break;
				case OFFER:
					return new OfferAction(item);
				break;
				case SALE:
					return new SaleAction(item);
				break;
				case SPECIAL_OFFER:
					return new SpecialOfferAction(item);
				break;
				case QUEST:
					return new QuestAction(item);
				break;
				case QUEST_EVENT:
					return new QuestEventAction(item);
				break;
			default:
				throw new Error("Invalid action type");
			}
		}
//-----
	}
}