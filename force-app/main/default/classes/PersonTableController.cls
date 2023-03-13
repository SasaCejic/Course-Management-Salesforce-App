public with sharing class PersonTableController {
    
    public List<Person__c> getPersons(){
        return [SELECT Name, Record_Type_Name__c, Phone__c, Email__c FROM Person__c];
    }

}