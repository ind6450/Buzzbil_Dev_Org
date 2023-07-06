/***************************************************************************************************************************
 * Name:        OpportunityTriggerHandlerTest
 * Description: OpportunityTriggerHandler test class
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 2020-July-14     Discussion Korea        Initial Version
 ****************************************************************************************************************************/

@isTest
public class OpportunityTriggerHandlerTest {
    //Create Test Records
    @testSetup static void staticRecords(){
        //custom setting
        Trigger_Manager__c Oppsetting = Trigger_Manager__c.getInstance(UserInfo.getOrganizationId());
        Oppsetting.Opportunity__c = true;
        upsert Oppsetting;

        //create Account
        List<Account> lstTestAccount = new List<Account>();
        List<Account> lstMediaRepAccount = TestDataFactory.createSalesAccounts(1, 'Media Rep', '기타');
        List<Account> lstAdvertiserAccount = TestDataFactory.createSalesAccounts(2, 'Advertiser', '식음료');
        List<Account> lstAgencyAccount = TestDataFactory.createSalesAccounts(1, 'Agency', '기타');
        lstTestAccount.addAll(lstMediaRepAccount);
        lstTestAccount.addAll(lstAdvertiserAccount);
        lstTestAccount.addAll(lstAgencyAccount);
        insert lstTestAccount;

        //Create Contact
        List<Contact> lstTestContact = TestDataFactory.createContacts(lstTestAccount[0].id, 1);
        insert lstTestContact;

    }

    @isTest
    static void OpportunityTriggerHandlerTest1() {
        List<Account> lstTestAccount = [Select Id, Type, Last_Closing_Date__c, Last_DealOwner__c FROM Account limit 4];
        List<Contact> lstTestContact = [Select Id FROM Contact];

        List<Account> lstMediaRepAccount = new List<Account>();
        List<Account> lstAdvertiserAccount = new List<Account>();
        List<Account> lstAgencyAccount = new List<Account>();
        for (Account acc: lstTestAccount){
            if(acc.Type == 'Media Rep'){
                lstMediaRepAccount.add(acc);
            }
            if(acc.Type == 'Advertiser'){
                lstAdvertiserAccount.add(acc);
            }
            if(acc.Type == 'Agency'){
                lstAgencyAccount.add(acc);
            }
        }

        List <Opportunity> lstOpptoInsert = new List<Opportunity>();

        id OpprecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sales_AgencyRep').getRecordTypeId();
        id OpprecordTypeId2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ADN').getRecordTypeId();
        id OpprecordTypeId3 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sales_Direct').getRecordTypeId();



        Opportunity Opp = new Opportunity();
        Opp.Name = 'Sample Oppty';
        Opp.RecordTypeId = OpprecordTypeId;
        Opp.Campaign_NewOrExisting__c = '기존';
        Opp.Competitor_ads__c = 'Cashslide';
        Opp.Category__c = '식음료';
        Opp.Advertiser__c = lstAdvertiserAccount[0].Id;
        Opp.Agency__c = lstAgencyAccount[0].Id;
        Opp.AccountId = lstMediaRepAccount[0].Id;
        Opp.rep__c  = lstMediaRepAccount[0].Id;
        Opp.Contact__c = lstTestContact[0].Id;
        Opp.SalesChannel__c = 'OC';
        Opp.Gross_Net__c = 'Gross';
        //Opp.Agency_Rep_FeeRate__c = 30;
        Opp.AdDivision__c = 'Paid';
        Opp.AdType__c = 'CPA';
        Opp.StageName = '체결'; // '제안서전달'; // DISCUSSION(Hoon):2022.04.19 - [단계변경] 게재신청체결 -> 체결 로 명칭 변경

        Opp.CloseDate = System.today();
        Opp.Campaign_Done__c = 'N';
        Opp.Amount = 10000;

        Opportunity Opp2 = new Opportunity();
        Opp2.Name = 'Sample Oppty 2';
        Opp2.RecordTypeId = OpprecordTypeId2;
        Opp2.Campaign_NewOrExisting__c = '기존';
        Opp2.Competitor_ads__c = 'Cashslide';
        Opp2.Category__c = '식음료';
        Opp2.Advertiser__c = lstAdvertiserAccount[0].Id;
        Opp2.Agency__c = lstAgencyAccount[0].Id;
        Opp2.AccountId = lstMediaRepAccount[0].Id;
        Opp2.rep__c  = lstMediaRepAccount[0].Id;
        Opp2.Contact__c = lstTestContact[0].Id;
        Opp2.SalesChannel__c = 'OC';
        Opp2.Gross_Net__c = 'Gross';
        //Opp2.Agency_Rep_FeeRate__c = 30;
        Opp2.AdDivision__c = 'Paid';
        Opp2.OpptyType__c = 'ADN 거래';

        Opp2.AdType__c = 'CPA';
        Opp2.StageName = '체결'; // '제안서전달'; // DISCUSSION(Hoon):2022.04.19 - [단계변경] 게재신청체결 -> 체결 로 명칭 변경
        Opp2.CloseDate = System.today().addDays(7);
        Opp2.Campaign_Done__c = 'N';
        Opp2.Amount = 10000;

        Opportunity Opp3 = new Opportunity();
        Opp3.Name = 'Sample Oppty 3';
        Opp3.RecordTypeId = OpprecordTypeId3;
        Opp3.Campaign_NewOrExisting__c = '기존';
        Opp3.Competitor_ads__c = 'Cashslide';
        Opp3.Category__c = '식음료';
        Opp3.Advertiser__c = lstAdvertiserAccount[0].Id;
        Opp3.Agency__c = lstAgencyAccount[0].Id;
        Opp3.AccountId = lstMediaRepAccount[0].Id;
        Opp3.rep__c  = lstMediaRepAccount[0].Id;
        Opp3.Contact__c = lstTestContact[0].Id;
        Opp3.SalesChannel__c = 'OC';
        Opp3.Gross_Net__c = 'Gross';
        //Opp3.Agency_Rep_FeeRate__c = 30;
        Opp3.AdDivision__c = 'Paid';
        Opp3.OpptyType__c = '광고주 직거래';

        Opp3.AdType__c = 'CPA';
        Opp3.StageName = '체결'; // '제안서전달'; // DISCUSSION(Hoon):2022.04.19 - [단계변경] 게재신청체결 -> 체결 로 명칭 변경
        Opp3.CloseDate = System.today().addDays(7);
        Opp3.Campaign_Done__c = 'N';
        Opp3.Amount = 10000;


        //inserting one by one to prevent process builder error
        insert Opp;
        insert Opp2;
        insert Opp3;
        Test.startTest();

        List <Opportunity> lstOpp = [Select Id, CloseDate, Advertiser__c, Amount FROM Opportunity ORDER BY CloseDate ASC];

        //Update amount to trigger change in fee
        lstOpp[0].Amount = 20000;
        Update lstOpp[0];

        lstOpp[0].Advertiser__c = lstAdvertiserAccount[1].Id;
        Update lstOpp[0];

        //delete with remaining closed Opportunity
        delete lstOpp[1];




        Test.stopTest();
    }

