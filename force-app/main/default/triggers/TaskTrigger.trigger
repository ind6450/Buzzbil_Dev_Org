trigger TaskTrigger on Task (before insert, before update, before delete, after insert, after update, after undelete) {
    
    
    if (Trigger_Manager__c.getInstance() != null &&
        Trigger_Manager__c.getInstance().Task__c) {

        new TaskTriggerHandler().run();
        
    }                     
                     

}