/***************************************************************************************************************************
 * Name:        TaskTriggerHandlerTest
 * Description: TaskTriggerHandler test class
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 2020-July-14     Discussion Korea        Initial Version
 ****************************************************************************************************************************/

@isTest
public class TaskTriggerHandlerTest {
    
    //Create Test Records
    @testSetup static void staticRecords(){
        //custom setting
        Trigger_Manager__c tasksetting = Trigger_Manager__c.getInstance(UserInfo.getOrganizationId());
        tasksetting.Task__c = true;
        upsert tasksetting;
        
        //create Account
        List<Account> lstTestAccount = TestDataFactory.createSalesAccounts(1, 'Media Rep', '기타');
        insert lstTestAccount;
        
        //Create Contact
        List<Contact> lstTestContact = TestDataFactory.createContacts(lstTestAccount[0].id, 1);
        insert lstTestContact;
        
        //Create Task
        List<Task> lstTestTask = TestDataFactory.createSalesTasks(5,lstTestAccount[0].id,lstTestContact[0].id, 'Meeting_신규'  );
        insert lstTestTask;
    }
    
    @isTest 
    static void UpdateLastMeetingDetailsTest() {
        List<Task> lstTestTask = [Select Id, ActivityDate, OwnerId, AccountId, WhoId, Type FROM TASK ORDER By ActivityDate ASC];
        
        Test.startTest();
            //delete with remaining task
            delete lstTestTask[4];
        
            //delete succeeding task
            delete lstTestTask[3];
        Test.stopTest();
    }
    
    
}