/**
* @Subject : 컬렉션 관련 유틸
*
* @Description :
* 1. xxx__r.Name과 같은 Relation 관계의 필드명은 현재 사용 할 수 없음. <br>
* 3. List reverse 추가 <br>
*
*/
public with sharing class util_Collection {
	public void util_Collection(){} // 생성자

	/**
	 * @Description 사용법이 잘못 되었을 경우의 예외처리
	 */
	private class UsageException extends Exception{}
	/**
	 * @Description 정렬방식 지정 Enum(ASC1, DES1)
	 */
	public enum OrderByTypeEnum{ASC1, DESC1}

   	
    /**
	 * @Description 어떤 문자열을 받아 Set<String>으로 리턴한다.
	 */
	public static Set<String> getStrValue2Set(String source_str, String separator) {

    	if(separator == null) {
    		separator = ',';
    	}

    	List<String> tmp_list = source_str.split(separator);
    	Set<String> tmp_set = new Set<String>{};

	    // 공백이 있으면 제거하기 위해~
	    for(String tmp_str : tmp_list) {
	    	tmp_set.add( tmp_str.trim() );
	    }

    	//destroy(tmp_list);

    	return tmp_set;
	}
  
    /**
	 * @Description 비어 있거나 Null인지 여부를 반환
	 */
	public static Boolean isBlank(Map<Id, String> my_map) {

		return (my_map == null || my_map.size() == 0);
	}

	/**
	 * @Description 비어 있지 않고 유효한지 여부를 반환
	 */
	public static Boolean isNotBlank(Map<Id, String> my_map) {

		return (isBlank(my_map) == false);
	}

	/**
	 * @Description 비어 있거나 Null인지 여부를 반환
	 */
	public static Boolean isBlank(Map<String, String> my_map) {

		return (my_map == null || my_map.size() == 0);
	}

	/**
	 * @Description 비어 있지 않고 유효한지 여부를 반환
	 */
	public static Boolean isNotBlank(Map<String, String> my_map) {

		return (isBlank(my_map) == false);
	}

	/**
	 * @Description 비어 있거나 Null인지 여부를 반환
	 */
	public static Boolean isBlank(Map<Integer, String> my_map) {

		return (my_map == null || my_map.size() == 0);
	}

	/**
	 * @Description 비어 있지 않고 유효한지 여부를 반환
	 */
	public static Boolean isNotBlank(Map<Integer, String> my_map) {

		return (isBlank(my_map) == false);
	}

	/**
	 * @Description 비어 있거나 Null인지 여부를 반환
	 */
	public static Boolean isBlank(List<Object> my_list) {
		return (my_list == null || my_list.size() == 0);
	}

	/**
	 * @Description 비어 있거나 Null인지 여부를 반환
	 */
	public static Boolean isNotBlank(List<Object> my_list) {

		return (isBlank(my_list) == false);
	}

	/**
	 * @Description 비어 있거나 Null인지 여부를 반환
	 */
	public static Boolean isBlank(List<SObject> my_list) {

		return (my_list == null || my_list.size() == 0);
	}

	/**
	 * @Description 비어 있거나 Null인지 여부를 반환
	 */
	public static Boolean isBlank(Set<String> my_set) {

		return (my_set == null || my_set.size() == 0);
	}

	/**
	 * @Description 비어 있거나 Null인지 여부를 반환
	 */
	public static Boolean isNotBlank(List<SObject> my_list) {

		return (isBlank(my_list) == false);
	}



	/**
	 * @Description 비어 있거나 Null인지 여부를 반환
	 */
	public static Boolean isNotBlank(Set<String> my_set) {

		return (isBlank(my_set) == false);
	}


	/**
	 * @Description 비어 있거나 Null인지 여부를 반환
	 */
	public static Boolean isBlank(Set<SObject> my_set) {

		return (my_set == null || my_set.size() == 0);
	}

	/**
	 * @Description 비어 있거나 Null인지 여부를 반환
	 */
	public static Boolean isNotBlank(Set<SObject> my_set) {

		return (isBlank(my_set) == false);
	}


	/**
	 * @Description 비어 있거나 Null인지 여부를 반환
	 */
	public static Boolean isBlank(Set<Id> my_set) {

		return (my_set == null || my_set.size() == 0);
	}

	/**
	 * @Description 비어 있거나 Null인지 여부를 반환
	 */
	public static Boolean isNotBlank(Set<Id> my_set) {

		return (isBlank(my_set) == false);
	}

	public static Boolean isBlank (List<PermissionSet> PermissionSet_list) {
		return (PermissionSet_list == null || PermissionSet_list.size() == 0);
	}

	public static Boolean isNotBlank(List<PermissionSet> PermissionSet_list) {
		return (isBlank(PermissionSet_list) == false);
	}

	/**
	 * @Description 모두 Not Null이면 True 아니면 False
	 */
	public static Boolean isAllNotNull(List<Object> my_list) {
		return (isContainsNull(my_list) == false);
	}

	/**
	 * @Description 비어 있거나 Null인지 여부를 반환
	 */
	public static Boolean isNotBlank(Set<Integer> my_set) {

		return (isBlank(my_set) == false);
	}

	/**
	 * @Description 비어 있거나 Null인지 여부를 반환
	 */
	public static Boolean isBlank(Set<Integer> my_set) {

		return (my_set == null || my_set.size() == 0);
	}
    
    	
	/**
	 * @Description 특정 선택목록에 유효한 값이 하나라도 들어 있는지 여부를 리턴
	 */
	public static Boolean hasValidItem(List<SelectOption> option_list) {
		
		Boolean flag = true;
		
		if(option_list == null || option_list.size() == 0) {
			flag = false;
		
		} else if (option_list.size() == 1 && (option_list[0].getValue() == null || option_list[0].getValue() == '') ) {
			flag = false;
			
		}
	
		return flag;
	}

/////////////////////////////
    

	/**
	 * @Description 특정 Set<String>를 받아서 0번째 String값을 리턴한다.
	 */
	public static String getStrFromSet(Set<String> my_set) {
		if(util_Collection.isNotBlank(my_set)) {
			for(String tmp_str : my_set) {
				return tmp_str;
			}
		}

		return null;
	}


	/**
	 * @Description 리스트로 넘어온 오브젝트 중에 하나라도 null이 있는가?
	 */
	public static Boolean isContainsNull(List<Object> my_list) {
		for(Object obj : my_list) {
			if(obj == null) {
				return true;
			}
		}

		//destroy(my_list); // 제거

		return false;
	}

	/**
	 * @Description Map<Id, Integer>를 제거한다.
	 */
	public static void destroy(Map<Id, Integer> my_map) {
		if(my_map != null) {
			my_map.clear();
			my_map = null;
		}
	}

	/**
	 * @Description Map<Id, Decimal>를 제거한다.
	 */
	public static void destroy(Map<Id, Decimal> my_map) {
		if(my_map != null) {
			my_map.clear();
			my_map = null;
		}
	}

	/**
	 * @Description Map<Id, String>를 제거한다.
	 */
	public static void destroy(Map<Id, String> my_map) {
		if(my_map != null) {
			my_map.clear();
			my_map = null;
		}
	}

	/**
	 * @Description Map<Id, Id>를 제거한다.
	 */
	public static void destroy(Map<Id, Id> my_map) {
		if(my_map != null) {
			my_map.clear();
			my_map = null;
		}
	}

	/**
	 * @Description Map<Id, Id>를 제거한다.
	 */
	public static void destroy(Map<String, Id> my_map) {
		if(my_map != null) {
			my_map.clear();
			my_map = null;
		}
	}

	/**
	 * @Description Map<String, String>을 제거한다.
	 */
	public static void destroy(Map<String, String> my_map) {
		if(my_map != null) {
			my_map.clear();
			my_map = null;
		}
	}

	/**
	 * @Description Map<Integer, String>을 제거한다.
	 */
	public static void destroy(Map<Integer, String> my_map) {
		if(my_map != null) {
			my_map.clear();
			my_map = null;
		}
	}

	/**
	 * @Description List를 제거한다.
	 */
	public static void destroy(List<Object> my_list) {
		if(my_list != null) {
			my_list.clear();
			my_list = null;
		}
	}

	/**
	 * @Description List를 제거한다.
	 */
	public static void destroy(List<SObject> my_list) {
		if(my_list != null) {
			my_list.clear();
			my_list = null;
		}
	}

    
	/**
	 * @Description Set을 제거한다.
	 */
	public static void destroy(Set<SObject> my_set) {
		if(my_set != null) {
			my_set.clear();
			my_set = null;
		}
	}


	/**
	 * @Description Set을 제거한다.
	 */
	public static void destroy(Set<Integer> my_set) {
		if(my_set != null) {
			my_set.clear();
			my_set = null;
		}
	}


	/**
	 * @Description Set을 제거한다.
	 */
	public static void destroy(Set<Id> my_set) {
		if(my_set != null) {
			my_set.clear();
			my_set = null;
		}
	}


	/**
	 * @Description Set을 제거한다.
	 */
	public static void destroy(Set<String> my_set) {
		if(my_set != null) {
			my_set.clear();
			my_set = null;
		}
	}

	/**
	 * @Description 어떤 Set<Integer>를 받아 원하는 문자열로 리턴한다.
	 */
	public static String extJoin(Set<Integer> my_set, String separator, String add_prefix, String add_suffix) {
		List<Integer> my_list = new List<Integer>{};
		my_list.addAll(my_set);
		my_list.sort();

		//destroy(my_set);

		return extJoin(my_list, separator, add_prefix, add_suffix);
	}


	/**
	 * @Description 어떤 Set<Id>을 받아 원하는 문자열로 리턴한다.
	 */
	public static String extJoin(Set<Id> my_set, String separator, String add_prefix, String add_suffix) {
		List<Id> my_list = new List<Id>{};
		my_list.addAll(my_set);
		my_list.sort();

		//destroy(my_set);

		return extJoin(my_list, separator, add_prefix, add_suffix);
	}


	/**
	 * @Description 어떤 Set<String>을 받아 원하는 문자열로 리턴한다.
	 */
	public static String extJoin(Set<String> my_set, String separator, String add_prefix, String add_suffix) {
		List<String> my_list = new List<String>{};
		my_list.addAll(my_set);
		my_list.sort();

		//destroy(my_set);

		return extJoin(my_list, separator, add_prefix, add_suffix);
	}


	/**
	 * @Description List<Object>를 원하는 문자열 형태로 리턴한다. - 대상 List<Object>, 구분자, 접두어, 접미어
	 */
	public static String extJoin(List<Object> my_list, String separator, String add_prefix, String add_suffix, Boolean destroy_source_list) {

		String result_str = '';
		Integer len = my_list.size();
		for(Integer i = 0; i < len; i++) {
			//System.debug('하나씩 찍어보기 ' + my_list[i]);
			String tmp_str = getObj2Str4ExtJoin(i, my_list[i], separator, add_prefix, add_suffix);
			//System.debug('받은 값 찍어보기 ' + tmp_str);
			result_str += tmp_str;
		}

		if(destroy_source_list == true) {
			destroy(my_list); // 제거
		}

		return result_str;
	}


	/**
	 * @Description List<Object>를 원하는 문자열 형태로 리턴한다. - 대상 List<Object>, 구분자, 접두어, 접미어
	 */
	public static String extJoin(List<Object> my_list, String separator, String add_prefix, String add_suffix) {

		return extJoin(my_list, separator, add_prefix, add_suffix, true);
	}


	/**
	 * @Description List<SObject>의 특정 필드값을 추출하여 원하는 문자열 형태로 리턴한다. Null 값은 자동으로 제외된다.
	 */
	public static String extJoin(List<SObject> my_list, String taget_field_name, String separator, String add_prefix, String add_suffix) {

		return extJoin(my_list, taget_field_name, separator, add_prefix, add_suffix, true);
	}


	// 어떤 Select Option의 Label 또는 Value를 추출하여 문자열 형태로 리턴한다.
	public static String extJoin(List<Selectoption> my_list, Boolean isLabel, String separator, String add_prefix, String add_suffix) {
		List<String> tmp_list = null;

		if(util_Collection.isNotBlank(my_list)) {
			tmp_list = new List<String>{};

			for(Selectoption option1 : my_list) {
				String tmp_str = isLabel ? option1.getLabel() : option1.getValue();
				tmp_list.add(tmp_str);
			}
		}

		return extJoin(tmp_list, separator, add_prefix, add_suffix);
	}

	/**
	 * @Description 원하는 문자열 형태로 리턴한다. - List<SObject>와 필드명, 구분자를 받아서
	 */
	public static String extJoin(List<SObject> my_list, String field_name, String separator, String add_prefix, String add_suffix, Boolean destroy_source_list) {

		chkValid(field_name); // 유효성 체크

		List<Object> tmp_list = new List<Object>{};
		for(SObject sobj : my_list)
		{
			tmp_list.add( sobj.get(field_name) );
		}

		if(destroy_source_list == true) {
			destroy(my_list); // 제거
		}

		return extJoin(tmp_list, separator, add_prefix, add_suffix);
	}


	/**
	 * @Description extJoin에서 공통적으로 사용하는 함수
	 */
	private static String getObj2Str4ExtJoin(Integer idx_num, Object obj, String separator, String add_prefix, String add_suffix){

		separator = (separator == null) ? ',' : separator; // 구분자
		add_prefix = (add_prefix == null) ? '' : add_prefix; // 접두어
		add_suffix = (add_suffix == null) ? '' : add_suffix; // 접미어

		String result_str = null;
		//System.debug('진입 전 ' + obj + ' / ' + separator);
		if(obj != null) {
			//System.debug('테스트1');
			result_str = add_prefix + ('' + obj) + add_suffix;
			//System.debug('테스트2');
			result_str = (idx_num > 0) ? separator + result_str  : result_str; // 구분자
			//System.debug('테스트3');
		}
		//System.debug('진입 후 : ' + result_str);
		separator = add_prefix = add_suffix = null;

		return result_str;
	}


	/**
	 * @Description 메서드 사용 전 유효성 체크 - RelationShip 필드 적용불가 체크
	 */
	private static void chkValid(String field_name)
	{
		if(field_name.indexOf('__r') != -1)
		{
			throw new UsageException('RelationShip 필드는 적용 할 수 없습니다. 해당 개체의 util 클래스를 확인해보세요.');
		}
	}


	/**
	 * @Description 어떤 List와 key, key field, value field를 받아 key field의 값이 key와 일치하는 value field의 값을 리턴한다.
	 */
	public static Object getFieldValueByListFieldKey(List<SObject> my_list, String key_value, String key_field_name, String value_field_name) {

		if(my_list == null) {

			return null;
		}

		for(SObject sobj : my_list) {
			// Name으로 비교하고 Id값을 리턴한다
			if(sobj.get(key_field_name) == key_value) {
				return sobj.get(value_field_name);
			}
		}

		return null;
	}

}