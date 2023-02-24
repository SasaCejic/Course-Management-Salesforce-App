public with sharing class PersonController {
    @AuraEnabled(cacheable = true)
    public static List<Person__c> getPersons( Integer offset){
        
        return [
            SELECT Name, Record_Type_Name__c, Phone__c, Email__c
            FROM Person__c
            WITH SECURITY_ENFORCED
            ORDER BY Name
            LIMIT 10
            OFFSET :Integer.valueOf(offset)
        ];

    }

    @AuraEnabled(cacheable = true)
    public static String getStudentRecordTypeId(){
        return Schema.SObjectType.Person__c.getRecordTypeInfosByName().get('Student').getRecordTypeId();
    }

    @AuraEnabled(cacheable = true)
    public static String getTutorRecordTypeId(){
        return Schema.SObjectType.Person__c.getRecordTypeInfosByName().get('Tutor').getRecordTypeId();
    }

    @AuraEnabled(cacheable = true)
    public static List<Person__c> searchPersons(String searchTerm, Integer offset){
        searchTerm = searchTerm.trim();

        if (searchTerm == '') {
            return getPersons(offset);
        }

        searchTerm = '%' + searchTerm + '%';

        return[
            SELECT Name, Record_Type_Name__c, Phone__c, Email__c
            FROM Person__c
            WHERE Name LIKE :searchTerm OR Phone__c LIKE :searchTerm OR Email__c LIKE :searchTerm
            WITH SECURITY_ENFORCED
            ORDER BY Name
            LIMIT 10
            OFFSET :Integer.valueOf(offset)
        ];
    }

}