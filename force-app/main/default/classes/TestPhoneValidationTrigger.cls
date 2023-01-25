@isTest
public with sharing class TestPhoneValidationTrigger {
   
    //Negative tests: records shouldn't be created
    @isTest
    static void testCreateNewPersonWithoutPhoneNumber(){


        Person__c person = new Person__c(Name = 'FirstName LastName', First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = 'cejicsasa17@gmail.com');

        Test.startTest();

        insert person;

        Test.stopTest();

        String personId = Id.valueOf(person.Id);

        List<Phone_Validation_Result__c> results = [SELECT Id FROM Phone_Validation_Result__c WHERE Person__r.Id = :personId];

        System.assert(results.size() == 0);
    }

    @isTest
    static void testUpdatePersonWithoutPhoneNumber(){


        Person__c person = new Person__c(Name = 'FirstName LastName', First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = 'cejicsasa17@gmail.com');

        Test.startTest();

        insert person;

        person.First_Name__c = 'New Name';

        update person;

        Test.stopTest();

        String personId = Id.valueOf(person.Id);

        List<Phone_Validation_Result__c> results = [SELECT Id FROM Phone_Validation_Result__c WHERE Person__r.Id = :personId];

        System.assert(results.size() == 0);
    }

    @isTest
    static void testUpdatePersonWithOldPhoneNumber(){

        TestResponseData.generateSuccessfulResponse();

        Person__c person = new Person__c(Name = 'FirstName LastName', First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = 'cejicsasa17@gmail.com');
        person.Phone__c = '+381645063016';

        Test.startTest();

        insert person;

        person.First_Name__c = 'New Name';

        update person;

        Test.stopTest();

        String personId = Id.valueOf(person.Id);

        List<Phone_Validation_Result__c> results = [SELECT Id FROM Phone_Validation_Result__c WHERE Person__r.Id = :personId];

        System.assert(!(results.size() > 1));
    }

    //Positive tests: records should be created
    @isTest
    static void testCreateNewPersonWithPhoneNumber(){

        TestResponseData.generateSuccessfulResponse();


        Person__c person = new Person__c(Name = 'FirstName LastName', First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = 'cejicsasa17@gmail.com');
        person.Phone__c = '+381645063016';

        Test.startTest();

        insert person;

        Test.stopTest();

        String personId = Id.valueOf(person.Id);

        List<Phone_Validation_Result__c> results = [SELECT Id FROM Phone_Validation_Result__c WHERE Person__r.Id = :personId];

        System.assert(results.size() > 0);
    }

    @isTest
    static void testUpdatePersonWithNewPhoneNumber(){

        TestResponseData.generateSuccessfulResponse();


        Person__c person = new Person__c(Name = 'FirstName LastName', First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = 'cejicsasa17@gmail.com');
        person.Phone__c = '+381645063016';

        Test.startTest();

        insert person;

        PhoneValidationTriggerController.called = false;

        person.Phone__c = '+381643090207';
        update person;

        Test.stopTest();

        String personId = Id.valueOf(person.Id);

        List<Phone_Validation_Result__c> results = [SELECT Id FROM Phone_Validation_Result__c WHERE Person__r.Id = :personId];

        System.assert(results.size() == 2);
    }



}