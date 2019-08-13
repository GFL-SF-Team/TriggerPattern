/*
 * @Author: Aleksandr Shcherbanyuk
 * @Date: 31/07/2019
 * @Description:
 *		Serves as the Data Accessor layer of the 'Trigger Pattern' tool
 */
public without sharing class Util_TriggerPattern_DataAccesssor {

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Param: objectName - SObject API Name
	 * @Description:
	 * 		Retrieve all the active assignments of the trigger handlers with the object that corresponds to the given object API name.
	 */
	public static Trigger_Handler_Assignment__mdt[] getObjectTriggerHandlersAssignments(String objectName) {

		return [
				SELECT	MasterLabel, HandlerName__c, IsActive__c, Object_API_Name__c, Handler_Execution__c
				FROM	Trigger_Handler_Assignment__mdt
				WHERE	Object_API_Name__c = :objectName
				AND		IsActive__c = true
		];

	}
}