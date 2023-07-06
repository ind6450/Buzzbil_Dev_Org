@isTest
private class handler_CloneObjectTest {

	@isTest static void test_method_one() {
			List<User> user_list = [SELECT Id, IsActive, Name FROM User WHERE IsActive = true LIMIT 1];
			test_AllObjectHandler handler2 = test_AllObjectHandler.getInstance();
			Account acc1 = handler2.getNewAccount(false);
			Id recordTypeId = util_SObject.getRecordTypeId('Account', 'SL');
			acc1.RecordTypeId = recordTypeId;
			insert acc1;

			Id opptyRecordTypeId = util_SObject.getRecordTypeId('Opportunity', 'Sales_Agency');
			Opportunity oldOppty = handler2.getNewOpportunity(true, acc1.Id );

			handler_CloneObject handler1 = handler_CloneObject.getInstance();

			handler1.clearChkboxValue(oldOppty);
			handler1.clearCurrencyValue(oldOppty);
			handler1.clearDateValue(oldOppty);
			handler1.getCloneRecord(oldOppty, true);

			handler1.clearChkboxValue(user_list[0]);
			handler1.getCloneRecord(user_list[0].Id, true);
			handler1.getCloneRecord(user_list[0], true);
			handler1.clearChkboxValueList(user_list);
			handler1.clearCurrencyValueList(user_list);
			handler1.clearDateValueList(user_list);

	}

}