public class tri_CaseHandler extends TriggerHandler {
	private List<Case>	listNew;
	private List<Case>	listOld;
	private Map<Id, Case> mapNew;
	private Map<Id, Case> mapOld;

	public tri_CaseHandler() {
		this.listNew = (List<Case>)Trigger.new;
		this.listOld = (List<Case>)Trigger.old;
		this.mapNew = (Map<Id, Case>)Trigger.newMap;
		this.mapOld = (Map<Id, Case>)Trigger.oldMap;
	}

	// Case(이슈현황) 보상예산 필드 자동업데이트 조건 : Case > Trigger after insert, after update
	public override void beforeInsert() {
		doUpdateCompensationBudget(false);
	}

	public override void afterInsert() {
		//doUpdateOpportunityAmount(listNew, false);
	}

	public override void beforeUpdate() {
		doUpdateCompensationBudget(true);
	}

	public override void afterUpdate() {
		doUpdateOpportunityAmount(listNew, mapOld);
	}

	/************************************************************************************
	*	Case(이슈현황) 보상예산(Compensation_budget__c) 필드 자동업데이트 조건
	* if( 보상금액<>0 || 서비스금액<>0 ) 보상예산 = 보상금액+서비스금액
	*************************************************************************************/
	private void doUpdateCompensationBudget(Boolean isUpdate) {

		for(Case objCase:listNew){

			if(isUpdate && this.mapOld.get(objCase.Id).Compensation_budget__c!=null && (objCase.Compensation_Amount__c==null || objCase.Compensation_Amount__c==0) && (objCase.Additional_Amount__c==null || objCase.Additional_Amount__c==0) ) {
				//objCase.Compensation_budget__c = this.mapOld.get(objCase.Id).Compensation_budget__c;
				objCase.Compensation_budget__c = 0;

			} else if(objCase.Compensation_Amount__c!=null && objCase.Compensation_Amount__c!=0 && objCase.Additional_Amount__c==null ) {
				objCase.Compensation_budget__c = objCase.Compensation_Amount__c;

			} else if(objCase.Compensation_Amount__c==null && objCase.Additional_Amount__c!=null && objCase.Additional_Amount__c!=0 ) {
				objCase.Compensation_budget__c = objCase.Additional_Amount__c;

			} else if(objCase.Compensation_Amount__c!=null && objCase.Additional_Amount__c!=null) {
				objCase.Compensation_budget__c = objCase.Compensation_Amount__c + objCase.Additional_Amount__c;
			}

		}

	}

	/************************************************************************************
	*	Case와 연결된 Opportunity의 보상금액, 서비스금액 update, 프로모션 금액 추가 by Discussion 2021/07/13
	* Oppty에 연결된 모든 Case의 각 금액 Sum으로 update
	*************************************************************************************/
	/*private void doUpdateOpportunityAmount(List<Case> listCase, Boolean isUpdate) {
		Set<Id> setIdOppty = new Set<Id>();
		Set<Id> setIdOldOppty = new Set<Id>();

		for(Case obj:listCase) {
			if(obj.OpptyName__c != null &&
					(!isUpdate || obj.OpptyName__c != this.mapOld.get(obj.Id).OpptyName__c || obj.Compensation_Amount__c != this.mapOld.get(obj.Id).Compensation_Amount__c ||
					obj.Additional_Amount__c != this.mapOld.get(obj.Id).Additional_Amount__c || obj.Promotion__c != this.mapOld.get(obj.Id).Promotion__c) )
			{
				setIdOppty.add(obj.OpptyName__c);
			}

			if(isUpdate && obj.OpptyName__c != null && obj.OpptyName__c != this.mapOld.get(obj.Id).OpptyName__c) {
				setIdOldOppty.add(this.mapOld.get(obj.Id).OpptyName__c);
			}
		}

		if(!setIdOppty.isEmpty()) {
			AggregateResult[] groupedResults = [SELECT OpptyName__c, SUM(Compensation_Amount__c) sumCompensaion, SUM(Additional_Amount__c) sumAdditional, SUM(Promotion__c) promotion
													FROM Case WHERE OpptyName__c in: setIdOppty GROUP BY OpptyName__c];
			List<Opportunity> listOpportunity = new List<Opportunity>();
			for (AggregateResult ar : groupedResults){
				Opportunity objOppty = new Opportunity();
				objOppty.Id = String.valueOf(ar.get('OpptyName__c'));
				objOppty.Compensation__c = (Decimal) ar.get('sumCompensaion');  // 보상금액
				objOppty.service_paid_amount__c = (Decimal) ar.get('sumAdditional'); // 서비스금액
				objOppty.Promotion__c = (Decimal) ar.get('promotion'); // 프로모션 금액
				listOpportunity.add(objOppty);
			}
			if(listOpportunity.size() > 0) Update listOpportunity;
		}

		// Case에 연결된 Oppty가 변경된 경우, 변경전 Oppty의 보상금액, 서비스금액을 재계산 후 업데이트
		if(!setIdOldOppty.isEmpty()) {

			AggregateResult[] groupedResults = [SELECT OpptyName__c, SUM(Compensation_Amount__c) sumCompensaion, SUM(Additional_Amount__c) sumAdditional, SUM(Promotion__c) promotion
													FROM Case WHERE OpptyName__c in: setIdOldOppty GROUP BY OpptyName__c];
			List<Opportunity> listOldOppty = new List<Opportunity>();

			for (AggregateResult ar : groupedResults){
				Opportunity objOppty = new Opportunity();
				objOppty.Id = String.valueOf(ar.get('OpptyName__c'));
				objOppty.Compensation__c = (Decimal) ar.get('sumCompensaion');  // 보상금액
				objOppty.service_paid_amount__c = (Decimal) ar.get('sumAdditional'); // 서비스금액
				objOppty.Promotion__c = (Decimal) ar.get('promotion'); // 프로모션 금액
				listOldOppty.add(objOppty);
			}

			// OldOppty의 Case가 0건인 경우.
			if(groupedResults.size() == 0) {
				List<Opportunity> opptyList = [SELECT Id, Compensation__c, service_paid_amount__c FROM Opportunity WHERE Id in: setIdOldOppty];
				for(Opportunity oldOppty:opptyList) {
					oldOppty.Compensation__c = 0;
					oldOppty.service_paid_amount__c = 0;
					listOldOppty.add(oldOppty);
				}
			}
			if(listOldOppty.size() > 0) Update listOldOppty;
		}
   }*/

