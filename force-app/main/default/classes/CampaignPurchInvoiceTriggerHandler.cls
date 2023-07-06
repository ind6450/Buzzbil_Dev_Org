public class CampaignPurchInvoiceTriggerHandler extends TriggerHandler {
    
    public List<CampaignPurchaseInvoice__c> lstnewCampaignPurchaseInvoice {
        get {
            return (List<CampaignPurchaseInvoice__c> ) Trigger.new;
        }
        private set;
    }
    
    public override void afterInsert() {
        CreateSalesInfo (lstnewCampaignPurchaseInvoice);
    }

    /**
    *   @description Method to Create new Sales Info when Campaign Purchase invoice is created
    **/
    
    public void CreateSalesInfo(List <CampaignPurchaseInvoice__c> lstnewCampaignPurchaseInvoice) {
        id PurchaseRT = Schema.SObjectType.SalsInfo__c.getRecordTypeInfosByDeveloperName().get('RecordType_Purchase').getRecordTypeId();
        List<SalsInfo__c> upsertSalesInfos = new List<SalsInfo__c>();
        Set<Id> cids = new Set<Id>();
        Set<Id> Pids = new Set<Id>();
        for(CampaignPurchaseInvoice__c cpiRec: lstnewCampaignPurchaseInvoice){
            cids.add(cpiRec.OpptyName__c);
            Pids.add(cpiRec.PurchaseInvoiceName__c);
        }
        map<Id, PurchaseInvoice__c> purchaseInvoiceMap = new map<Id , PurchaseInvoice__c>([SELECT Id, SupplyValue__c FROM PurchaseInvoice__c
        WHERE ID IN: Pids]);
        List<SalsInfo__c> lstSalesInfo = [SELECT ID, Date__c, PurchaseType__c, Receipt__c,CampaignName__c, RecordTypeId, Amount__c
                                            FROM SalsInfo__c WHERE RecordTypeId=:PurchaseRT AND CampaignName__c In: cids];
system.debug('oppt:'+lstSalesInfo);
        //TotalAmount__c
        for(CampaignPurchaseInvoice__c cpiRec: lstnewCampaignPurchaseInvoice){
            SalsInfo__c siRec = new SalsInfo__c();
            for(SalsInfo__c temp:lstSalesInfo){
                if(cpiRec.OpptyName__c == temp.CampaignName__c){
                    siRec = temp;
                }
            }
            if(siRec.Id == null){
                siRec.Date__c = cpiRec.CreatedDate__c;
                siRec.PurchaseType__c = 'Agency fee';
                siRec.Receipt__c = 'Y';
                siRec.CampaignName__c = cpiRec.OpptyName__c;
                siRec.RecordTypeId = PurchaseRT;
                siRec.Amount__c = purchaseInvoiceMap.get(cpiRec.PurchaseInvoiceName__c).SupplyValue__c;
            }else{
                siRec.Amount__c = siRec.Amount__c+purchaseInvoiceMap.get(cpiRec.PurchaseInvoiceName__c).SupplyValue__c;
            }
            upsertSalesInfos.add(siRec);
        }
        
        if(upsertSalesInfos.size() > 0){
            upsert upsertSalesInfos;
        }
    }
}