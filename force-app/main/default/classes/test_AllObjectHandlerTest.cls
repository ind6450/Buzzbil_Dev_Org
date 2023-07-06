@isTest
private class test_AllObjectHandlerTest {

    @isTest static void testGetNewAccount() {

  		Id sales_account_id = util_SObject.getRecordTypeId('Account', 'SL');
  		test_AllObjectHandler handler1 = test_AllObjectHandler.getInstance();

  		// insert acocunt
  		Account new_acc1 =	handler1.getNewAccount(true);
  		Account new_acc2 = handler1.getNewAccount(true,'SL');

  		Account new_acc3 = handler1.getNewAccount(false);
  		new_acc3.Name = 'sdfsdf2';
  		new_acc3.Type = 'Agency';

  		Account new_acc4 = handler1.getNewAccount(false,'SL');
  		new_acc3.Type = 'Advertiser';

    }

    @isTest static void testGetNewCase() {
      test_AllObjectHandler handler3 = test_AllObjectHandler.getInstance();
      Account new_acc1 =	handler3.getNewAccount(true);
      Opportunity opp1 = handler3.getNewOpportunity(true, new_acc1.Id);

      Case issue1 = handler3.getNewCase(true, opp1.Id);
      issue1.Status = 'Completed';

      handler3.getNewCase(false, opp1.Id);
    }
}