	/************************************************************************************
	* Case와 연결된 Opportunity의 보상금액, 서비스금액 update, 프로모션 금액 추가 by Discussion 2022/01/24
	* 승인 완료된 Case 만 기회에 적용됨
	* 승인 완료된 Case 는 관리자 이외에는 수정이 불가능 하다.
	*************************************************************************************/

	private void doUpdateOpportunityAmount(List<Case> listCase,  Map<Id, Case> oldCase) {
		Set<Id> setIdOldOppty = new Set<Id>();
		Set<String> user = new Set<String>{'yim', 'SF Admin', 'Cobb'};
		// 사용자 확인
		User u = [select Alias from User where Username = :UserInfo.getUserName()][0];
		String userAlias = u.Alias;

		for(Case newC : listCase){
			Case oldC = oldCase.get(newC.Id);

			Boolean oldApproval = Boolean.valueOf(oldC.get('isApproval__c'));
			Boolean newApproval = Boolean.valueOf(newC.get('isApproval__c'));
			System.debug('oldApproval : ' + oldApproval + ' // newApproval :: ' + newApproval);

			// 승인요청일 경우
			if(oldApproval != newApproval || !newApproval){
				setIdOldOppty.add(this.mapOld.get(newC.Id).OpptyName__c);
			}else{	// 아닐경우 필드 수정 불가
				IF(!user.contains(userAlias)){
					newC.addError('승인 완료된 이슈현황은 수정이 불가능합니다. 관리자에게 문의해 주세요.');
					break;
				}
			}
		}

		// Case에 연결된 Oppty가 변경된 경우, 변경전 Oppty의 보상금액, 서비스금액을 재계산 후 업데이트
		if(!setIdOldOppty.isEmpty()) {
			System.debug('### setIdOldOppty' + setIdOldOppty);
			AggregateResult[] groupedResults = [SELECT isApproval__c, OpptyName__c, SUM(Compensation_Amount__c) sumCompensaion, SUM(Additional_Amount__c) sumAdditional, SUM(Promotion__c) promotion
			FROM Case WHERE OpptyName__c in: setIdOldOppty GROUP BY OpptyName__c, isApproval__c];
			List<Opportunity> listOldOppty = new List<Opportunity>();

//			System.debug('##groupedResults : ' + groupedResults);
//			System.debug('##isApproval__c : ' + groupedResults[0].get('isApproval__c'));

			for (AggregateResult ar : groupedResults){
				// 승인이된 Case만 Update
				if(Boolean.valueOf(ar.get('isApproval__c'))){
					Opportunity objOppty = new Opportunity();
					objOppty.Id = String.valueOf(ar.get('OpptyName__c'));
					objOppty.Compensation__c = (Decimal) ar.get('sumCompensaion');  // 보상금액
					objOppty.service_paid_amount__c = (Decimal) ar.get('sumAdditional'); // 서비스금액
					objOppty.Promotion__c = (Decimal) ar.get('promotion'); // 프로모션 금액
					listOldOppty.add(objOppty);
				}
			}

			System.debug('##listOldOppty : ' + listOldOppty);

			// OldOppty의 Case가 0건인 경우.
			if(groupedResults.size() == 0) {
				List<Opportunity> opptyList = [SELECT Id, Compensation__c, service_paid_amount__c FROM Opportunity WHERE Id in: setIdOldOppty];
				for(Opportunity oldOppty:opptyList) {
					oldOppty.Compensation__c = 0;
					oldOppty.service_paid_amount__c = 0;
					listOldOppty.add(oldOppty);
				}
			}
			if(listOldOppty.size() > 0) Update listOldOppty;
		}
	}
}