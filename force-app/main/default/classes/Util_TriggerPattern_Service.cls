/*
 * @Author: Aleksandr Shcherbanyuk
 * @Date: 31/07/2019
 * @Description:
 *		Serve as the Service Layer for the needed functions of the Trigger Design Pattern
 */
public with sharing class Util_TriggerPattern_Service {

	private static final String SYNC = 'Sync';
	private static final String ASYNC_UPDATE = 'AsyncAfterUpdate';
	private static final String ASYNC_EXECUTION_ALL = 'AsyncAfterSyncExec';
	private static final Map<String, String> EXECUTION_TYPE = new Map<String, String>{
		SYNC => SYNC,
		ASYNC_UPDATE => 'Async After SObject Sync Update',
		ASYNC_EXECUTION_ALL => 'Async After Sync Execution'
	};
	private static final Integer ASYNC_LIMIT = 50;
	private static Boolean isRecursion = false;
	private static Util_ITriggerHandler syncHandler;

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Param: objectName - SObject API Name
	 * @Description:
	 *		Initializes processing for the execution jobs by SObject API Name
	 */
	public static void initObjectTriggerHandlers(String objectName) {
		Map<String, Util_ITriggerHandler[]> handlerMap = getObjectTriggerHandlers(objectName);

		executeHandlerSynchronously(handlerMap);
 		executeAsyncHandler(handlerMap, ASYNC_EXECUTION_ALL);

	}

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Param: objectName - SObject API Name
	 * @Description:
	 *		Serves for returning all the instances of the handlers that corresponds to the given SObject API Name.
	 */
	private static Map<String, Util_ITriggerHandler[]> getObjectTriggerHandlers(String objectName) {
		Map<String, Util_ITriggerHandler[]> resultMap = new Map<String, Util_ITriggerHandler[]>();

		try {
			Map<String, Trigger_Handler_Assignment__mdt[]> assignments = getAssignmentsByExecutionType(
					Util_TriggerPattern_DataAccessor.getObjectTriggerHandlersAssignments(objectName));

			for (String key : assignments.keySet()) {

				for (Trigger_Handler_Assignment__mdt assignment : assignments.get(key)) {

					if (resultMap.containsKey(key)) {
						resultMap.get(key).add((Util_ITriggerHandler) Type.forName(assignment.HandlerName__c).newInstance());
					}
					else {
						resultMap.put(key, new Util_ITriggerHandler[]{(Util_ITriggerHandler) Type.forName(assignment.HandlerName__c).newInstance()});
					}

				}

			}

		} catch (Exception e) {
			/*
			 * Put your error handler here
			 */
			System.debug('Error - Util_TriggerPattern_Service.getObjectTriggerHandlers: ' + e.getMessage() + ' Line : ' + e.getLineNumber());
		}

		return resultMap;
	}

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Param: handlerMap - Map with handlers separated by a key (handler type) and a list handlers
	 * @Description:
	 *		Serves for synchronous execution, but if recursion occurs, asynchronous execution will be called with
	 *		'Async After SObject Sync Update' type
	 */
	private static void executeHandlerSynchronously(Map<String, Util_ITriggerHandler[]> handlerMap) {
		if (handlerMap.containsKey(SYNC)) {
			//We use only one sync handler
			Util_ITriggerHandler handler = handlerMap.get(SYNC)[0];

			if (Trigger.isBefore) {

				if (Trigger.isInsert) {
					handler.onBeforeInsertFunction();
				} else if (Trigger.isUpdate) {
					handler.onBeforeUpdateFunction();
				} else if (Trigger.isDelete) {
					handler.onBeforeDeleteFunction();
				}

			}

			if (Trigger.isAfter) {

				if (!isRecursion) {
					isRecursion = true;

					if (Trigger.isInsert) {
						handler.onAfterInsertFunction();
					}
					else if (Trigger.isUpdate) {
						handler.onAfterUpdateFunction();
					}
					else if (Trigger.isDelete) {
						handler.onAfterDeleteFunction();
					}
					else if (Trigger.isUndelete) {
						handler.onAfterUndeleteFunction();
					}

					syncHandler = handler;
				}
				else {
					executeAsyncHandler(handlerMap, ASYNC_UPDATE);
				}
			}

		}

	}

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Param: handlerMap - Map with handlers separated by a key (handler type) and a list handlers
	 * @Param: asyncKey - The key by which the list of handlers will be selected
	 * @Description:
	 *		Serves to search for the required list of handlers by the given key (asyncKey) and will execute an asynchronous start
	 */
	private static void executeAsyncHandler(Map<String, Util_ITriggerHandler[]> handlerMap, String asyncKey) {

		if (handlerMap.containsKey(asyncKey) && Trigger.isAfter) {
			executeQueueable(handlerMap.get(asyncKey), getUpdateRecordsForAsyncJob());
		}

	}


	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Param: handlerList - List with handlers
	 * @Param: updatedRecords - Updated records in the process of synchronous operation of a trigger,
	 * 							for transferring them to instances of asynchronous execution
	 * @Description:
	 *		Starts asynchronous execution of handlers (Queueable)
	 */
	private static void executeQueueable(Util_ITriggerHandler[] handlerList, SObject[] updatedRecords) {

		for (Util_ITriggerHandler handler : handlerList) {

			handler.setUpdatedRecordsFromList(updatedRecords);
			System.enqueueJob(handler);
		}
	}

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Description:
	 *		Searches for and sets the latest updated version of records.
	 *		If the records were passed to the synchronous handler, then these records are selected.
	 *		If there are no records, Trigger.new list will be selected
	 */
	private static SObject[] getUpdateRecordsForAsyncJob() {
		SObject[] updatedRecords = new SObject[]{};

		if (syncHandler != null) {
			updatedRecords = syncHandler.getUpdatedRecordsList();

			if (updatedRecords.isEmpty()) {
				updatedRecords = Trigger.new;
			}

		}
		else {
			updatedRecords = Trigger.new;
		}

		return updatedRecords;
	}

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 31/07/2019
	 * @Param: assignments - List with Trigger_Handler_Assignment__mdt custom metadata records
	 * @Description:
	 *		Serves to creates Map with handlers separated by a key (handler type) and a list handlers
	 *		and return this map
	 */
	private static Map<String, Trigger_Handler_Assignment__mdt[]> getAssignmentsByExecutionType(Trigger_Handler_Assignment__mdt[] assignments) {
		Map<String, Trigger_Handler_Assignment__mdt[]> assignmentsByType = new Map<String, Trigger_Handler_Assignment__mdt[]>();
		Integer asyncAssigment = 0;

		for (Trigger_Handler_Assignment__mdt assignment : assignments) {

			for (String key : EXECUTION_TYPE.keySet()) {

				if (assignment.Handler_Execution__c == EXECUTION_TYPE.get(key)) {

					//Can only be one synchronous assignment
	 				if (key == SYNC && !assignmentsByType.containsKey(key)) {
						assignmentsByType.put(key, new Trigger_Handler_Assignment__mdt[]{assignment});
					}
					//Can only be 50 asynchronous assignments
				 	else if (key != SYNC && asyncAssigment < ASYNC_LIMIT) {

						if (assignmentsByType.containsKey(key)) {
							assignmentsByType.get(key).add(assignment);
						}
						else {
							assignmentsByType.put(key, new Trigger_Handler_Assignment__mdt[]{assignment});
						}

						asyncAssigment++;
					}
				}

			}

		}

		return assignmentsByType;
	}
}