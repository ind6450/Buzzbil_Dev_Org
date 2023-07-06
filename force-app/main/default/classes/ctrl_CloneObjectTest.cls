@isTest
private class ctrl_CloneObjectTest {
	
	@isTest static void test_method_one() {
		//List<User> user_list = [SELECT Id, IsActive, Name FROM User WHERE IsActive = true LIMIT 1];
		
        test_AllObjectHandler handler1 = test_AllObjectHandler.getInstance();
		Account acc1 = handler1.getNewAccount(false);
		Id RecordTypeId = util_SObject.getRecordTypeId('Account', 'SL');
		acc1.RecordTypeId = recordTypeId;
		insert acc1;
		
		//Expenditure_Report__c old_er = handler1.getNewExpenditureReport(true, acc1.Id);
		//Expenditure_Report_Item__c er_item = handler2.getNewExpenditureReportItem(true, old_er.Id);
        
        Opportunity oldOppty = handler1.getNewOpportunity(true, acc1.Id);

		Test.startTest();
		
        PageReference page1 = new PageReference('/apex/ctrl_CloneRecord');
		Test.setCurrentPage(page1);
		ctrl_CloneObject ctrl1 = new ctrl_CloneObject();
		ctrl1.init();


		String my_url = '/apex/ctrl_CloneRecord?source_record_id=' + oldOppty.Id;
		my_url += '&clear_MainFields=y';

		PageReference page2 = new PageReference(my_url);
		Test.setCurrentPage(page2);
		ctrl1.init();
        
        String my_url2 = '/apex/ctrl_CloneRecord?source_record_id=' + oldOppty.Id;
		my_url2 += '&clear_MainFields=n';

		PageReference page3 = new PageReference(my_url2);
		Test.setCurrentPage(page3);
		ctrl1.init();

		Test.stopTest();
	}
}