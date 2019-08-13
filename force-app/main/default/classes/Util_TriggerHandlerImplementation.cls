/*
 * @Author: Aleksandr Shcherbanyuk
 * @Date: 31/07/2019
 * @Description:
 *		Basic Implementation of the 'Util_ITriggerHandler' interface.
 *		This implementation will be a backbone that other implementations will extend in order to
 *		avoid having empty functions inside each implementation
 */

public virtual class Util_TriggerHandlerImplementation implements Util_ITriggerHandler, Queueable {

	/*
	 * Properties for save records with changes. If Trigger.new or newMap were changed,
	 * you must store new records in these properties for correct work asyncs jobs
	 */
	private SObject[] updatedRecordsList = new SObject[]{};
	private Map<Id, SObject> updatedRecordsMap = new Map<Id, SObject>();

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Param: records - records that need to set in the current handler
	 * @Description:
	 * 		Setter for new version of records. It sets records to properties (updatedRecordsList & updatedRecordsMap) from List
	 */
	public virtual void setUpdatedRecordsFromList(SObject[] records) {

		if(records != null) {

			for (SObject record : records) {

				if (record.Id != null) {
					this.updatedRecordsMap.put(record.Id, record);
				}

			}

			this.updatedRecordsList.addAll(records);
		}

	}

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Description:
	 * 		Getter for stored records in the current handler, returns property updatedRecordsList
	 */
	public virtual SObject[] getUpdatedRecordsList() {
		return this.updatedRecordsList;
	}

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Param: records - records that need to set in the current handler
	 * @Description:
	 * 		Setter for new version of records. It sets records to properties (updatedRecordsList & updatedRecordsMap) from Map
	 */
	public virtual void setUpdatedRecordsFromMap(Map<Id, SObject> records) {

		if (records != null) {
			this.updatedRecordsMap.putAll(records);
			this.updatedRecordsList = records.values();
		}

	}

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Description:
	 * 		Getter for stored records in the current handler, returns property updatedRecordsMap
	 */
	public virtual Map<Id, SObject> getUpdatedRecordsMap() {
		return this.updatedRecordsMap;
	}

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Description:
	 * 		Function to be called when the trigger is called on the before insert status.
	 * 		When this function is called the trigger.new is available.
	 */
	public virtual void onBeforeInsertFunction() {
		// Just empty implementation
	}

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Description:
	 * 		Function to be called when the trigger is called on the before update status.
	 * 		When this function is called the Trigger.oldMap, Trigger.newMap, Trigger.old, Trigger.new are available.
	 */
	public virtual void onBeforeUpdateFunction() {
		// Just empty implementation
	}

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Description:
	 * 		Function to be called when the trigger is called on the before delete status.
	 * 		When this function is called the Trigger.oldMap, Trigger.old are available.
	 */
	public virtual void onBeforeDeleteFunction() {
		// Just empty implementation
	}

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Description:
	 * 		Function to be called when the trigger is called on the after insert status.
	 * 		When this function is called the Trigger.newMap, Trigger.new are available.
	 */
	public virtual void onAfterInsertFunction() {
		// Just empty implementation
	}

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Description:
	 * 		Function to be called when the trigger is called on the after update status.
	 * 		When this function is called the Trigger.oldMap, Trigger.newMap, Trigger.old, Trigger.new are available.
	 */
	public virtual void onAfterUpdateFunction() {
		// Just empty implementation
	}

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Description:
	 * 		Function to be called when the trigger is called on the after delete status.
	 * 		When this function is called the Trigger.oldMap, Trigger.old are available.
	 */
	public virtual void onAfterDeleteFunction() {
		// Just empty implementation
	}

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Description:
	 * 		Function to be called when the trigger is called on the after undelete status.
	 *		When this function is called the Trigger.newMap is available.
	 */
	public virtual void onAfterUndeleteFunction() {
		// Just empty implementation
	}

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Description:
	 *		Function to be called when you need to run asynchronous trigger jobs.
	 *		You can access the records through methods getUpdatedRecordsList and getUpdatedRecordsMap.
	 */
	public virtual void execute(QueueableContext context) {
		/*
		 * You can access the records through methods:
		 * 	- getUpdatedRecordsList()
		 * 	- getUpdatedRecordsMap()
		 */
	}
}