public class TaskTriggerHandler extends TriggerHandler {
    
    public List<Task> lstoldTask {
        get {
            return (List<Task> ) Trigger.old;
        }
        private set;
    }

    public List<Task> lstNewTask {
        get {
            return (List<Task> ) Trigger.new;
        }
        private set;
    }

    public map<id, Task> mapOldTask{
        get {
            return (map<id, Task>) Trigger.oldMap;
        }
        private set;
    }

    public override void beforeDelete() {
        UpdateLastMeetingDetails(lstoldTask);
    }

    public override void beforeUpdate(){
        System.debug('# Before Update');
        UpdateTaskActivityMeasured(lstNewTask);
    }

    public override void beforeInsert(){
        System.debug('# Before Insert');
        UpdateTaskActivityMeasured(lstNewTask);
    }

    /**
     * @description Method to update Client/Contact field below
     *  - Last MeetingDate
     *  - Last MeetingOwner
     *  - Last Call Date    <- new
     *  - Last Call Owner   <- new
     *  - Last Mail Date    <- new
     *  - Last Mail Owner   <- new
     *  - Last Deal Date    <- new
     *  - Last Deal Owner   <- new
     */
    public void UpdateTaskActivityMeasured(List<Task> lstNewTasks){
        Set<Id> setRelAccountId = new set<Id>();
        Set<Id> setRelContactId = new set<Id>();
        List<Account> lstAccountToUpdate = new List<Account>();
        List<Contact> lstContactToUpdate = new List<Contact>();

        List<Account> lstSelectAccounts = new List<Account>();
        List<Contact> lstSelectContacts = new List<Contact>();

        for (Task taskrec: lstNewTasks){

            if(taskrec.Type == 'Meeting' || taskrec.Type == 'Meeting_신규' || taskrec.Type == 'Meeting_기존') {
                // Type : Meeting


            }
            else if(taskrec.Type == 'Call' || taskrec.Type == 'Call_신규' || taskrec.Type == 'Call_기존'){
                // Type : Call

            }
            else if(taskrec.Type == 'Email' || taskrec.Type == 'Email_신규' || taskrec.Type == 'Email_기존'){
                // type : Email

            }
            // Deal 없음.




            //get related account
            if((taskrec.Type == 'Meeting' || taskrec.Type == 'Meeting_신규' || taskrec.Type == 'Meeting_기존')){

                //check if it has related account
                if(taskrec.AccountId != null){
                    setRelAccountId.add(taskrec.AccountId);
                }

                //check if it has WHOID
                if(taskrec.WhoId != null){
                    //check if WHOID is a contact
                    if(taskrec.WhoId.getSObjectType().getDescribe().getName() == 'Contact'){
                        setRelContactId.add(taskrec.WhoId);
                    }
                }
            }
        }
    }
    
