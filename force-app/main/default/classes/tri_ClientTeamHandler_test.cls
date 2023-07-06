@isTest
private class tri_ClientTeamHandler_test {

    @isTest static void test_method_one() {

        User testUser = new User();
        testUser.Username = 'test@abc_buzzvil.com';
        testUser.LastName = 'test';
        testUser.Alias='Buzzvil';
        testUser.CommunityNickname = 'testBuzzvil';
        testUser.Email = 'test@abc.com';
        testUser.ProfileId = '00e28000000UCe2AAG'; 
        testUser.TimeZoneSidKey = 'Asia/Seoul';
        testUser.LocaleSidKey = 'ko_KR';
        testUser.EmailEncodingKey = 'UTF-8';
        testUser.LanguageLocaleKey = 'en_US';
        insert testUser;

        Account objAccnt = new Account();
        objAccnt.Name = 'test account';
        objAccnt.Agency_PartA_Owner__c = testUser.Id;
        objAccnt.Agency_PartB_Owner__c = testUser.Id;
        insert objAccnt;

        Client_Team__c objClientTeamA = new Client_Team__c();
        objClientTeamA.Client__c = objAccnt.Id;
        objClientTeamA.Team_Role__c = 'Category A';
        objClientTeamA.Name__c = testUser.Id;
        insert objClientTeamA;

        Client_Team__c objClientTeamB = new Client_Team__c();
        objClientTeamB.Client__c = objAccnt.Id;
        objClientTeamB.Team_Role__c = 'Category B';
        objClientTeamB.Name__c = testUser.Id;
        insert objClientTeamB;

        delete objClientTeamA;
        delete objClientTeamB;
        
        Agency_Activities__c objActA = new Agency_Activities__c();
        objActA.Type__c = 'Meeting';
        objActA.Date__c = System.today();
        objActA.Owner__c = testUser.Id;
        objActA.Department__c = 'KR_Sales_Hunter';
        objActA.Agency__c = objAccnt.Id;
        insert objActA;

        Agency_Activities__c objActB = new Agency_Activities__c();
        objActB.Type__c = 'Meeting';
        objActB.Date__c = System.today();
        objActB.Owner__c = testUser.Id;
        objActB.Department__c = 'KR_Sales_Farmer';
        objActB.Agency__c = objAccnt.Id;
        insert objActB;

        delete objActA;
        delete objActB;

        objAccnt.Agency_PartB_Owner__c = null;
        objAccnt.Agency_PartA_Owner__c = null;
        update objAccnt;

    }

}