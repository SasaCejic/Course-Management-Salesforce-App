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



}