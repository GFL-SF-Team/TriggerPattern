/*
 * @Author: Aleksandr Shcherbanyuk
 * @Date: 01/08/2019
 * @Description:
 *		Trigger for test coverage and example
 */

trigger TestCoverageObjectTrigger on Test_Coverage_Object__c (
		before insert,
		before update,
		before delete,
		after insert,
		after update,
		after delete,
		after undelete
) {

	//Call Trigger patter API for execute Trigger Handlers (Sync and Async)
	Util_TriggerPattern_API.executeObjectTriggerHandlers();

}