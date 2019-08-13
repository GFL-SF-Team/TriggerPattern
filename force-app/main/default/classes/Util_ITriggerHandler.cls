/*
 * @Author: Aleksandr Shcherbanyuk
 * @Date: 31/07/2019
 * @Description:
 * 		Interface that all trigger handlers should implement in order to follow the 'Trigger Design' pattern.
 */

global interface Util_ITriggerHandler {

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Param: updatedRecords - records that need to set in the current handler
	 * @Description:
	 * 		Setter for new version of records
	 */
	void setUpdatedRecordsFromList(SObject[] updatedRecords);

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Param: updatedRecords - records that need to set in the current handler
	 * @Description:
	 * 		Setter for new version of records
	 */
	void setUpdatedRecordsFromMap(Map<Id, SObject> updatedRecords);

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Description:
	 * 		Getter for stored records in the current handler
	 */
	SObject[] getUpdatedRecordsList();

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Description:
	 * 		Getter for stored records in the current handler
	 */
	Map<Id, SObject> getUpdatedRecordsMap();

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Description:
	 * 		Placeholder for the function to be called when the trigger is called on the before insert status.
	 * 		When this function is called the trigger.new is available.
	 */
	void onBeforeInsertFunction();

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Description:
	 * 		Placeholder for the function to be called when the trigger is called on the before update status.
	 * 		When this function is called the Trigger.oldMap, Trigger.newMap, Trigger.old, Trigger.new are available.
	 */
	void onBeforeUpdateFunction();

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Description:
	 * 		Placeholder for the function to be called when the trigger is called on the before delete status.
	 * 		When this function is called the Trigger.oldMap, Trigger.old are available.
	 */
	void onBeforeDeleteFunction();

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Description:
	 * 		Placeholder for the function to be called when the trigger is called on the after insert status.
	 * 		When this function is called the Trigger.newMap, Trigger.new are available.
	 */
	void onAfterInsertFunction();

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Description:
	 * 		Placeholder for the function to be called when the trigger is called on the after update status.
	 * 		When this function is called the Trigger.oldMap, Trigger.newMap, Trigger.old, Trigger.new are available.
	 */
	void onAfterUpdateFunction();

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Description:
	 * 		Placeholder for the function to be called when the trigger is called on the after delete status.
	 * 		When this function is called the Trigger.oldMap, Trigger.old are available.
	 */
	void onAfterDeleteFunction();

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Description:
	 * 		Placeholder for the function to be called when the trigger is called on the after undelete status.
	 * 		When this function is called the Trigger.newMap is available.
	 */
	void onAfterUndeleteFunction();

}