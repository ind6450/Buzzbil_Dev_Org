/**
 * @Subject : sObject 관련 유틸리티
 * @Description : SObject의 List, Map, Set변환과 특정필드 및 레코드 변환에 관한 유틸
 */
public with sharing class util_SObject {

    // 특정 개체의 레코드 타입 Id를 List 타입으로 리턴한다.
    public static List<RecordType> getRecordTypeIdList(String obj_name) {
        List<RecordType> rtypelist = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SobjectType=:obj_name];

        return rtypelist;
    }//function()

    /**
     * @Description 특정 레코드 Id를 넘겨 어떤 개체인지 판단한다.
     */
    public static Schema.SObjectType getSObjectTypeById(Id target_id) {

        return target_id.getSObjectType();
    }


    /**
     * @Description 특정 레코드 Id를 받아 오브젝트명을 리턴한다.
     */
    public static String getNameByRecordId(id record_id) {

        return '' + record_id.getSObjectType();
    }


    /**
     * @Description 특정 오브젝트를 받아 오브젝트명을 리턴한다.
     */
    public static String getNameBySObject(SObject sobj){

        return '' + sobj.getSObjectType();
    }

    // 특정 개체에서 체크박스 필드명만 리턴한다.
    public static Set<String> getChkBoxFieldName(sObject sobj) {
        String obj_name = getNameBySObject(sobj);
        Map<String, Schema.SobjectField> fields_map = getObjectFieldsMap(obj_name);
        String result_str = null;
        Set<String> result_set = new Set<String>{};

        Schema.DescribeFieldResult fr;
        for(String key1 : fields_map.keySet()) {
            //Schema.Sobjectfield field = fields_map.get(key1);
            fr = fields_map.get(key1).getDescribe();
            String tmp_name = fr.getName();

            if(fr.getType() == Schema.DisplayType.Boolean) {
                //result_str = (result_str == null) ? tmp_name : result_str + ',' + tmp_name;
                result_set.add(tmp_name);
            }

        }//for

        return result_set;

    }//function()


    // 특정 개체에서 금액(Currency) 필드명만 리턴한다.
    public static Set<String> getCurrencyFieldName(sObject sobj) {
      String obj_name = getNameBySObject(sobj);
      Map<String, Schema.SobjectField> fields_map = getObjectFieldsMap(obj_name);
      String result_str = null;
      Set<String> result_set = new Set<String>{};

      Schema.DescribeFieldResult fr;
      for(String key1 : fields_map.keySet()) {
        //Schema.Sobjectfield field = fields_map.get(key1);
        fr = fields_map.get(key1).getDescribe();
        String tmp_name = fr.getName();

        if(fr.getType() == Schema.DisplayType.Currency) {
          //result_str = (result_str == null) ? tmp_name : result_str + ',' + tmp_name;
          result_set.add(tmp_name);
        }

      }//for

      return result_set;

    }//function()


    // 특정 개체에서 Custom Date 필드명만 리턴한다.
    public static Set<String> getDateFieldName(sObject sobj) {
      String obj_name = getNameBySObject(sobj);
      Map<String, Schema.SobjectField> fields_map = getObjectFieldsMap(obj_name);
      //Map<String, String> fields_map = getCustomFieldsName2Map(obj_name, false);
      String result_str = null;
      Set<String> result_set = new Set<String>{};

      Schema.DescribeFieldResult fr;
      for(String key1 : fields_map.keySet()) {
        //Schema.Sobjectfield field = fields_map.get(key1);
        fr = fields_map.get(key1).getDescribe();
        String tmp_name = fr.getName();

        if(fr.getType() == Schema.DisplayType.Date && fr.isCustom() == true ) {
          //result_str = (result_str == null) ? tmp_name : result_str + ',' + tmp_name;
          result_set.add(tmp_name);
        }

      }//for
      return result_set;

    }//function()

    /**
     * @Description 오브젝트명으로 모든필드명 리턴
     */
    public static String getAllFieldName(String obj_name) {
        // getAllFieldName4Query 메소드 호출
        return getAllFieldName4Query(obj_name, false, false);
    }

    /**
     * @Description 쿼리를 하기 위해 특정 오브젝트에 대한 전체 (중 일부 조건을 제외하고 나머지) 필드명을 리턴한다.<br>
     *              Id 필드는 어떠한 경우에도 꼭! 읽어온다.<br>
     *              개발시에 개발자가 해당 메서드를 적용 할 수 있을지 여부를 미리 판단하도록<br>
     *              Limits.getLimitFieldsDescribes()에 대한 처리는 하지 않았다.<br>
     *
     * @param obj_name - 대상 오브젝트명
     * @param isCustomFieldOnly - 사용자 정의 필드만 읽은 것인가?
     * @param isUpdateableFieldOnly - 업데이트 가능한 필드만 읽을 것인가?
     */
    public static String getAllFieldName4Query(String obj_name, Boolean isCustomFieldOnly, Boolean isUpdateableFieldOnly) {

        // 특정 오브젝트의 필드를 모두 가져온다.
        Map< String, Schema.Sobjectfield > fields_map = getObjectFieldsMap(obj_name);

        // 필드명을 가질 Set을 생성한다.
        Set<String> field_name_set = new Set<String>();
        // 모든 필드명을 Set에 추가한다.
        for(String tmp_field_name : fields_map.keySet()) {
            field_name_set.add(tmp_field_name);
        }

        Schema.Describefieldresult fr;
        String my_type_str = null;
        // 필드명을 모두 체크하여 필요없는 필드는 제거한다
        for (String key1: fields_map.keySet()) {

            // Id는 언제나 필수로 넣어줌.
            if(key1 == 'id') {
                continue;

            }  // 옵션과 무관하게 항상 제거해도 되는 필드들
            else if (key1 == 'jigsaw' || key1 == 'isdeleted' || key1 == 'description') {
                field_name_set.remove(key1);
                continue;
            }

            //Schema.Sobjectfield field = fields_map.get(key1);
            fr = fields_map.get(key1).getDescribe();

            // 엑세스 불가한 것은 삭제
            if(fr.isAccessible()==false) {
                field_name_set.remove(key1);
                continue;

            } // 업데이트 가능한 것만 쿼리 할 경우 체크 / 사용자 정의 필드만 쿼리 할 경우 체크 후 삭제
            else if ((isUpdateableFieldOnly == true && fr.isUpdateable() == false) || (isCustomFieldOnly == true && fr.isCustom() == false)) {
                field_name_set.remove(key1);
                continue;
            }

            // 필드 타입명 취득
            my_type_str = fr.getType().name();

            // 알아서 제외 할 타입명 (암호화, base64=BLOB, 데이터 카테고리 필드), 필요하면 개발자가 직접 추가로 기입한다.
            if (my_type_str == 'encryptedString' || my_type_str == 'base64' || my_type_str == 'datacategorygroupreference') {
                field_name_set.remove(key1);
                continue;
            }
        }

        obj_name = null;

        // 필드명을 콤마로 연결하여 리턴한다
        return util_Collection.extJoin(field_name_set, null, null, null);
    }


    /**
     * @Description Map <String, Schema.Sobjectfield>을 리턴 할 때 결과를 캐시처리
     */
    private static Map<String, Map<String, Schema.Sobjectfield>>field_map_cache = new Map<String, Map<String, Schema.Sobjectfield>>();


    /**
     * @Description 특정 오브젝트명에 대한 Map<String, Schema.Sobjectfield>을 리턴한다.
     */

    public static Map<String, Schema.Sobjectfield> getObjectFieldsMap(String obj_name) {
        // 오브젝트명으로 실제 오브젝트를 생성한다
        SObject sobj = getSObjectByName(obj_name);
        // 맵생성
        Map<String, Schema.Sobjectfield> result_map = null;

        // Too many fields describes: 101 회피를 위해 캐시처리
        if(field_map_cache.containsKey(obj_name) == false) {
            // 오브젝트의 필드들을 맵에 추가
            result_map = sobj.getSObjectType().getDescribe().fields.getMap();
            // 맵에 오브젝트명과 오브젝트의 필드맵을 추가한다
            field_map_cache.put(obj_name, result_map);
        }

        // 오브젝트의 필드맵을 리턴한다
        return field_map_cache.get(obj_name);
    }


    // 특정 오브젝트의 특정 필드명의 Pick List Value를 List<String>으로 리턴한다.
    public static List<String> getPickListValues(String obj_name, String field_name) {
        Schema.Sobjectfield field_list = getFieldDescribe(obj_name, field_name);

        PicklistEntry[] picklistValues = field_list.getDescribe().getPicklistValues();
        Integer len = picklistValues.size();
        List<String> result_list = new List<String>{};
        for(Integer i = 0; i < len; i++) {
            result_list.add(picklistValues[i].getLabel());
        }

        return result_list;
    }


    /**
     * @Description 특정 오브젝트 + 특정 필드명으로 개별 필드타입(Schema.SObjectfield) 을 반환한다.
     */
    public static Schema.Sobjectfield getFieldDescribe(String obj_name, String field_name) {
        // 오브젝트의 필드맵에서 특정 필드타입을 리턴
        return getObjectFieldsMap(obj_name).get(field_name);
    }


    /**
     * @Description 특정 오브젝트명으로 해당 오브젝트의 시스템 필드명을 Map<String, String>으로 리턴한다.<br>
     *               커스텀 필드가 아닌 필드들의 맵 리턴
     */
