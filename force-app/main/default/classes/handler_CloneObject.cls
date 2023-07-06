/*
* ---------------------------------------------------------------------
*
* Subject : 레코드 복제
* Tester : handler_CloneObjectTester
*
* Description : 각종 레코드의 복제
*
* ---------------------------------------------------------------------
*/
public with sharing class handler_CloneObject {
	public static Boolean isCloneMode = false; // 복제모드여부 체크 (트리거에서 참고하기 위함.)
	private handler_CloneObject() {}
	private static handler_CloneObject sInstance = null;

	// 인스턴스 반환
	public static handler_CloneObject getInstance() {
		if(sInstance == null) {
			sInstance = new handler_CloneObject();
		}

		return sInstance;
	}//function()


	// 특정 레코드 리스트의 체크박스 값을 클리어 한다.
	public void clearChkboxValueList(List<sObject> sobj_list) {
		for(sObject sobj : sobj_list) {
			clearChkboxValue(sobj);
		}//for
	}//function()

	// 특정 레코드의 체크박스 값을 클리어 한다.
	public void clearChkboxValue(sObject sobj) {
		// 체크박스 필드명을 가져온다.
		Set<String> chk_box_field_name = util_Sobject.getChkBoxFieldName(sobj);
		for(String tmp_field_name : chk_box_field_name) {
			try {

				if(sobj.get(tmp_field_name) != null) {
					sobj.put(tmp_field_name, false);
				}//if

			} catch(SObjectException e) {
				System.debug('exception : ' + e.getMessage());
			}
		}//for
	}//function()


	// 특정 레코드 리스트의 Currency 값을 클리어 한다.
	public void clearCurrencyValueList(List<sObject> sobj_list) {
		for(sObject sobj : sobj_list) {
			clearCurrencyValue(sobj);
		}//for
	}//function()

	// 특정 레코드의 Currency 값을 클리어 한다.
	public void clearCurrencyValue(sObject sobj) {
		// Currency 필드명을 가져온다.
		Set<String> currencyFieldname = util_Sobject.getCurrencyFieldName(sobj);
		for(String tmp_field_name : currencyFieldname) {
			try {

				if(sobj.get(tmp_field_name) != null) {
					sobj.put(tmp_field_name, 0);
				}//if

			} catch(SObjectException e) {
				System.debug('exception : ' + e.getMessage());
			}
		}//for
	}//function()


		// 특정 레코드 리스트의 Date 값을 클리어 한다.
		public void clearDateValueList(List<sObject> sobj_list) {
			for(sObject sobj : sobj_list) {
				clearDateValue(sobj);
			}//for
		}//function()

		// 특정 레코드의 Date 값을 클리어 한다.
		public void clearDateValue(sObject sobj) {
			// Currency 필드명을 가져온다.
			Set<String> dateFieldname = util_Sobject.getDateFieldName(sobj);
			for(String tmp_field_name : dateFieldname) {
				try {

					if(sobj.get(tmp_field_name) != null) {
						sobj.put(tmp_field_name, null);
					}//if

				} catch(SObjectException e) {
					System.debug('exception : ' + e.getMessage());
				}
			}//for
		}//function()


	// 레코드를 복제하여 리턴한다.
	public sObject getCloneRecord2(sObject old_sobj, Boolean inCludingRelationField) {
		isCloneMode = true;
		sObject new_sobj = old_sobj.clone(false, inCludingRelationField, false, false); // 복제한다.

		return new_sobj;
	}

	// 레코드를 복제하여 리턴한다.
	public sObject getCloneRecord(Id my_id, Boolean includingRelationField) {
		// 복제 할 원본의 필드값을 읽어 오기 위해...
		String obj_name = util_Sobject.getNameByRecordId(my_id);
		String fields_name = util_Sobject.getAllFieldName4Query(obj_name, false, true);
		String query = 'SELECT ' + fields_name + ' FROM ' + obj_name + ' WHERE Id =:my_id';
		List<sObject> sobj_list = Database.query(query);
		sObject old_sobj = sobj_list[0];
		sObject new_sobj = getCloneRecord2(old_sobj, inCludingRelationField);
 
        //System.debug('**** getCloneRecord / query : ' + query);

		return new_sobj;
	}

	// 레코드를 복제하여 리턴한다.(한번에 여러개 복제하지 말 것! SOQL Limits)
	public sObject getCloneRecord(SObject old_sobj, Boolean includingRelationField) {
		sObject sobj = getCloneRecord( (Id) old_sobj.get('id'), inCludingRelationField );

		return sobj;

	}//function()

}//class