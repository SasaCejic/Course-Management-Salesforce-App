public with sharing class PersonController {
    @AuraEnabled(cacheable = true)
    public static List<Person__c> getPersons(){
        
        return [
            SELECT Name, Record_Type_Name__c, Phone__c, Email__c
            FROM Person__c
            WITH SECURITY_ENFORCED
            ORDER BY Name
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
    public static List<Person__c> searchPersons(String searchTerm){
        searchTerm = searchTerm.trim();

        if (searchTerm == '') {
            return getPersons();
        }

        searchTerm = '%' + searchTerm + '%';

        return[
            SELECT Name, Record_Type_Name__c, Phone__c, Email__c
            FROM Person__c
            WHERE Name LIKE :searchTerm OR Phone__c LIKE :searchTerm OR Email__c LIKE :searchTerm
            WITH SECURITY_ENFORCED
            ORDER BY Name
        ];
    }



}