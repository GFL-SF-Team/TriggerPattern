/*
 * @Author: Aleksandr Shcherbanyuk
 * @Date: 31/07/2019
 * @Description:
 *		API for 'Trigger Pattern'. It provides functionality for retrieving the handlers instances that are assigned to an object
 * @History:
 *	- Pavel Riabov 21.10.19 removed static property objectName
 */

public class Util_TriggerPattern_API {

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Description:
	 * 		Implements the general template that a trigger can have to execute all the handlers.
	 */
	public static void executeObjectTriggerHandlers() {
		String objectName = getObjectName();
		Util_TriggerPattern_Service.initObjectTriggerHandlers(objectName);
	}

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Description:
	 * 		Get SObject Type (Api Name) for query a set of handlers
	 */
	private static String getObjectName() {

		if (Trigger.new != null) {
			return Trigger.new.getSObjectType().getDescribe().getName();
		}
		else if (Trigger.old != null) {
			return Trigger.old.getSObjectType().getDescribe().getName();
		}

		return null;
	}
}