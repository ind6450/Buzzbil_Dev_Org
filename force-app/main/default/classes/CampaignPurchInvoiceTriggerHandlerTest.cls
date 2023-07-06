/***************************************************************************************************************************
 * Name:        CampaignPurchInvoiceTriggerHandlerTest
 * Description: CampaignPurchInvoiceTriggerHandler test class
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 2020-July-15     Discussion Korea        Initial Version
 ****************************************************************************************************************************/
@isTest
public class CampaignPurchInvoiceTriggerHandlerTest {
    
    //create test records
    @testSetup static void staticRecords(){
        //custom setting
        Trigger_Manager__c CPIsetting = Trigger_Manager__c.getInstance(UserInfo.getOrganizationId());
        CPIsetting.CampaignPurchaseInvoice__c = true;
        upsert CPIsetting;
        
        //create Account
        List<Account> lstTestAccount = new List<Account>();
        List<Account> lstMediaRepAccount = TestDataFactory.createSalesAccounts(1, 'Media Rep', '기타');
        List<Account> lstAdvertiserAccount = TestDataFactory.createSalesAccounts(1, 'Advertiser', '식음료');
        List<Account> lstAgencyAccount = TestDataFactory.createSalesAccounts(1, 'Agency', '기타');
        lstTestAccount.addAll(lstMediaRepAccount);
        lstTestAccount.addAll(lstAdvertiserAccount);
        lstTestAccount.addAll(lstAgencyAccount);
        insert lstTestAccount;
        
        //Create Contact
        List<Contact> lstTestContact = TestDataFactory.createContacts(lstTestAccount[0].id, 1);
        insert lstTestContact;
        
        
        //Create Opportunity
        List<Account> lstMRAccount = new List<Account>();
        List<Account> lstAdvAccount = new List<Account>();
        List<Account> lstAgncyAccount = new List<Account>();
        for (Account acc: lstTestAccount){
            if(acc.Type == 'Media Rep'){
                lstMRAccount.add(acc);
            }
            if(acc.Type == 'Advertiser'){
                lstAdvAccount.add(acc);
            }
            if(acc.Type == 'Agency'){
                lstAgncyAccount.add(acc);
            }
            
        }
        
        id OpprecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sales_AgencyRep').getRecordTypeId();
        
        
            
        Opportunity Opp = new Opportunity();
        Opp.Name = 'Sample Oppty';
        Opp.RecordTypeId = OpprecordTypeId;
        Opp.Campaign_NewOrExisting__c = '기존';
        Opp.Competitor_ads__c = 'Cashslide';
        Opp.Category__c = '식음료';
        Opp.Advertiser__c = lstAdvAccount[0].Id;
        Opp.Agency__c = lstAgncyAccount[0].Id;
        Opp.AccountId = lstMRAccount[0].Id;
        Opp.rep__c  = lstMRAccount[0].Id;
        Opp.Contact__c = lstTestContact[0].Id;
        Opp.SalesChannel__c = 'OC';
        Opp.Gross_Net__c = 'Gross';
        Opp.Agency_Rep_FeeRate__c = 30;
        Opp.AdDivision__c = 'Paid';
        Opp.AdType__c = 'CPA';
        Opp.StageName = '제안'; // DISCUSSION(Hoon):2022.04.19 - [단계변경] 제안서전달 -> 제안으로 명칭 변경
        Opp.CloseDate = System.today(); 
        Opp.Campaign_Done__c = 'N';
        Opp.Amount = 10000;
        
        Insert Opp;
        
        //Create Purchase Invoice
        List<PurchaseInvoice__c> lstpurchaseInvoice = TestDataFactory.createPurchaseInvoice(1);
        
        Insert lstpurchaseInvoice;

    }
    
    @isTest 
    static void CreateSalesInfoTest() {
        List<Opportunity> lstOpp = [Select Id FROM Opportunity];
        List<PurchaseInvoice__c> lstPI = [Select Id FROM PurchaseInvoice__c];
        
        CampaignPurchaseInvoice__c cpirec = new CampaignPurchaseInvoice__c();
        cpirec.OpptyName__c = lstOpp[0].Id;
        cpirec.PurchaseInvoiceName__c = lstPI[0].Id;
        
        Test.startTest();
            Insert cpirec;
        Test.stopTest();
    }

}