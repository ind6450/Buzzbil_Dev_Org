trigger tri_ClientTeam on Client_Team__c (after delete) {
    new tri_ClientTeamHandler().run();
}