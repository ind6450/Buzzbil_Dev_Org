/*
* ---------------------------------------------------------------------
*
* Subject : 레코드 복제
* Tester : ctrl_CloneObjectTest
*
* Description : 
* ---------------------------------------------------------------------
*/
public with sharing class ctrl_CloneObject {
    @AuraEnabled
    public String error_msg {get; private set;} // 에러 메시지
    public String success_msg {get; private set;} // 성공 메시지
    public Id source_record_id {get; private set;} // 원본 레코드 Id
    public Id copied_record_id {get; private set;} // 복제 된 레코드 Id

    // 생성자
    public ctrl_CloneObject() {
        //init(); // 초기화
    }

    // 초기화#1
    public void init() {
        String tmp_str = getParamValue('source_record_id'); // 오리지널 Id

        // 비어 있는 문자열이 아니라면
        if(String.isNotBlank(tmp_str)) {
            source_record_id = (Id) tmp_str;
            cloneNow(source_record_id);

        } else {
            error_msg = '비정상적인 접근입니다.';
        }//else

    }//function()


    // 레코드를 복제 후 해당 레코드로 이동한다.
    public void cloneNow(Id source_record_id) {
        sObject new_sobj = handler_CloneObject.getInstance().getCloneRecord(source_record_id, true); // 기존 레코드를 복제하여 새로운 레코드를 만든다.
        String clear_MainFields = getParamValue('clear_MainFields'); // checkbox, Currency, Date field 값을 클리어 할 것인가?
        Date prevCloseDate = System.today();
        String tmp_success_msg = '복제된 레코드로 이동합니다.';
        
        if(clear_MainFields == 'y') {
            tmp_success_msg += '\\n(주요 필드값을 모두 삭제했으니 누락된 값을 꼭 업데이트 하시기 바랍니다..)';
            handler_CloneObject.getInstance().clearChkboxValue(new_sobj); // Clear Checkbox fields
            handler_CloneObject.getInstance().clearCurrencyValue(new_sobj); // Clear Currency fields
            prevCloseDate = (Date)new_sobj.get('CloseDate');
            handler_CloneObject.getInstance().clearDateValue(new_sobj); // Clear Date fields
        }

        tmp_success_msg += '\\n기회 복제 시 예상매출일은 다음달 말일로 복제 됩니다.';
        
        String recordTypeId = util_SObject.getRecordTypeId('Opportunity', 'BD');
        if(util_SObject.getNameByRecordId(source_record_id)=='Opportunity' && recordTypeId!=new_sobj.get('RecordTypeId')) {
            new_sobj.put('Name', new_sobj.get('Name')+'(Cloned)');
            new_sobj.put('StageName', '제안'); // DISCUSSION(Hoon):2022.04.19 - [단계변경] 제안서전달 -> 제안으로 명칭 변경
            new_sobj.put('Probability',30);
            new_sobj.put('Campaign_Done__c', 'N');
            new_sobj.put('Incentive_YN__c', '');
            new_sobj.put('Invoice_request__c','');
            new_sobj.put('Submission_Comments__c', '');
            new_sobj.put('FN_Share_note__c','');
            new_sobj.put('Approval_Status__c','');
            new_sobj.put('DocuSign_Status__c','');
            new_sobj.put('Carryover_Amount__c', null);
            new_sobj.put('Carryover_Campaign__c', null);
            new_sobj.put('Carryover_Campaign_2__c', null);
            new_sobj.put('Carried_Over_Oppty__c', null);
            new_sobj.put('Carried_Over_Oppty_2__c', null);
            new_sobj.put('Carry_Over__c', null);
            new_sobj.put('ParentOpportunity__c', null);
            // new_sobj.put('Campaign_NewOrExisting__c', '');  // 집행여부 필드 초기화 대상에서 제외 
            new_sobj.put('Agency_Rep_FeeRate__c', null);
            //new_sobj.put('CloseDate', prevCloseDate+30);   // 이전 CloseDate+30로 설정
            new_sobj.put('CloseDate', prevCloseDate.addMonths(2).toStartOfMonth().addDays(-1));   // 이전 CloseDate 의 다음달 말일
            new_sobj.put('Reason_for_RevisedAmount__c', ''); // 매출액 변경사유 picklist

            // 캠페인 세팅 정보
            new_sobj.put('Unit_Price__c', null);
            new_sobj.put('Daily_Cap__c', '');
            new_sobj.put('Targeting__c', '');
            new_sobj.put('LandingURL__c', null);
            new_sobj.put('memo__c', null);

            new_sobj.put('IsCloned__c', true);
        }
        
        insert new_sobj;

        copied_record_id = (Id) new_sobj.get('id');
        success_msg = tmp_success_msg;

    }//function()
    
    private static String getParamValue(String param_name) {
        try {
            return ApexPages.currentPage().getParameters().get(param_name);        
        }
        catch( exception e){
            return null;
        }
    }
}