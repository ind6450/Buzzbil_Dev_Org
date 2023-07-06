/**
 - Created by DISCUSSION on 2022-05-24.
 - Function : Merge change by Opportunity Stage fields by record type.
 */

public with sharing class ctrlOpportunityStageChange {
    public class SObjectQueryResult {
        @AuraEnabled
        public String recordId;

        @AuraEnabled
        public String recordName;
    }

    @AuraEnabled (cacheable=true)
    public static List<SObjectQueryResult> retrieveRecords(String objectName,
            String fieldAPINames,
            String filterFieldAPIName,
            String strInput) {
        List<SObjectQueryResult> lstReturnResult = new List<SObjectQueryResult>();
        if(strInput.equals('*')){
            strInput = '';
        }
        String str = strInput + '%';
        String strQueryField = '';

        List<String> fieldList = fieldAPINames.split(',');
        //check if Id is already been passed
        if(!fieldList.contains('Id')){
            fieldList.add('Id');
            strQueryField = String.join(fieldList, ',');
        }else {
            strQueryField = fieldAPINames;
        }

        List<String> filterFieldAPINameList = new List<String>();
        if(filterFieldAPIName.contains(',')){
            filterFieldAPINameList = filterFieldAPIName.split(',');
            System.debug(filterFieldAPINameList);
        } else {
            filterFieldAPINameList.add(filterFieldAPIName);
        }

        Integer i = 1;
        String strQuery = 'SELECT ' + String.escapeSingleQuotes(strQueryField)
                + ' FROM '
                + String.escapeSingleQuotes(objectName)
                + ' WHERE ' ;
        for(String filterStr : filterFieldAPINameList){
            if(i != 1){
                strQuery += 'OR ';
            }
            strQuery += filterStr + '  LIKE \'%' + str + '%\'';
            if(i != filterFieldAPINameList.size()){
                strQuery += ' ';
            }
            i++;
        }
        // + filterFieldAPIName + '  LIKE \'' + str + '%\''
        strQuery        += ' ORDER BY ' + filterFieldAPINameList[0];
        strQuery        += ' LIMIT 50';
        System.debug('# strQuery=' + strQuery);

        List<SObject> lstResult = database.query(strQuery);

        //create list of records that can be easily be parsable at js controller.
        for(String strField:fieldList){
            for(SObject sobj:lstResult){
                if(strField != 'Id'){
                    SObjectQueryResult result = new SObjectQueryResult();
                    result.recordId = (String) sobj.get('Id');
                    result.recordName = (String) sobj.get(strField);
                    lstReturnResult.add(result);
                }
            }
        }
        return lstReturnResult;
    }
}