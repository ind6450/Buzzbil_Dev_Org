/***************************************************************************************************************************
 * Name:        TestDataFactory
 * Description: Common Data Factory for all Test Classes
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 2020-July-14     Discussion Korea        Initial Version
 ****************************************************************************************************************************/
@isTest
public class TestDataFactory {
    
    //Account
    public static List<Account> createSalesAccounts(Integer numberOfAccounts, string strType, string strCategory) {
        id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SL').getRecordTypeId();
        List<Account> accountList = new List<Account>();
        for (Integer i = 0 ; i < numberOfAccounts ; i++ ) {
            Account a = new Account(recordTypeId = recordTypeId, name = 'Test Account' + i, type = strType, category_account__c = strCategory, Domain_URL_Check__c = true);
            accountList.add(a);
        }
        return accountList;
    }
    
    //contact
    public static List<Contact> createContacts(Id accid, Integer numberOfContacts) {
        List<Contact> ContactList = new List<Contact>();
        for (Integer i = 0 ; i < numberOfContacts ; i++ ) {
            Contact c = new Contact(
                AccountId = accid, 
                Salutation = 'Mr.',
                FirstName = 'TestDataFactory',
                LastName = 'Test Contact' + i, 
                Email = 'test' + i + '@qq.com'
            );
            ContactList.add(c);
        }
        return ContactList;
    }
    
    //Sales Task
    public static List<Task> createSalesTasks(Integer numberOfTask, Id relAccountId, Id relContactId, string stractivitytype ) {
        id TaskRtId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Sales').getRecordTypeId();
        List<Task> TaskList = new List<Task>();
        for (Integer i = 0 ; i < numberOfTask ; i++ ) {
            Task t = new Task(WhatId = relAccountId, WhoId = relContactId, Type = stractivitytype, ActivityDate = system.today().addDays(i));
                
            
            TaskList.add(t);
        }
        return TaskList;
    }
    
    //Create Purchase Invoice
    public static List<PurchaseInvoice__c> createPurchaseInvoice(Integer numberOfPurchaseInvoice){
        List<PurchaseInvoice__c> lstpurchaseInvoice = new List<PurchaseInvoice__c>();
        for (Integer i = 0 ; i < numberOfPurchaseInvoice ; i++ ) {
            PurchaseInvoice__c pi = new PurchaseInvoice__c(CreatedDate__c = system.today(), 
                                                           Approval_number__c = '12345',
                                                           TransferDate__c = system.today(),
                                                           SupplyValue__c = 1000000
                                                           );
                
            
            lstpurchaseInvoice.add(pi);
        }
        return lstpurchaseInvoice;
    }


}