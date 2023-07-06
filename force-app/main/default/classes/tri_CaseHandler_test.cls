@isTest
private class tri_CaseHandler_test {

	@isTest static void test_method_one() {
		Account objAccnt = new Account();
		objAccnt.Name = 'test account';
		objAccnt.Domain_URL_Check__c = true;
		insert objAccnt;

		Opportunity objOppty = new Opportunity();
		objOppty.Name = 'test';
		objOppty.closeDate = System.today();
		objOppty.AccountId = objAccnt.Id;
		objOppty.StageName = 'Live';
		insert objOppty;

		Opportunity objOppty2 = new Opportunity();
		objOppty2.Name = 'test';
		objOppty2.closeDate = System.today();
		objOppty2.AccountId = objAccnt.Id;
		objOppty2.StageName = 'Live';
		insert objOppty2;

		Case objCase = new Case();
		objCase.Subject = 'test';
		objCase.Compensation_Amount__c = 1000;
		objCase.Additional_Amount__c = 2000;
		objCase.Promotion__c = 2000;
		objCase.OpptyName__c = objOppty.Id;
		insert objCase;

		objCase.Additional_Amount__c = 0;
		update objCase;

		objCase.OpptyName__c = objOppty2.Id;
		update objCase;

	}

	@isTest static void test_method_two() {
		// Implement test code
	}

}