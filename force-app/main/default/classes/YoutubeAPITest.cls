/**
 * Created by MZC01-JEREMIAH on 2023-01-12
 */
@IsTest
public with sharing class YoutubeAPITest {

    @TestSetup
    public static void staticRecords () {

        List<Account> lstAgencyAccount = TestDataFactory.createSalesAccounts(1, 'Agency', '기타');

        insert lstAgencyAccount;

        List<Contact> lstTestContact = TestDataFactory.createContacts(lstAgencyAccount[0].Id, 1);
        insert lstTestContact;

        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sales_AgencyRep').getRecordTypeId();

        Opportunity opp = new Opportunity(
                Name = 'Test Youtube API',
                AccountId = lstAgencyAccount[0].Id,
                RecordTypeId = oppRecordTypeId,
                AdDivision__c = 'Paid',
                Agency__c = lstAgencyAccount[0].Id,
                rep__c = lstAgencyAccount[0].Id,
                Contact__c = lstTestContact[0].Id,
                SalesChannel__c = 'OC',
                Gross_Net__c = 'Gross',
                AdType__c = 'CPA',
                StageName = '체결',
                Campaign_Done__c = 'N',
                Amount = 1000,
                CloseDate = System.today(),
                Youtube_URL__c = 'https://youtu.be/JAHYIyRScVk'
        );

        insert opp;

    }

    @IsTest
    public static void testYoutubeAPI() {
        List<Opportunity> testOpp = [SELECT Id, Youtube_URL__c FROM Opportunity WHERE Name = 'Test Youtube API'];
        YoutubeAPI ya = new YoutubeAPI(testOpp);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new YoutubeAPIMock());
        System.enqueueJob(ya);
        Test.stopTest();
    }

}