    @isTest
    static void OpportunityTriggerHandlerTest2() {
        List<Account> lstTestAccount = [Select Id, Type, Last_Closing_Date__c, Last_DealOwner__c FROM Account limit 4];
        List<Contact> lstTestContact = [Select Id FROM Contact];

        List<Account> lstMediaRepAccount = new List<Account>();
        List<Account> lstAdvertiserAccount = new List<Account>();
        List<Account> lstAgencyAccount = new List<Account>();
        for (Account acc: lstTestAccount){
            if(acc.Type == 'Media Rep'){
                lstMediaRepAccount.add(acc);
            }
            if(acc.Type == 'Advertiser'){
                lstAdvertiserAccount.add(acc);
            }
            if(acc.Type == 'Agency'){
                lstAgencyAccount.add(acc);
            }

        }

        List <Opportunity> lstOpptoInsert = new List<Opportunity>();

        id OpprecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sales_AgencyRep').getRecordTypeId();

        Opportunity Opp = new Opportunity();
        Opp.Name = 'Sample Oppty';
        Opp.RecordTypeId = OpprecordTypeId;
        Opp.Campaign_NewOrExisting__c = '기존';
        Opp.Competitor_ads__c = 'Cashslide';
        Opp.Category__c = '식음료';
        Opp.Advertiser__c = lstAdvertiserAccount[0].Id;
        Opp.Agency__c = lstAgencyAccount[0].Id;
        Opp.AccountId = lstMediaRepAccount[0].Id;
        Opp.rep__c  = lstMediaRepAccount[0].Id;
        Opp.Contact__c = lstTestContact[0].Id;
        Opp.SalesChannel__c = 'OC';
        Opp.Gross_Net__c = 'Gross';
        Opp.LandingURL__c = 'https://youtu.be/KhCMHnyNJes';
        //Opp.Agency_Rep_FeeRate__c = 30;
        Opp.AdDivision__c = 'Paid';
        Opp.OpptyType__c = '광고주-대행사-랩사 거래';
        Opp.AdType__c = 'CPA';
        Opp.StageName = '체결'; // '제안서전달'; // DISCUSSION(Hoon):2022.04.19 - [단계변경] 게재신청체결 -> 체결 로 명칭 변경
        Opp.CloseDate = System.today();
        Opp.Campaign_Done__c = 'N';
        Opp.Amount = 10000;


        Test.startTest();

        //inserting one by one to prevent process builder error
        insert Opp;

        Opp.LandingURL__c = 'https://youtu.be/6zZw5J6GK4E';
        update  Opp;

        List <Opportunity> lstOpp = [Select Id, CloseDate, Advertiser__c, Amount FROM Opportunity ORDER BY CloseDate ASC];

        lstOpp[0].Advertiser__c = lstAdvertiserAccount[1].Id;
        Update lstOpp[0];

        //delete with remaining closed Opportunity
        System.debug('delete ::::::::::');
        delete lstOpp[0];


        OpportunityTriggerHandler testCount = new OpportunityTriggerHandler();
        testCount.indexCount();

        Test.stopTest();
    }

}