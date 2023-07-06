public class tri_BD_PerformanceHandler extends TriggerHandler
{
  private List<BD_Performance__c> listNew;
  private List<BD_Performance__c> listOld;
	private Map<Id, BD_Performance__c> mapNew;
	private Map<Id, BD_Performance__c> mapOld;
	public tri_BD_PerformanceHandler() {
		this.listNew = (List<BD_Performance__c>)Trigger.new;
    this.listOld = (List<BD_Performance__c>)Trigger.old;
		this.mapNew = (Map<Id, BD_Performance__c>)Trigger.newMap;
		this.mapOld = (Map<Id, BD_Performance__c>)Trigger.oldMap;
	}
/*
  public override void beforeInsert() {
    doSetDefault();
  }
*/
  public override void beforeUpdate() {
    doSetDefault();
  }

  public override void afterUpdate() {
    doDeleteOldRecord();
  }
/*
  public override void afterInsert() {
    doDeleteOldRecord();
  }
*/
  /************************************************************************************
	*	기본 update
	*************************************************************************************/
	private void doSetDefault(){

    for(BD_Performance__c objPerformance:listNew) {

      // Period update
      if(objPerformance.Quarter__c!=null && objPerformance.Month__c==null) {
        objPerformance.Period__c = 'Quarterly';
      } else if(objPerformance.Quarter__c==null && objPerformance.Month__c!=null) {
        objPerformance.Period__c = 'Monthly';
      }

      // Group update
      if( objPerformance.Data_Source__c.Contains('All')) {
        objPerformance.Group__c = 'All';
      } else if(objPerformance.Data_Source__c.Contains('TeamA')) {
        objPerformance.Group__c = 'Team A';
      } else if(objPerformance.Data_Source__c.Contains('TeamB')) {
        objPerformance.Group__c = 'Team B';
      } else {
        if(objPerformance.OwnerId!='00528000006wXP3' ) { // Steve
          objPerformance.Group__c = 'Personal';
        }
      }

      // Target Item update
      if(objPerformance.Product__c==System.Label.Product_BS) objPerformance.Target_Item__c = 'DUA';
      else if(objPerformance.Product__c==System.Label.Product_BAB) objPerformance.Target_Item__c = 'DUR';
      else if(objPerformance.Product__c==System.Label.Product_BARO) objPerformance.Target_Item__c = 'Imps';

		}
	}

  /************************************************************************************
  *	 Check if Month value is the same with the old value
  *************************************************************************************/
    private void doDeleteOldRecord() {
      //지금 Insert된건 삭제되면 안된다.
      Set<Id> setIdNew = new Set<Id>();
      //key값들
      Set<String> setStrKey = new Set<String>();

      for(BD_Performance__c obj:listNew) {
        setIdNew.add(obj.Id);
        setStrKey.add(obj.Key__c);
      }

      List<BD_Performance__c> targetList = [
        SELECT Id
        FROM  BD_Performance__c
        WHERE Key__c in:setStrKey
        AND Id not in:setIdNew
      ];

      if(!targetList.isEmpty()) Delete targetList;
    }

}