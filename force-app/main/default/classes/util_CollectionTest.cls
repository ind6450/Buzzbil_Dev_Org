@isTest
private class util_CollectionTest {

	    static testMethod void myUnitTest() {
	        util_CollectionTest test1 = new util_CollectionTest();
	        test1.init();
	    }

	    public void init() {
	    	util_Collection.destroy(new List<SObject>{});
	    	util_Collection.destroy(new Map<Id, Id>{});
	    	util_Collection.destroy(new Map<Id, Decimal>{});
	    	util_Collection.destroy(new Map<Id, Integer>{});
	    	util_Collection.destroy(new Map<Id, String>{});
	    	util_Collection.destroy(new Map<Integer, String>{});
	    	util_Collection.destroy(new Map<String, Id>{});
	    	util_Collection.destroy(new Set<Id>{});
	    	util_Collection.destroy(new Set<String>{});
	    	util_Collection.destroy(new Set<Integer>{});
	    	util_Collection.destroy(new Set<SObject>{});
	    	util_Collection.destroy(new Map<String, String>{});
	    	util_Collection.extJoin(new List<SObject>{}, ',' , 'kaka', 'haha');
	    	util_Collection.extJoin(new List<SObject>{}, ',' , 'kaka', 'haha', true);
	    	util_Collection.extJoin(new List<SelectOption>{new SelectOption('ka', 'ke')}, true, 'kaka', 'ka1', 'ha1');
	    	util_Collection.extJoin(new Set<Id>{}, 'x', 'y', 'z');
	    	util_Collection.extJoin(new Set<Integer>{}, 'x', 'y', 'z');
	    	util_Collection.extJoin(new Set<String>{}, 'x', 'y', 'z');
	    	util_Collection.isBlank(new List<SObject>{});
	    	util_Collection.isBlank(new List<PermissionSet>{});
	    	util_Collection.isBlank(new Map<Id, String>{});
	    	util_Collection.isBlank(new Map<Integer, String>{});
	    	util_Collection.isBlank(new Map<String, String>{});
	    	util_Collection.isBlank(new Set<Integer>{});
	    	util_Collection.isBlank(new Set<String>{});
	    	util_Collection.isAllNotNull(new List<Object>{});
	    	util_Collection.isNotBlank(new List<Object>{});
	    	util_Collection.isNotBlank(new List<PermissionSet>{});
	    	util_Collection.isNotBlank(new List<SObject>{});
	    	util_Collection.isNotBlank(new Map<Id, String>{});
	    	util_Collection.isNotBlank(new Map<Integer, String>{});
	    	util_Collection.isNotBlank(new Map<String, String>{});
	    	util_Collection.isNotBlank(new Set<Id>{});
	    	util_Collection.isNotBlank(new Set<Integer>{});
	    	util_Collection.isNotBlank(new Set<SObject>{});
	    	util_Collection.isNotBlank(new Set<String>{});
            util_Collection.getStrValue2Set('abcd,test,123', ',');

	        util_Collection test1 = new util_Collection();

	    }
}