/*
    public static Map<String, String> getSystemFieldsName2Map(String obj_name) {
        Map<String, Schema.Sobjectfield> fields_map = getObjectFieldsMap(obj_name);

        Map<String, String> result_map = new Map<String, String>{};
        Schema.Describefieldresult fr = null;
        for(String key1 : fields_map.keySet()) {

            fr = fields_map.get(key1).getDescribe();

            // 시스템 필드일 경우 포함한다.
            if(fr.isCustom() == false) {
                result_map.put(key1, fr.getLabel());
            }

            fr = null;
        }

        return result_map;
    }
*/

    /**
     * @Description 특정 오브젝트명으로 해당 오브젝트의 업데이트 가능한 필드명을 Map<String, String>으로 리턴한다.
     */

    public static Map<String, String> getUpdateableFieldsName2Map(String obj_name, Boolean onlyCustomField) {
        Map<String, Schema.Sobjectfield> fields_map = getObjectFieldsMap(obj_name);

        Map<String, String> result_map = new Map<String, String>{};
        Schema.Describefieldresult fr = null;
        for(String key1 : fields_map.keySet()) {

            fr = fields_map.get(key1).getDescribe();

            // Custom Field만 허용 할 건데 Custom Field가 아니라면
            if(onlyCustomField == true && fr.isCustom() == false) {
                continue;
            }

            // 업데이트 가능한 필드라면
            if (fr.isUpdateable() == true) {
                result_map.put(key1, fr.getLabel());
            }

            fr = null;
        }

        return result_map;
    }


    /**
     * @Description 특정 오브젝트명으로 해당 오브젝트의 custom field을 Map<String, String>으로 리턴한다.
     */

    public static Map<String, String> getCustomFieldsName2Map(String obj_name, Boolean onlyUpdateableField) {
        Map<String, Schema.Sobjectfield> fields_map = getObjectFieldsMap(obj_name);

        Map<String, String> result_map = new Map<String, String>{};
        Schema.Describefieldresult fr = null;
        for(String key1 : fields_map.keySet()) {
            fr = fields_map.get(key1).getDescribe();

            // 업데이트 가능한 필드만 조회해야 할 경우 업데이트 불가한 필드가 걸렸다면~
            if(onlyUpdateableField == true && fr.isUpdateable() == false) {
                continue;
            }

            // 커스톰 필드라면 삽입
            if(fr.isCustom() == true) {
                result_map.put(key1, fr.getLabel());
            }

            fr = null;
        }

        return result_map;
    }

