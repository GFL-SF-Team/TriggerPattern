/*
 * @Author: Aleksandr Shcherbanyuk
 * @Date: 01/08/2019
 * @Description:
 * 		TestCoverageObjectTriggerHandlerTest class for coverage Trigger Pattern functionality
 */
@IsTest
private class TestCoverageObjectTriggerHandlerTest {

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 01/08/2019
	 * @Description:
	 * 		Setup for test class
	 */
	@TestSetup static void setup() {
		createEnvironmentForTest();
	}

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 01/08/2019
	 * @Description:
	 * 		After setup ran, we have 2 async "all execution" - on insert + 3 on delete (One transaction we have recursion)
	 */
	@IsTest static void testQueueableJobs() {
		System.assertEquals(5, [SELECT Status, NumberOfErrors FROM AsyncApexJob].size());
	}

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 01/08/2019
	 * @Description:
	 * 		Method for covering functionality on insert
	 */
	@IsTest static void testInsertObject() {
		System.assertEquals(2, [SELECT Id FROM Test_Coverage_Object__c].size());
	}

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 01/08/2019
	 * @Description:
	 * 		Method for covering functionality on update
	 */
	@IsTest static void testUpdateObjects() {
		Test.startTest();
		Test_Coverage_Object__c[] records = getTestObjects();

		for (Test_Coverage_Object__c record : records) {
			record.Number__c += record.Number__c;
		}

		update records;
		Test.stopTest();

		for (Test_Coverage_Object__c record : getTestObjects()) {

			if (record.Name == 'For Test1') {
				System.assertEquals(2, record.Number__c);
			}
			else if (record.Name == 'For Test2') {
				System.assertEquals(4, record.Number__c);
			}

		}
	}

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 01/08/2019
	 * @Description:
	 * 		Method for covering functionality on Delete
	 */
	@IsTest static void testDeleteObjects() {
		Test_Coverage_Object__c[] records = getTestObjects();

		delete records;

		System.assertEquals(0, [SELECT Id FROM Test_Coverage_Object__c].size());
	}

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 01/08/2019
	 * @Description:
	 * 		Method for covering functionality on Undelete
	 */
	@IsTest static void testUndeleteObjects() {

		undelete [SELECT Id FROM Test_Coverage_Object__c WHERE Name = 'Undelete' ALL ROWS];

		System.assertEquals(3, getTestObjects().size());
	}

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 01/08/2019
	 * @Description:
	 * 		The method returns all Test_Coverage_Object__c records
	 */
	static Test_Coverage_Object__c[] getTestObjects() {
		return [
			SELECT Id, Name, Number__c FROM Test_Coverage_Object__c ORDER BY Number__c
		];
	}

	/*
	 * @Author: Aleksandr Shcherbanyuk
	 * @Date: 01/08/2019
	 * @Description:
	 * 		The main method for creating the environment before the test
	 */
	static void createEnvironmentForTest() {
		try {


			insert new Test_Coverage_Object__c[]{
					new Test_Coverage_Object__c(Name ='For Test1', Number__c = 1),
					new Test_Coverage_Object__c(Name ='For Test2', Number__c = 2),
					new Test_Coverage_Object__c(Name ='Undelete', Number__c = 3)
			};

			delete [SELECT Id FROM Test_Coverage_Object__c WHERE Number__c = 3];

		} catch (Exception e) {
			System.debug('Error Test - TestCoverageObjectTriggerHandlerTest.createEnvironmentForTest: ' + e.getMessage() + ' Line: ' +e.getLineNumber());
		}
	}
}