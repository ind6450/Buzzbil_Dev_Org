@isTest
private class util_SObjectTest {

	@isTest static void test_method_one() {
		Account acc1 = test_AllObjectHandler.getInstance().getNewAccount(true);
		util_SObject.getSObjectTypeById(acc1.Id);
		util_SObject.getNameByRecordId(acc1.Id);
		util_SObject.getNameBySObject(acc1);
		util_SObject.getAllFieldName('Account');
		util_SObject.getObjectFieldsMap('Account');
		util_SObject.getFieldDescribe('Account', 'Name');
		util_SObject.getUpdateableFieldsName2Map('Account', true);
		util_SObject.getCustomFieldsName2Map('Account', true);
		util_SObject.getSObjectByName('Account');
		Id salesRecordTypeId = util_SObject.getRecordTypeId('Account', 'SL');
		String salesAccnt = util_SObject.getRecordTypeName('Account', salesRecordTypeId);

		util_SObject.getRecordTypeId('Contact', null);
		String queryTest = util_SObject.getAllFieldName4Query('Case', false, true);

		Opportunity oppty1 = test_AllObjectHandler.getInstance().getNewOpportunity(true, acc1.Id);
		util_SObject.getChkBoxFieldName(oppty1);
		util_SObject.getCurrencyFieldName(oppty1);
		util_SObject.getDateFieldName(oppty1);
		util_SObject.getAllFieldName('Opportunity');
		List<String> stageNames = util_SObject.getPickListValues('Opportunity', 'StageName');

		// test for getRecordTypeIdList(String obj_name)
		List<RecordType> recTypeList = util_SObject.getRecordTypeIdList('Opportunity');
		util_SObject.getUpdateableFieldsName2Map('Opportunity', false);
		util_SObject.getCustomFieldsName2Map('Opportunity', true);
		util_SObject.getFieldDescribe('Opportunity', 'Amount');

		util_SObject.getUserId2ProfileIdMap(new Set<Id>{Userinfo.getUserId()});

		Test.startTest();
		util_SObject test1 = new util_SObject(); // 인스턴스 생성해서 테스트
		Test.stopTest();

	}

}