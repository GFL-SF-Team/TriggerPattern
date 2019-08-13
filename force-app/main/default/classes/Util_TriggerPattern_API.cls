/*
 * @Author: Aleksandr Shcherbanyuk
 * @Date: 31/07/2019
 * @Description:
 *		API for 'Trigger Pattern'. It provides functionality for retrieving the handlers instances that are assigned to an object
 */

public class Util_TriggerPattern_API {

	/*
	 * objectName - Object Api Name
	 */
	private static String objectName = getObjectName();

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Description:
	 * 		Implements the general template that a trigger can have to execute all the handlers.
	 */
	public static void executeObjectTriggerHandlers() {
		Util_TriggerPattern_Service.initObjectTriggerHandlers(objectName);
	}

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Description:
	 * 		Get SObject Type (Api Name) for query a set of handlers
	 */
	private static String getObjectName() {

		if (objectName == null) {

			if (Trigger.new != null) {
				objectName = Trigger.new.getSObjectType().getDescribe().getName();
			}
			else if (Trigger.old != null) {
				objectName = Trigger.old.getSObjectType().getDescribe().getName();
			}

		}

		return objectName;
	}
}