    /**
    *   @description Method to update Client/Contact Last Meeting Date and Last Meeting Owner
    *                On Client and Contact
    **/
    public void UpdateLastMeetingDetails(List <Task> lstoldTask) {
        set<Id> setRelAccountId = new set<Id>();
        set<ID> setRelContactId = new set<Id>();
        List<Account> lstAccountToUpdate = new List<Account>();
        List<Contact> lstContactToUpdate = new List<Contact>();
        
        for (Task taskrec: lstoldTask){

            //get related account
            if((taskrec.Type == 'Meeting' || taskrec.Type == 'Meeting_신규' || taskrec.Type == 'Meeting_기존')){
                
                //check if it has related account
                if(taskrec.AccountId != null){
                    setRelAccountId.add(taskrec.AccountId);
                }
                
                //check if it has WHOID
                if(taskrec.WhoId != null){
                    //check if WHOID is a contact
                    if(taskrec.WhoId.getSObjectType().getDescribe().getName() == 'Contact'){
                        setRelContactId.add(taskrec.WhoId);
                    }
                }
            }
        }
        
        //Query Related Account
        List<Account> lstRelAccount = [Select id, Last_MeetingDate__c, Last_MeetingOwner__c FROM Account WHERE Id in: setRelAccountId];
        Map<Id, Account> mapRelAccount = new Map<Id, Account>(lstRelAccount);
        
        List<Contact> lstRelContact = [Select Id, Last_MeetingDate__c, Last_MeetingOwner__c FROM Contact WHERE Id in: setRelContactId];
        Map<Id, Contact> mapRelContact = new Map<Id, Contact>(lstRelContact);
        
        //Query tasks of related Account and Contact
        List<Task> lstremainingTask = [Select Id, ActivityDate, OwnerId, AccountId, WhoId FROM TASK WHERE 
                                       (Type = 'Meeting' OR Type = 'Meeting_신규' OR Type = 'Meeting_기존') AND (AccountId in: setRelAccountId OR WhoId in: setRelContactId)];
        
        Map<Id, list<Task>> mapAccTask = new Map <Id, list<Task>>();
        
        for(Task remainingtask: lstremainingTask){
            if(mapAccTask.containsKey(remainingtask.AccountId)){
                mapAccTask.get(remainingtask.AccountId).add(remainingtask);
            }else{
                list<Task> newlsttask = new list<task>();
                newlsttask.add(remainingtask);
                mapAccTask.put(remainingtask.AccountId, newlsttask);
            }
        }
        
        Map<Id, list<Task>> mapConTask = new Map <Id, list<Task>>();
        for(Task remainingtask: lstremainingTask){
            if(mapConTask.containsKey(remainingtask.WhoId)){
                mapConTask.get(remainingtask.WhoId).add(remainingtask);
            }else{
                list<Task> newlsttask = new list<task>();
                newlsttask.add(remainingtask);
                mapConTask.put(remainingtask.WhoId, newlsttask);
            }
        }
        
        for (Task taskrec: lstoldTask){
            
            //Account
            if(mapRelAccount.containsKey(taskrec.AccountId)) {
                account a = mapRelAccount.get(taskrec.AccountId);
                a.Last_MeetingDate__c = null;
                a.Last_MeetingOwner__c = null;

                if (mapAccTask.containskey(taskrec.AccountId)) {
                    for (Task childtask : mapAccTask.get(taskrec.AccountId)) {
                        if (childtask.Id != taskrec.Id) {
                            if (a.Last_MeetingDate__c == null) {
                                a.Last_MeetingDate__c = childtask.ActivityDate;
                                a.Last_MeetingOwner__c = childtask.OwnerId;
                            } else if (a.Last_MeetingDate__c < childtask.ActivityDate) {
                                a.Last_MeetingDate__c = childtask.ActivityDate;
                                a.Last_MeetingOwner__c = childtask.OwnerId;
                            }
                        }
                    }
                }

                lstAccounttoUpdate.add(a);
            }
            //Contact
            if(mapRelContact.containsKey(taskrec.WhoId)) {
                Contact c = mapRelContact.get(taskrec.WhoId);
                c.Last_MeetingDate__c = null;
                c.Last_MeetingOwner__c = null;

                if (mapConTask.containskey(taskrec.WhoId)) {
                    for (Task childtask : mapConTask.get(taskrec.WhoId)) {
                        if (childtask.Id != taskrec.Id) {
                            if (c.Last_MeetingDate__c == null) {
                                c.Last_MeetingDate__c = childtask.ActivityDate;
                                c.Last_MeetingOwner__c = childtask.OwnerId;
                            } else if (c.Last_MeetingDate__c < childtask.ActivityDate) {
                                c.Last_MeetingDate__c = childtask.ActivityDate;
                                c.Last_MeetingOwner__c = childtask.OwnerId;
                            }
                        }
                    }
                }

                lstContacttoUpdate.add(c);
            }
        }
        
        if(!lstAccounttoUpdate.isEmpty()){
            update lstAccounttoUpdate;
        }
        
        if(!lstContacttoUpdate.isEmpty()){
            Update lstContacttoUpdate;
        }
        
    }
    
    

}