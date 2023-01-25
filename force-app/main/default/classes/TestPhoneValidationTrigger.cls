@isTest
public with sharing class TestPhoneValidationTrigger {
   
    //Negative tests: records shouldn't be created
    @isTest
    static void insertPerson_NoValidationRecordCreated_IfPhoneFieldIsMissing(){


        Person__c person = new Person__c(Name = 'FirstName LastName', First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = 'cejicsasa17@gmail.com');

        Test.startTest();

        insert person;

        Test.stopTest();

        String personId = String.valueOf(person.Id);

        List<Phone_Validation_Result__c> results = [SELECT Id FROM Phone_Validation_Result__c WHERE Person__r.Id = :personId];

        System.assert(results.size() == 0);
    }

    @isTest
    static void updatePerson_NoValidationRecordCreated_IfPhoneFieldIsMissing(){


        Person__c person = new Person__c(Name = 'FirstName LastName', First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = 'cejicsasa17@gmail.com');

        Test.startTest();

        insert person;

        PhoneValidationTriggerController.called = false;

        String personId = String.valueOf(person.Id);

        List<Phone_Validation_Result__c> results = [SELECT Id FROM Phone_Validation_Result__c WHERE Person__r.Id = :personId];

        System.assert(results.size() == 0);

        person.First_Name__c = 'New Name';

        update person;

        Test.stopTest();


        results = [SELECT Id FROM Phone_Validation_Result__c WHERE Person__r.Id = :personId];

        System.assert(results.size() == 0);
    }

    @isTest
    static void updatePerson_OneValidationRecordCreated_IfNumberIsNotUpdated(){

        TestResponseData.generateSuccessfulResponse();

        Person__c person = new Person__c(Name = 'FirstName LastName', First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = 'cejicsasa17@gmail.com');
        person.Phone__c = '+381645063016';

        Test.startTest();

        insert person;

        PhoneValidationTriggerController.called = false;


        person.First_Name__c = 'New Name';

        update person;

        Test.stopTest();

        String personId = String.valueOf(person.Id);

        List<Phone_Validation_Result__c> results = [SELECT Id FROM Phone_Validation_Result__c WHERE Person__r.Id = :personId];

        System.assert(results.size() == 1);
    }

    //Positive tests: records should be created
    @isTest
    static void insertPerson_OneValidationRecordCreated_IfPhoneNumberProvided(){

        TestResponseData.generateSuccessfulResponse();


        Person__c person = new Person__c(Name = 'FirstName LastName', First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = 'cejicsasa17@gmail.com');
        person.Phone__c = '+381645063016';

        Test.startTest();

        insert person;

        Test.stopTest();

        String personId = Id.valueOf(person.Id);

        List<Phone_Validation_Result__c> results = [SELECT Id FROM Phone_Validation_Result__c WHERE Person__r.Id = :personId];

        System.assert(results.size() == 1);
    }

    @isTest
    static void updatePerson_TwoValidationRecordsCreated_IfNumberIsUpdated(){

        TestResponseData.generateSuccessfulResponse();


        Person__c person = new Person__c(Name = 'FirstName LastName', First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = 'cejicsasa17@gmail.com');
        person.Phone__c = '+381645063016';

        Test.startTest();

        insert person;

        PhoneValidationTriggerController.called = false;


        person.Phone__c = '+381643090207';
        
        update person;

        Test.stopTest();

        String personId = String.valueOf(person.Id);

        List<Phone_Validation_Result__c> results = [SELECT Id FROM Phone_Validation_Result__c WHERE Person__r.Id = :personId];
        
        System.assert(results.size() == 2);
    }


    @isTest
    static void validateRecord_ReturnsFalse_IfYouAlreadyInsertedPersonInTheSameTransactionAndTryToInsertAgain(){

        TestResponseData.generateSuccessfulResponse();


        Person__c person = new Person__c(Name = 'FirstName LastName', First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = 'cejicsasa17@gmail.com');
        person.Phone__c = '+381645063016';

        Test.startTest();

        insert person;

        Test.stopTest();
        
        System.assert(!PhoneValidationTriggerController.validateRecord(person));
    }

    @isTest
    static void validateRecord_ReturnsFalse_IfYouAlreadyInsertedPersonInTheSameTransactionAndTrytoUpdate(){

        TestResponseData.generateSuccessfulResponse();


        Person__c person = new Person__c(Name = 'FirstName LastName', First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = 'cejicsasa17@gmail.com');
        person.Phone__c = '+381645063016';

        Test.startTest();

        insert person;

        Person__c person1 = person;

        person.First_Name__c = 'New Name';

        Test.stopTest();
        
        System.assert(!PhoneValidationTriggerController.validateRecord(person1,person));
    }



}