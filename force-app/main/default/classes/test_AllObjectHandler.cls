/*
* ---------------------------------------------------------------------
*
* Subject : 테스트 클래스를 위한 모든 개체 핸들링
* Description :
*
* ---------------------------------------------------------------------
*/
public class test_AllObjectHandler {

    // 생성자
    private test_AllObjectHandler() {

    }//function()

    // 새로운 Opportunity 레코드를 생성하여 리턴한다.
    public Opportunity getNewOpportunity(Boolean isInsert, Id accountId) {
        Opportunity opp1 = new Opportunity();

        if(accountId != null) {
            opp1.RecordTypeId = util_SObject.getRecordTypeId('Opportunity', 'ADN');
    
            opp1.Name = 'Test_Oppty_'+System.today();
            opp1.AccountId = accountId;
            opp1.StageName = '제안'; // DISCUSSION(Hoon):2022.04.19 - [단계변경] 제안서전달 -> 제안 으로 명칭 변경
            //opp1.CloseDate = System.today() + 30;
            opp1.CloseDate = Date.newInstance(2020, 6, 1);
            opp1.Amount = 100000;
            opp1.Manual_Contract__c = true;
		}//if
        
        if(isInsert) {
            insert opp1;
        }

        return opp1;
    }

   	// 새로운 Account 레코드들 생성하여 리턴한다.
    public Account getNewAccount(Boolean isInsert) {
    	Account acc = new Account();
		acc.RecordTypeId = util_SObject.getRecordTypeId('Account', 'SL');
    	acc.Name = 'Test_Agency';
    	acc.Type = 'Agency';

    	if(isInsert == true) {
    		insert acc;
    	}

        return acc;
    }

    public Account getNewAccount(Boolean isInsert, String developer_name) {
    	Account acc = new Account();
      	acc.Name = 'TEST_';
    	acc.Type = 'Agency';
      	acc.RecordTypeId = util_SObject.getRecordTypeId('Account', developer_name);

      	if(isInsert == true) {
            insert acc;
      	}

      	return acc;
    }
    

    // 새로운 Case 레코드를 생성하여 리턴한다.
    public Case getNewCase(Boolean isInsert, Id opptyId) {
        Case issue1 = new Case();

        if(opptyId == null) {
            Account accnt = getNewAccount(true);
            Opportunity oppty = getNewOpportunity(true, accnt.Id);
            opptyId = oppty.Id;
        }
            issue1.Subject = 'test';
        	issue1.Status = 'Finished';
            issue1.OpptyName__c = opptyId;
            issue1.Priority = 'Medium';
            issue1.IssueDate__c = System.today();
            issue1.Compensation_Amount__c = 100000;
            issue1.Additional_Amount__c = 50000;

        if(isInsert) {
            insert issue1;
        }

        return issue1;
    }    

    private static test_AllObjectHandler sInstance = null; // 싱글턴 인스턴스

    // 싱글턴 인스턴스 반환
    public static test_AllObjectHandler getInstance() {
        if(sInstance == null) {
            sInstance = new test_AllObjectHandler();
        }

        return sInstance;
    }
}