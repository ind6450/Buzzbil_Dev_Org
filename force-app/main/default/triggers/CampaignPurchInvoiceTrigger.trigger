trigger CampaignPurchInvoiceTrigger on CampaignPurchaseInvoice__c (before insert, before update, before delete, after insert, after update, after undelete) {
    
    if (Trigger_Manager__c.getInstance() != null &&
        Trigger_Manager__c.getInstance().CampaignPurchaseInvoice__c) {

        new CampaignPurchInvoiceTriggerHandler().run();
        
    }   
}