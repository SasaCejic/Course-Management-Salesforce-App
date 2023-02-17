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
}