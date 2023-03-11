public with sharing class PersonDataService {
    
    public static List<Person__c> getData(String searchTerm, Integer offset, Integer limitValue){

        searchTerm = (String.isBlank(searchTerm)) ? '' : '%' + searchTerm.trim() + '%';
        offset = (offset == null || limitValue == null) ? 0 : Integer.valueOf(offset);
        limitValue = (limitValue == null) ? 0 : Integer.valueOf(limitValue);
        

        String whereClause = (searchTerm == '') ? '' : 'WHERE Name LIKE :searchTerm OR Phone__c LIKE :searchTerm OR Email__c LIKE :searchTerm';

        String limitClause = (limitValue == 0) ? '' : 'LIMIT :limitValue';

        String offsetClause = (offset == 0) ? '' : 'OFFSET :offset';


        String query = 'SELECT Name, Record_Type_Name__c, Phone__c, Email__c FROM Person__c ' + whereClause + ' WITH SECURITY_ENFORCED ORDER BY Name '+ limitClause + ' ' + offsetClause;

        return Database.query(query);
    }

    public static Id getRecordTypeId(String name){
        name = (String.isBlank(name) || (!name.equals('Tutor') && !name.equals('Student'))) ? 'Tutor' : name;

        return Schema.SObjectType.Person__c.getRecordTypeInfosByName().get(name).getRecordTypeId();
    }

    public static List<String> getRecordTypeNames(){

        List<RecordType> recordTypes = [SELECT Name FROM RecordType WHERE SObjectType = 'Person__c'];

        List<String> names = new List<String>();

        for(RecordType rt : recordTypes){
            names.add(rt.Name);
        }

        names.sort();

        return names;

    }

}