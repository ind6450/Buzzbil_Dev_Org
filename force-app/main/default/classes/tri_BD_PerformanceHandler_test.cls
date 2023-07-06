@isTest
private class tri_BD_PerformanceHandler_test {

	@isTest static void test_method_one() {
		BD_Performance__c obj = new BD_Performance__c();
		obj.Data_Source__c ='aaa';
		obj.Date_R__c = System.today();
		Insert obj;
		obj.Date_R__c = System.today()-1;
		Update obj;
	}

	@isTest static void test_method_two() {
		// Implement test code
	}

}