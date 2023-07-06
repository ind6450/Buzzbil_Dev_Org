public class tri_ClientTeamHandler extends TriggerHandler {

    private List<Client_Team__c> listNew;
    private List<Client_Team__c> listOld;
    private Map<Id,Client_Team__c> mapNew;
    private Map<Id,Client_Team__c> mapOld;

    public tri_ClientTeamHandler() {
        this.listNew = (List<Client_Team__c>)Trigger.new;
        this.listOld = (List<Client_Team__c>)Trigger.old;
        this.mapNew = (Map<Id,Client_Team__c>)Trigger.newMap;
        this.mapOld = (Map<Id,Client_Team__c>)Trigger.oldMap;
    }

    public override void afterDelete() {
        doUpdateAccount(listOld);
        doDeleteAgencyActivities(listOld);
    }

    // Account update - Agency_PartA_Owner, Agency_PartA_LastMeetingDate, Agency_PartA_LastClosingDate, 
    //                Agency_PartB_Owner, Agency_PartB_LastMeetingDate, Agency_PartB_LastClosingDate
    private void doUpdateAccount(List<Client_Team__c> listClientTeam) {
        Set<Id> setIdAccount_partA = new Set<Id>();
        Set<Id> setIdAccount_partB = new Set<Id>();

        for(Client_Team__c obj:listClientTeam) {
            if(obj.Client__c !=null && obj.Team_Role__c=='Part A') {
                setIdAccount_partA.add(obj.Client__c);
            } else if(obj.Client__c != null && obj.Team_Role__c=='Part B') {
                setIdAccount_partB.add(obj.Client__c);
            }
        }

        List<Account> clientListToUpdate = new List<Account>();

        if(!setIdAccount_partA.isEmpty()){
            List<Account> clientListA = [SELECT Id, Agency_PartA_Owner__c FROM Account WHERE Id in: setIdAccount_partA];

            for(Account client:clientListA){
                client.Agency_PartA_Owner__c = null;
                clientListToUpdate.add(client);
            }
        }

        if(!setIdAccount_partB.isEmpty()) {
            List<Account> clientListB = [SELECT Id, Agency_PartB_Owner__c FROM Account WHERE Id in: setIdAccount_partB];

            for(Account client:clientListB){
                client.Agency_PartB_Owner__c = null;
                clientListToUpdate.add(client);
            }
        }

        if(clientListToUpdate.size()!=0) {
            Update clientListToUpdate;
        }
    }

    // Delete related Agency_Activities
    private void doDeleteAgencyActivities(list<Client_Team__c> listClientTeam) {
        Set<Id> setIdAccount_partA = new Set<Id>();
        Set<Id> setIdAccount_partB = new Set<Id>();

        for(Client_Team__c obj:listClientTeam) {
            if(obj.Client__c !=null && obj.Team_Role__c=='Part A') {
                setIdAccount_partA.add(obj.Client__c);
            } else if(obj.Client__c != null && obj.Team_Role__c=='Part B') {
                setIdAccount_partB.add(obj.Client__c);
            }
        }

        List<Agency_Activities__c> deleteList = new List<Agency_Activities__c>();

        // Part A - Agency activities 
        if(!setIdAccount_partA.isEmpty()) {
            List<Agency_Activities__c> list_partA = [SELECT Id FROM Agency_Activities__c WHERE Agency__c in: setIdAccount_partA AND Department__c LIKE '%_Part A'];
        
            for(Agency_Activities__c agencyActivity:list_partA) {
                deleteList.add(agencyActivity);
            }
        }

        if(!setIdAccount_partB.isEmpty()) {
            List<Agency_Activities__c> list_partB = [SELECT Id FROM Agency_Activities__c WHERE Agency__c in: setIdAccount_partB AND Department__c LIKE '%_Part B'];

            for(Agency_Activities__c agencyActivity:list_partB) {
                deleteList.add(agencyActivity);
            }
        }

        if(!deleteList.isEmpty()) {

            try{
                delete deleteList;

            } catch(DmlException e) {

            }
        }

    }
}