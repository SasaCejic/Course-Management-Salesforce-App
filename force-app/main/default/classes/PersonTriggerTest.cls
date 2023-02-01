@isTest
public with sharing class PersonTriggerTest {
   
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

        PersonTriggerHelper.called = false;

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

        Test.setMock(HttpCalloutMock.class, new ResponseHttpCalloutMock('{"Items":[{"PhoneNumber":"+381645063016","RequestProcessed":true,"IsValid":"Yes","NetworkCode":"03","NetworkName":"Telekom Srbija ad Beograd (mts)","NetworkCountry":"RS","NationalFormat":"064 5063016","CountryPrefix":381,"NumberType":"Mobile"}]}', 200)); 

        Person__c person = new Person__c(Name = 'FirstName LastName', First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = 'cejicsasa17@gmail.com');
        person.Phone__c = '+381645063016';

        Test.startTest();

        insert person;

        PersonTriggerHelper.called = false;


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

        Test.setMock(HttpCalloutMock.class, new ResponseHttpCalloutMock('{"Items":[{"PhoneNumber":"+381645063016","RequestProcessed":true,"IsValid":"Yes","NetworkCode":"03","NetworkName":"Telekom Srbija ad Beograd (mts)","NetworkCountry":"RS","NationalFormat":"064 5063016","CountryPrefix":381,"NumberType":"Mobile"}]}', 200)); 


        Person__c person = new Person__c(Name = 'FirstName LastName', First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = 'cejicsasa17@gmail.com');
        person.Phone__c = '+381645063016';

        Test.startTest();

        insert person;

        Test.stopTest();

        String personId = String.valueOf(person.Id);

        List<Phone_Validation_Result__c> results = [SELECT Id FROM Phone_Validation_Result__c WHERE Person__r.Id = :personId];

        System.assert(results.size() == 1);
    }

    @isTest
    static void updatePerson_TwoValidationRecordsCreated_IfNumberIsUpdated(){

        Test.setMock(HttpCalloutMock.class, new ResponseHttpCalloutMock('{"Items":[{"PhoneNumber":"+381645063016","RequestProcessed":true,"IsValid":"Yes","NetworkCode":"03","NetworkName":"Telekom Srbija ad Beograd (mts)","NetworkCountry":"RS","NationalFormat":"064 5063016","CountryPrefix":381,"NumberType":"Mobile"}]}', 200)); 


        Person__c person = new Person__c(Name = 'FirstName LastName', First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = 'cejicsasa17@gmail.com');
        person.Phone__c = '+381645063016';

        Test.startTest();

        insert person;

        PersonTriggerHelper.called = false;


        person.Phone__c = '+381643090207';
        
        update person;

        Test.stopTest();

        String personId = String.valueOf(person.Id);

        List<Phone_Validation_Result__c> results = [SELECT Id FROM Phone_Validation_Result__c WHERE Person__r.Id = :personId];
        
        System.assert(results.size() == 2);
    }


    @isTest
    static void updatePerson_TwoValidationRecordsCreated_IfWorkPhoneNumberIsUpdated(){

        Test.setMock(HttpCalloutMock.class, new ResponseHttpCalloutMock('{"Items":[{"PhoneNumber":"+381645063016","RequestProcessed":true,"IsValid":"Yes","NetworkCode":"03","NetworkName":"Telekom Srbija ad Beograd (mts)","NetworkCountry":"RS","NationalFormat":"064 5063016","CountryPrefix":381,"NumberType":"Mobile"}]}', 200)); 


        Person__c person = new Person__c(Name = 'FirstName LastName', First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = 'cejicsasa17@gmail.com');
        person.Work_Phone__c = '+381645063016';

        Test.startTest();

        insert person;

        PersonTriggerHelper.called = false;


        person.Work_Phone__c = '+381643090207';
        
        update person;

        Test.stopTest();

        String personId = String.valueOf(person.Id);

        List<Phone_Validation_Result__c> results = [SELECT Id FROM Phone_Validation_Result__c WHERE Person__r.Id = :personId];
        
        System.assert(results.size() == 2);
    }

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



    
    @isTest
    static void validate_DoesntSendTheRequest_IfTriggerOperationTypeIsDifferentThanAfterInsertOrAfterUpdateOrBeforeInsert(){

        Test.startTest();

        PersonTriggerHelper.validate(System.TriggerOperation.BEFORE_UPDATE);

        Test.stopTest();
        
        System.assert(PersonTriggerHelper.called);
    }

}