/*
    // 현재 사용자가 특정 개체를 업데이트 할 수 있는가?
    public static Boolean getIsUpdatable(String obj_name) {
        SObject sobj = getSObjectByName(obj_name);

        return sobj.getSObjectType().getDescribe().isUpdateable();
    }


    // 현재 사용자가 특정 개체를 생성 할 수 있는가?
    public static Boolean getIsCreatable(String obj_name) {
        SObject sobj = getSObjectByName(obj_name);

        return sobj.getSObjectType().getDescribe().isCreateable();
    }


    // 현재 사용자가 특정 개체를 삭제 할 수 있는가?
    public static Boolean getIsDeletable(String obj_name) {
        SObject sobj = getSObjectByName(obj_name);

        return sobj.getSObjectType().getDescribe().isDeletable();
    }
*/

/*
     // @Description 특정 오브젝트명에 대한 key Prefix를 리턴함.
    public static String getKeyPrefix(String obj_name) {
        SObject sobj = getSObjectByName(obj_name);

        return sobj.getSObjectType().getDescribe().getKeyPrefix();
    }
*/

    // @Description 특정 S오브젝트를 Map<String, Object> 값으로 리턴한다. (오브젝트에 대응)
/*
   public static Map<String, Object> getObject2Map(SObject sobj1) {
        // 두개의 오브젝트에서 필드명을 추출하여 Map에 담는다.
        String tmp_str = JSON.serialize(sobj1);

        return (Map<String, Object>) JSON.deserializeUntyped(tmp_str);
   }


  // @Description 특정 오브젝트를 Map<String, Object> 값으로 리턴한다. (클래스에 대응)
   public static Map<String, Object> getObject2Map(Object obj1) {

        // 두개의 오브젝트에서 필드명을 추출하여 Map에 담는다.
        String tmp_str = JSON.serialize(obj1);

        return (Map<String, Object>) JSON.deserializeUntyped(tmp_str);
   }

     // @Description 두개의 SObject에 대해 갖고 있는 모든 필드명을 비교하여 다른 값이 있는지 비교하고 그 필드명들을 리턴
    private static Set<String> getNotEqualFieldsValue2Set2(SObject obj1, SObject obj2, Boolean onlyCustomField, Boolean onlyUpdateableField, Set<String> exclude_field_group_set) {

        // 두개의 오브젝트에서 필드명을 추출하여 Map에 담는다.
        Map<String, Object> tmp1_map = getObject2Map(obj1);
        Map<String, Object> tmp2_map = getObject2Map(obj2);

        Map<String, String> field_group_map = null; // 비교대상 필드그룹
        String obj_name = getNameBySObject(obj1); // 오브젝트명을 가져온다.

        // 커스톰 필드만을 허용 할 때
        if(onlyCustomField == true) {
            field_group_map = getCustomFieldsName2Map(obj_name, onlyUpdateableField);

        // 업데이트 가능한 필드만을 비교해야 할 때
        } else if (onlyUpdateableField == true) {
            field_group_map = getUpdateableFieldsName2Map(obj_name, onlyCustomField);
        }

        //System.debug('비교 할 필드명 : ' + field_group_map);

        Set<String> result_set = new Set<String>{};
        for(String key1 : tmp1_map.keySet()) {

            // 비교 대상 필드그룹에 속하지 않는 녀석은 비교 안하고 건너뛴다.
            if(field_group_map != null && field_group_map.containsKey(key1) == false) {
                //System.debug('건너 뛸 녀석 : ' + key1);
                continue;
            }

            // 두 값이 다르다면 비교에서 제외 할 필드명에서 속하지 않는다면 다른 값으로 본다.
            if(tmp1_map.get(key1) != tmp2_map.get(key1) && exclude_field_group_set.contains(key1) == false) {
                result_set.add(key1); // 틀린 필드값의 이름을 리턴
            }
        }

        tmp1_map.clear();
        tmp2_map.clear();

        tmp1_map = tmp2_map = null;
        obj_name = null;

        if(field_group_map != null) {
            field_group_map.clear();
            field_group_map = null;
        }

        return result_set;
    }
*/

    //@Description 특정 오브젝트명을 받아 SObject를 생성하여 리턴한다.
    public static SObject getSObjectByName(String obj_name) {

       return (SObject) Type.forName(obj_name).newInstance();
    }

    // 특정 오브젝트의 특정 DeveloperName을 이용하여 Record Type Id를 리턴
    public static Id getRecordTypeId(String obj_name, String developer_name) {
        List<RecordType> my_list = getRecordTypeIdList(obj_name);

        for(RecordType rt : my_list) {
            if(rt.DeveloperName == developer_name) {
                return rt.Id;
            }
        }

        return null;
    }


    /**
     * @Description 특정 오브젝트명 + 레코드 타입아이디로 레코드 Label을 반환한다.
     */
    public static String getRecordTypeName(String obj_name, Id record_type_id) {
        SObject sobj = getSObjectByName(obj_name);

        return sobj.getSObjectType().getDescribe().getRecordTypeInfosById().get(record_type_id).getName();
    }

    // 특정 User Id들에 매칭되어 있는 Profile Id를 Map<Id, Id> 형태로 리턴한다.
    public static Map<Id, Id> getUserId2ProfileIdMap(Set<Id> user_id_set) {
            Map<Id, Id> user_id2profile_id_map = new Map<Id, Id>{};
            for(User user1 : [SELECT Id, ProfileId FROM User WHERE Id IN :user_id_set]) {
                user_id2profile_id_map.put(user1.Id, user1.ProfileId);
            }//for

            return user_id2profile_id_map;
    }//function()

    /*
        // Field Set을 리턴한다.
        public static List<Schema.FieldSetMember> getFieldSet(String objName, String fieldSetName) {
            Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe();
            Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(objName);
            Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
            Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);

            return fieldSetObj.getFields();
        }
    */
}