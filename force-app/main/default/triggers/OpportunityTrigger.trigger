trigger OpportunityTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after undelete, after delete) {
    
    if (Trigger_Manager__c.getInstance() != null &&
        Trigger_Manager__c.getInstance().Opportunity__c) {
        System.debug('### Opportunity Trigger-1 : ' + Trigger_Manager__c.getInstance());
        System.debug('### Opportunity Trigger-2 : ' + Trigger_Manager__c.getInstance().Opportunity__c);
        new OpportunityTriggerHandler().run();
        
    }   
}