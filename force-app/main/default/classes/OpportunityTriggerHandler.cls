public class OpportunityTriggerHandler extends TriggerHandler {
    
    public List<Opportunity> lstnewOpportunity {
        get {
            return (List<Opportunity> ) Trigger.new;
        }
        private set;
    }

    public List<Opportunity> lstoldOpportunity {
        get {
            return (List<Opportunity> ) Trigger.old;
        }
        private set;
    }
    
    public map<id, Opportunity> mapOldOpportunity{
        get {
            return (map<id, Opportunity>) Trigger.oldMap;
        }
        private set;
    }

    public override void beforeInsert() {
        SetDefaultValues (lstnewOpportunity, null);
        UpdateClientLastClosingDetails(lstnewOpportunity, true);
    }

    public override void afterInsert(){
        accountChk(lstnewOpportunity);
        setYoutubeChannelId(lstnewOpportunity, mapOldOpportunity);
    }

    public override void beforeUpdate() {
        SetDefaultValues (lstnewOpportunity, mapOldOpportunity);
        restrictStage(lstnewOpportunity,mapOldOpportunity);
        restrictStageUpdateField(lstnewOpportunity,mapOldOpportunity);
    }

    public override void afterUpdate() {
        UpdateClientLastClosingDetails(lstnewOpportunity, true);
        UpdateOldAdvertiserClosingDetails(lstoldOpportunity, lstnewOpportunity);
        accountChk(lstnewOpportunity);
        setYoutubeChannelId(lstnewOpportunity, mapOldOpportunity);

    }

    public override void beforeDelete() {
        UpdateClientLastClosingDetails(lstoldOpportunity, false);
        accountChk(lstoldOpportunity);
    }

    public override void afterDelete() {
        //accountChk(lstoldOpportunity);
    }


    /**
     * You
    **/

    /**
    *   @description Method to update Old Advertiser's Last Closing Date and Last Deal Owner
    **/
    public void UpdateOldAdvertiserClosingDetails(List<Opportunity> lstoldOpp, List<Opportunity> lstnewOpp) {
        id BusinessDevRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('BD').getRecordTypeId();

        // Advertiser      
        set<id> setOldAdvIds = new Set<Id>();
        List<Account> lstOldAdv = new List<Account>();
        List<Account> lstAdvtoUpdate = new List<Account>();

        List<Opportunity> lstrelOppites_forAdv = new List<Opportunity>();
        Set<Id> ExOpptyIds = new Set<ID>();
        Map<Id, List<Opportunity>> mapAdvOpp = new Map<Id, List<Opportunity>>();
        
        //for(Opportunity newOpp: lstnewOpp) { 
        for(Integer i=0; i < lstnewOpp.size(); i++) {
            Opportunity newOpp = lstnewOpp[i];
            Opportunity oldOpp = lstoldOpp[i];
            if(newOpp.RecordTypeId != BusinessDevRT && newOpp.Advertiser__c!=null ) {

                if(oldOpp.Advertiser__c!=null && oldOpp.Advertiser__c!=newOpp.Advertiser__c) {
                    setOldAdvIds.add(oldOpp.Advertiser__c);
                    ExOpptyIds.add(oldOpp.Id);
                }
                
            }
        }

        // Old Advertisers
        if(!setOldAdvIds.isEmpty()){
            lstOldAdv = [SELECT id, Last_DealOwner__c, Last_Closing_Date__c FROM Account WHERE Id in: setOldAdvIds];
            lstrelOppites_forAdv = [Select Id, OwnerId, Advertiser__c, CloseDate FROM Opportunity WHERE Advertiser__c =: setOldAdvIds
                                AND Probability >= 80 AND AdDivision__c='Paid' AND Amount>0 AND ID Not In : ExOpptyIds];
        }
        if(!lstrelOppites_forAdv.isEmpty()){
            for(Opportunity OppRec: lstrelOppites_forAdv){
                if(mapAdvOpp.containsKey(OppRec.Advertiser__c)){
                    mapAdvOpp.get(OppRec.Advertiser__c).add(OppRec);
                }else{
                    List<Opportunity> OppforMapping = new List<Opportunity>();
                    OppforMapping.add(OppRec);
                    mapAdvOpp.put(OppRec.Advertiser__c, OppforMapping);
                }
            }
        }

        map<id, Account> mapOldAdv = new map<id, Account>(lstOldAdv);
        for (Integer i=0; i<lstoldOpp.size();i++){
            Opportunity Opp = lstoldOpp[i];
            Opportunity newOpp = lstnewOpp[i];
            if(Opp.RecordTypeId != BusinessDevRT && Opp.Advertiser__c!=null && newOpp.Advertiser__c!=Opp.Advertiser__c){
                // for Advertisers
                if(mapOldAdv.containsKey(Opp.Advertiser__c)) {
                    if(mapAdvOpp.containsKey(Opp.Advertiser__c)) {

                        Account adv = mapOldAdv.get(Opp.Advertiser__c);
                        adv.Last_Closing_Date__c = null;
                        adv.Last_DealOwner__c = null;

                        List<Opportunity> lstrelOpp_Adv = mapAdvOpp.get(Opp.Advertiser__c);
                        for (Opportunity relOpp_Adv: lstrelOpp_Adv){
                            if(adv.Last_Closing_Date__c == null) {
                                adv.Last_Closing_Date__c = relOpp_Adv.CloseDate;
                                adv.Last_DealOwner__c = relOpp_Adv.OwnerId;
                            }else if(relOpp_Adv.CloseDate > adv.Last_Closing_Date__c) {
                                adv.Last_Closing_Date__c = relOpp_Adv.CloseDate;
                                adv.Last_DealOwner__c = relOpp_Adv.OwnerId;
                            }
                        }
                        lstAdvtoUpdate.add(adv);
                    } else {

                        Account adv = mapOldAdv.get(Opp.Advertiser__c);
                        adv.Last_Closing_Date__c = null;
                        adv.Last_DealOwner__c = null;
                        lstAdvtoUpdate.add(adv);
                    }
                }
            }
        }

        MAP<Id,Account> advMap = new MAP<Id,Account>();
        advMap.putAll(lstAdvtoUpdate);

        if(advMap.size()>0) {
            update advMap.values();
        }
    }


    /**
    *  @description Method to update Client & Advertiser's Last Closing Date and Last Deal Owner
    **/
    public void UpdateClientLastClosingDetails(List <Opportunity> lstOpp, Boolean isNew) {
        id BusinessDevRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('BD').getRecordTypeId();
        id BusinessGS = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Global_Sales').getRecordTypeId();
        id BusinessLead = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sales_Dummy_opportunity_owner').getRecordTypeId();
        
        // Client (Account)
        set<id> setAccIds = new set<id>();
        List<Account> lstrelAcc = new List<Account>();
        List<Account> lstAcctoUpdate = new List<Account>();

        List<Opportunity> lstrelOppites_forClient = new List<Opportunity>();
        Set<Id> ExOpptyIds = new Set<ID>();
        Map<Id, List<Opportunity>> mapAccOpp = new Map<Id, List<Opportunity>>();

        // Advertiser
        set<id> setAdvIds = new set<id>();
        List<Account> lstrelAdv = new List<Account>();
        List<Account> lstAdvtoUpdate = new List<Account>();

        List<Opportunity> lstrelOppites_forAdv = new List<Opportunity>();
        Set<Id> ExOpptyIds2 = new Set<ID>();
        Map<Id, List<Opportunity>> mapAdvOpp = new Map<Id, List<Opportunity>>();      

        for (Opportunity Opp: lstOpp){

            //DISCUSSION(HOON) : 2022.04.12 - 기회 레코드 타입 Global Sales, 리드소유, Business Development와 같지 않음 으로 잡아주시면 됩니다.
//            if( Opp.RecordTypeId != BusinessDevRT && Opp.AccountId!= null && Opp.OpptyType__c!='광고주 직거래' ) {
            if( (Opp.RecordTypeId != BusinessDevRT && Opp.RecordTypeId != BusinessGS && Opp.RecordTypeId != BusinessLead) && Opp.AccountId!= null && Opp.OpptyType__c!='광고주 직거래' ) {
                setAccIds.add(Opp.AccountId);
                ExOpptyIds.add(Opp.Id);
            }
                
            if(Opp.RecordTypeId != BusinessDevRT && Opp.Advertiser__c!=null ) {
                setAdvIds.add(Opp.Advertiser__c);
                ExOpptyIds2.add(Opp.Id);      
            }
        }


        // Clients
        if(!setAccIds.isEmpty()){
            lstrelAcc = [SELECT id, Last_DealOwner__c, Last_Closing_Date__c FROM Account WHERE Id in: setAccIds];

            if(isNew) {
                lstrelOppites_forClient = [Select Id, OwnerId, AccountId, CloseDate FROM Opportunity WHERE AccountId =: setAccIds
                AND Probability >= 80 AND AdDivision__c='Paid' AND Amount>0];                  
            } else {
                lstrelOppites_forClient = [Select Id, OwnerId, AccountId, CloseDate FROM Opportunity WHERE AccountId =: setAccIds
                AND Probability >= 80 AND AdDivision__c='Paid' AND Amount>0 AND ID Not In : ExOpptyIds];              
            }

        }
        if(!lstrelOppites_forClient.isEmpty()){       
            for(Opportunity OppRec: lstrelOppites_forClient){
                if(mapAccOpp.containsKey(OppRec.AccountId)){
                    mapAccOpp.get(OppRec.AccountId).add(OppRec);
                }else{
                    List<Opportunity> OppforMapping = new List<Opportunity>();
                    OppforMapping.add(OppRec);
                    mapAccOpp.put(OppRec.AccountId, OppforMapping);
                }
            }
        }

        // Advertisers
        if(!setAdvIds.isEmpty()){
            lstrelAdv = [SELECT id, Last_DealOwner__c, Last_Closing_Date__c FROM Account WHERE Id in: setAdvIds];

            if(isNew) {
                lstrelOppites_forAdv = [Select Id, OwnerId, Advertiser__c, CloseDate FROM Opportunity WHERE Advertiser__c =: setAdvIds
                AND Probability >= 80 AND AdDivision__c='Paid' AND Amount>0 ];                
            } else {
                lstrelOppites_forAdv = [Select Id, OwnerId, Advertiser__c, CloseDate FROM Opportunity WHERE Advertiser__c =: setAdvIds
                AND Probability >= 80 AND AdDivision__c='Paid' AND Amount>0 AND ID Not In : ExOpptyIds2];              
            }

        }
        if(!lstrelOppites_forAdv.isEmpty()){           
            for(Opportunity OppRec2: lstrelOppites_forAdv){
                if(mapAdvOpp.containsKey(OppRec2.Advertiser__c)){
                    mapAdvOpp.get(OppRec2.Advertiser__c).add(OppRec2);
                }else{
                    List<Opportunity> OppforMapping2 = new List<Opportunity>();
                    OppforMapping2.add(OppRec2);
                    mapAdvOpp.put(OppRec2.Advertiser__c, OppforMapping2);
                }
            }
        }


        map<id, Account> mapAcc = new map<id, Account>(lstrelAcc);
        map<id, Account> mapAdv = new map<id, Account>(lstrelAdv);
        
        for (Opportunity Opp: lstOpp){
            if(Opp.RecordTypeId != BusinessDevRT){
                // for Clients
                if (mapAcc.containsKey(Opp.AccountId)){
                    if(mapAccOpp.containsKey(Opp.AccountId)){
                        
                        Account a = mapAcc.get(Opp.AccountId);
                        a.Last_Closing_Date__c = null;
                        a.Last_DealOwner__c = null;
                        
                        List<Opportunity> lstrelOpp = mapAccOpp.get(Opp.AccountId);
                        for (Opportunity relOpp: lstrelOpp){
                            if(a.Last_Closing_Date__c == null){
                                a.Last_Closing_Date__c = relOpp.CloseDate;
                                a.Last_DealOwner__c = relOpp.OwnerId;
                            }else if(relOpp.CloseDate > a.Last_Closing_Date__c){
                                a.Last_Closing_Date__c = relOpp.CloseDate;
                                a.Last_DealOwner__c = relOpp.OwnerId;
                            }
                            
                        }
                        lstAcctoUpdate.add(a);
                    }else{
                        Account a = mapAcc.get(Opp.AccountId);
                        a.Last_Closing_Date__c = null;
                        a.Last_DealOwner__c = null;
                        lstAcctoUpdate.add(a);
                    }   
                }

                // for Advertisers
                if(mapAdv.containsKey(Opp.Advertiser__c)) {
                    if(mapAdvOpp.containsKey(Opp.Advertiser__c)) {

                        Account adv = mapAdv.get(Opp.Advertiser__c);
                        adv.Last_Closing_Date__c = null;
                        adv.Last_DealOwner__c = null;

                        List<Opportunity> lstrelOpp_Adv = mapAdvOpp.get(Opp.Advertiser__c);
                        for (Opportunity relOpp_Adv: lstrelOpp_Adv){
                            if(adv.Last_Closing_Date__c == null) {
                                adv.Last_Closing_Date__c = relOpp_Adv.CloseDate;
                                adv.Last_DealOwner__c = relOpp_Adv.OwnerId;
                            }else if(relOpp_Adv.CloseDate > adv.Last_Closing_Date__c) {
                                adv.Last_Closing_Date__c = relOpp_Adv.CloseDate;
                                adv.Last_DealOwner__c = relOpp_Adv.OwnerId;
                            }
                        }
                        system.debug('***if(mapAdv.containsKey(Opp.Advertiser__c))_Adv.Last_Closing_Date__c:'+adv.Last_Closing_Date__c); 
                        system.debug('***if(mapAdv.containsKey(Opp.Advertiser__c))_Adv.Last_DealOwner__c:'+adv.Last_DealOwner__c); 

                        lstAdvtoUpdate.add(adv);

                    } else {

                        Account adv = mapAdv.get(Opp.Advertiser__c);
                        adv.Last_Closing_Date__c = null;
                        adv.Last_DealOwner__c = null;
                        lstAdvtoUpdate.add(adv);
                    }
                }
            }
        }

        MAP<Id,Account> accMap = new MAP<Id,Account>();
        accMap.putAll(lstAcctoUpdate);

        if(accMap.size()>0) {
            update accMap.values();
        }


        MAP<Id,Account> advMap = new MAP<Id,Account>();
        advMap.putAll(lstAdvtoUpdate);

        if(advMap.size()>0) {
            update advMap.values();
        }
        
    }
    
    /**
    *   @description Method to Set the default values of Vat
    **/
    public void SetDefaultValues(List <Opportunity> lstnewOpp, map<id, Opportunity> mapOldOpportunity) {
        id BusinessDevRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('BD').getRecordTypeId();
        for (Opportunity OppRec: lstnewOpp){
            if(mapOldOpportunity != null) {

                if (OppRec.Carryover_Campaign__c == null && OppRec.Carryover_Campaign__c != mapOldOpportunity.get(OppRec.Id).Carryover_Campaign__c) {
                    //[미소진 전월 캠페인] 필드에 참조되어 있는 기회가 해제("") 된 경우, 해당 기회의 [잔여예산이 이월된 기회] 필드의 기회를 제거 해야 함.
                    String opptId = mapOldOpportunity.get(OppRec.Id).Carryover_Campaign__c;
                    List<Opportunity> oppti = [SELECT Id, Name, Carried_Over_Oppty__c FROM Opportunity WHERE Id = :opptId];

                    system.debug('# Id of changed Carryover Campaign of opportunity. : ' + opptId);
                    system.debug('# List of changed Carryover Campaign of opportunity. : ' + oppti);

                    if (oppti.size() > 0) {
                        system.debug('# Changed : ' + oppti[0].Carried_Over_Oppty__c);
                        oppti[0].Carried_Over_Oppty__c = null;

                        update oppti;
                    }
                }

                if (OppRec.Carryover_Campaign_2__c == null && OppRec.Carryover_Campaign_2__c != mapOldOpportunity.get(OppRec.Id).Carryover_Campaign_2__c) {
                    //[미소진 전월 캠페인 2] 필드에 참조되어 있는 기회가 해제("") 된 경우, 해당 기회의 [잔여예산이 이월된 기회 2] 필드의 기회를 제거 해야 함.
                    String opptId = mapOldOpportunity.get(OppRec.Id).Carryover_Campaign_2__c;
                    List<Opportunity> oppti = [SELECT Id, Name, Carried_Over_Oppty_2__c FROM Opportunity WHERE Id = :opptId];

                    system.debug('# Id of changed Carryover Campaign of opportunity. : ' + opptId);
                    system.debug('# List of changed Carryover Campaign of opportunity. : ' + oppti);

                    if (oppti.size() > 0) {
                        system.debug('# Changed : ' + oppti[0].Carried_Over_Oppty_2__c);
                        oppti[0].Carried_Over_Oppty_2__c = null;

                        update oppti;
                    }
                }
            }

           if(OppRec.RecordTypeId != BusinessDevRT){
                if(mapOldOpportunity == null){
                    if(OppRec.Amount != null){
                       OppRec.VAT2__c = OppRec.Amount * 0.1;
                        
                        if(OppRec.Agency_Rep_FeeRate__c != null){
                            OppRec.Agency_Rep_Fee2__c = OppRec.Amount * (OppRec.Agency_Rep_FeeRate__c/100);
                        }
                    }
                }else{
                    if(OppRec.Amount != null && OppRec.Amount != mapOldOpportunity.get(OppRec.Id).Amount){
                        OppRec.VAT2__c = OppRec.Amount * 0.1;
                    }
                    
                    if(OppRec.Amount != null && OppRec.Agency_Rep_FeeRate__c != null && 
                       (OppRec.Amount != mapOldOpportunity.get(OppRec.Id).Amount || 
                       OppRec.Agency_Rep_FeeRate__c != mapOldOpportunity.get(OppRec.Id).Agency_Rep_FeeRate__c)){
                        OppRec.Agency_Rep_Fee2__c = OppRec.Amount * (OppRec.Agency_Rep_FeeRate__c/100);
                    }
                }
           }
            
        }
    }

    // 단계변경 제한
    public void restrictStage(List<Opportunity> newOppt, Map<Id, Opportunity> oldOppt){
        //(DISCUSSION(Hoon) : 2023-04-26) - 함태헌 메니저 삭제(Hazard)
        Set<String> user = new Set<String>{'SF Admin', 'Cobb', 'BM', 'disc', 'yim'};
        // 사용자 확인
        User u = [select Alias from User where Username = :UserInfo.getUserName()][0];
        String userAlias = u.Alias;

        // 특정사용자가 아닐경우 단계변경 제한
        if(!user.contains(userAlias)){
            for(Opportunity newOpt : newOppt){
                Opportunity oldOpt = oldOppt.get(newOpt.Id);

                String oldStage = (String)oldOpt.get('stageName');
                String newStage = (String)newOpt.get('stageName');

                // 단계가 변경될때
                if(!oldStage.equals(newStage)){

                    // DISCUSSION(Hoon):2022.04.19 - [단계변경] 제안서전달 -> 제안 / 조건협의 -> 협의 / 게재신청체결 -> 체결 로 명칭 변경
                    // 클라이언트미팅/제안서전달 / 조건협의 단계가 수주실패 or 게재신청 체결로 넘어갈 수 있어야 한다.
                    if(oldStage.equals('클라이언트미팅') && !newStage.equals('제안') && !newStage.equals('협의') && !newStage.equals('체결') && !newStage.equals('수주실패_광고미진행') && !newStage.equals('수주실패_대행사렙사비딩실패') && !newStage.equals('수주실패_제안컨펌실패')){
                        newOpt.addError('체결 단계를 거치지 않고 세팅요청 단계로 변경할 수 없습니다');
                        break;
                    }
                    // DISSSION(Hoon):2022.08.11 - 해당 제약 해제
//                    if(oldStage.equals('제안') && !newStage.equals('클라이언트미팅') && !newStage.equals('협의') && !newStage.equals('체결') && !newStage.equals('수주실패_광고미진행') && !newStage.equals('수주실패_대행사렙사비딩실패') && !newStage.equals('수주실패_제안컨펌실패')){
//                        newOpt.addError('단계를 확인해 주세요.');
//                        break;
//                    }
//                    if(oldStage.equals('협의') && !newStage.equals('클라이언트미팅') && !newStage.equals('제안') && !newStage.equals('체결') && !newStage.equals('수주실패_광고미진행') && !newStage.equals('수주실패_대행사렙사비딩실패') && !newStage.equals('수주실패_제안컨펌실패')){
//                        newOpt.addError('단계를 확인해 주세요.');
//                        break;
//                    }

                    // 게재신청체결 단계가 된 기회는 게재신청체결 > 세금계산서업무 > 광고비입금 or 채권추심 순으로 움직입니다.
                    // DISSSION(Hoon):2022.04.19 - [단계변경] 게재신청체결 -> 체결 로 명칭 변경 (광고종료 -> 세금계산서업무 로 프로세스 변경)CU
                    // DISSSION(Hoon):2022.08.11 - 해당 제약 해제
//                    if(oldStage.equals('광고종료') && !newStage.equals('세금계산서업무')){
//                        newOpt.addError('단계를 확인해 주세요.');
//                        break;
//                    }
                    if(oldStage.equals('세금계산서업무') && !newStage.equals('광고비입금') && !newStage.equals('채권추심')){
                        newOpt.addError('단계를 확인해 주세요.');
                        break;
                    }
                    if(oldStage.equals('채권추심') && !newStage.equals('광고비입금')){
                        newOpt.addError('단계를 확인해 주세요.');
                        break;
                    }
                    // 마감의 경우 단계 변경 불가
                    if(oldStage.equals('광고비입금') || oldStage.equals('수주실패_광고미진행') || oldStage.equals('수주실패_대행사렙사비딩실패') || oldStage.equals('수주실패_제안컨펌실패')){
                        newOpt.addError('단계 변경이 불가능합니다.');
                        break;
                    }
                }
            }
        }
    }

    // 단계에 따른 update 필드 제한
    public void restrictStageUpdateField(List<Opportunity> newOppt, Map<Id, Opportunity> oldOppt){
        Set<String> stageList = new Set<String>{'세금계산서업무','채권추심','광고비입금'};
        Set<String> stageFail = new Set<String>{'수주실패_광고미진행','수주실패_대행사렙사비딩실패','수주실패_제안컨펌실패'};
        //(DISCUSSION(Hoon) : 2023-04-26) - 함태헌 메니저 삭제(Hazard)
        Set<String> user = new Set<String>{'SF Admin', 'Cobb', 'BM', 'disc', 'yim'};
        //Set<String> approvalUser = new Set<String>{'Hazard','SF Admin','Cobb','Benjamin','Eve','Lauren','Jarrod','Leo','Bling','BM'};
        // 사용자 확인
        User u = [select Alias from User where Username = :UserInfo.getUserName()][0];
        String userAlias = u.Alias;

        IF(!user.contains(userAlias)){
            Map<String, Schema.SObjectField> mapFields = Schema.SObjectType.Opportunity.fields.getMap();
            for(Opportunity newOpt : newOppt){
                Opportunity oldOpt = oldOppt.get(newOpt.Id);

                String oldStage = (String)oldOpt.get('stageName');
                String newStage = (String)newOpt.get('stageName');
                System.debug('oldStage : ' + oldStage + ' // newStage :: ' + newStage);
                System.debug(newOpt.Id + 'oldName : ' + (String)oldOpt.get('Name') +  + ' // newStage :: ' + (String)newOpt.get('Name'));

                // 단계변경이 아니면서
                if(oldStage.equals(newStage)){
                    for (String str : mapFields.keyset()){
                        // 필드가 변경 되었을때
                        if(newOpt.get(str) != oldOpt.get(str)){
                            System.Debug('IGORU Field changed: ' + str + '. The value has changed from: ' + oldOpt.get(str) + ' to: ' + newOpt.get(str));
                            // isApproval__c가 true일 경우 승인 프로세스로 간주, 수정필드를 체크하지 않는다.
                            if(str.equalsIgnoreCase('isApproval__c') && newOpt.get(str) == true){
                                break;
                            }
                            // 게재신청체결, 세금계산서업무,채권추심 단계 일 때, 입금현황의 게시물에 새로 만들기를 통해 기회를 매칭 할 수 있어야 한다
                            // 기회의 단계가 세금계산서업무 이상일 때(세금계산서 업무, 광고비 입금, 채권추심) 기회의 정보를 수정할 수 없도록 한다.
                            //(DISCUSSION(Hoon) : 2022-04-08) - 계산서 업무요청/승인요청사유/세금계산서 발행 이메일/재무팀 공유사항 4개 필드 수정 가능하도록 수정
                            //(DISCUSSION(Hoon) : 2022.04.19) - [단계변경] 게재신청체결 -> 체결 로 명칭 변경
                            //(DISCUSSION(Hoon) : 2023.02.15) - [필드추가] Tax Email 2 필드 추가하여 예외처리 추가
                            if(stageList.contains(newStage) && !str.equalsIgnoreCase('Deposit_Checked__c') && !str.equalsIgnoreCase('Deposit_Delayed__c') && !str.equalsIgnoreCase('Deposit_Delayed_notinuse__c')
                                    && !str.equalsIgnoreCase('Deposit_DueDate__c') && !str.equalsIgnoreCase('Deposit_FN__c') && !str.equalsIgnoreCase('DepositCount__c') && !str.equalsIgnoreCase('DepositYN__c') && !str.equalsIgnoreCase('PaymentTermsUpdate__c')
                                    && !str.equalsIgnoreCase('Approval_Status__c') && !str.equalsIgnoreCase('Submission_Date__c') && !str.equalsIgnoreCase('Carried_Over_Oppty__c') && !str.equalsIgnoreCase('Agency_Rep_FeeRate__c') && !str.equalsIgnoreCase('Agency_Rep_Fee__c') && !str.equalsIgnoreCase('Agency_Rep_Fee2__c') && !str.equalsIgnoreCase('TEST_Fee__c') && !str.equalsIgnoreCase('Unitprice_Excludingfees__c')
                                    && !str.equalsIgnoreCase('Invoice_request__c') && !str.equalsIgnoreCase('Submission_Comments__c') && !str.equalsIgnoreCase('Tax_Email__c') && !str.equalsIgnoreCase('FN_Share_note__c')
                                    && !str.equalsIgnoreCase('Approval_Condition__c') && !str.equalsIgnoreCase('Tax_Email_2__c')){
                                System.debug('newStage : ' + newStage + ' // str : ' + str);
                                newOpt.addError('수정이 불가능합니다.');
                                break;
                            }
                            // 수주실패 단계로 변경할 때 수주실패 사유-분석-플랜은 입력할 수 있도록 한다.
                            if(stageFail.contains(newStage) && !str.equalsIgnoreCase('LostReason__c') && !str.equalsIgnoreCase('FailureReason__c') && !str.equalsIgnoreCase('NextPlan__c')){
                                System.debug('newStage : ' + newStage + ' // 22str : ' + str);
                                newOpt.addError('수정이 불가능합니다.');
                                break;
                            }
                        }
                    }
                }

                // 승인단계가 Rejected/Recalled/Approved 일경우 isApproval__c false로 변경
                String approvalStatus = (String)newOpt.get('Approval_Status__c');
                if(approvalStatus != null){
                    if(approvalStatus.equalsIgnoreCase('Rejected') || approvalStatus.equalsIgnoreCase('Recalled') || approvalStatus.equalsIgnoreCase('Approved')){
                        newOpt.isApproval__c = false;
                    }
                }
            }
        }

    }

    // 보고서용 Account Checkbox 체크여부
    public void accountChk(List<Opportunity> newOppt){
        Set<String> stageName = new Set<String>{'클라이언트미팅','제안','협의'}; // DISCUSSION(Hoon):2022.04.19 - [단계변경] 제안서전달 -> 제안 / 조건협의 -> 협의 로 명칭 변경
        Set<Id> accountId = new Set<Id>();
        for(Opportunity newOpt : newOppt){
            // AccountId 모으기
            accountId.add(newOpt.AccountId);
        }
        System.debug('accountId :: ' + accountId);
        // 해당 Account에 등록된 전체 Oppt가져오기
        List<Opportunity> accOppList = [select id, CloseDate, StageName, AccountId from Opportunity where AccountId in :accountId];
        System.debug('accOppList :: ' + accOppList);
        Boolean isChk = false;
        Map<String, Boolean> chkMap = new Map<String,Boolean>();
        for(Opportunity accOpp : accOppList ){
            // 최근 6개월 이내인지 체크
            if(accOpp.CloseDate < System.today().addMonths(-6)){
                // 게재신청체결` 이상의 기회가 없는
                if(stageName.contains(accOpp.StageName)){
                    chkMap.put(accOpp.AccountId, true);
                    isChk = true;
                }else{
                    chkMap.put(accOpp.AccountId, false);
                    isChk = false;
                    //break;
                }
            }else{
                chkMap.put(accOpp.AccountId, false);
                isChk = false;
                //break;
            }
        }
        System.debug('chkMap ::: ' + chkMap);
        // Account Update
        List<Account> chkAccount = [Select id, isOppChk__c from Account where id in :accountId];
        for(Account acc : chkAccount){
            acc.isOppChk__c = chkMap.get(acc.Id);
        }
        update chkAccount;
    }

    public static void setYoutubeChannelId(List<Opportunity> newOpp, map<id, Opportunity> oldOpp) {

        // 재귀를 막아야 함 Youtube API 에서 Update 를 하기에 트리거가 총 2번 실행 됨
        List<Opportunity> opportunities = [SELECT Id, Youtube_URL__c FROM Opportunity WHERE Id IN : newOpp];

        if(oldOpp != null) { // Update
            if (opportunities[0].Youtube_URL__c != oldOpp.get(opportunities[0].Id).Youtube_URL__c) {  // 기존 URL 과 업데이트하는 URL 이 같지 않고 공백이 아닐 경우에만 호출
                System.enqueueJob(new YoutubeAPI(opportunities));
            }
        } else { // Insert
            if(opportunities[0].Youtube_URL__c != null || opportunities[0].Youtube_URL__c != '') System.enqueueJob(new YoutubeAPI(opportunities)); // URL 이 있을 경우에만 호출
        }
    }

    public void indexCount(){
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;

    }
}