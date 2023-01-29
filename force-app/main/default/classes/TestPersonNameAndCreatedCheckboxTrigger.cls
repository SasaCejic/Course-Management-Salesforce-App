@isTest
public with sharing class TestPersonNameAndCreatedCheckboxTrigger {
    
    @isTest
    static void insertPerson_ShouldPopulateNameFieldWithFirstAndLastNameAndCheckCreatedCheckbox_WhenRecordIsCreated(){

        Person__c person = new Person__c(First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = 'cejicsasa17@gmail.com');

        Test.startTest();

        insert person;

        String personId = String.valueOf(person.Id);

        Person__c createdRecord = [SELECT Name, Created__c FROM Person__c WHERE Id = :personId LIMIT 1];

        System.assertEquals('FirstName LastName', createdRecord.Name);
        System.assert(createdRecord.Created__c);

        Test.stopTest();

    }

}