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
    static void updatePerson_TwoValidationRecordsCreated_IfNumberIsNotUpdated(){

        Test.setMock(HttpCalloutMock.class, new ResponseHttpCalloutMock('{"Items":[{"PhoneNumber":"+381645063016","RequestProcessed":true,"IsValid":"Yes","NetworkCode":"03","NetworkName":"Telekom Srbija ad Beograd (mts)","NetworkCountry":"RS","NationalFormat":"064 5063016","CountryPrefix":381,"NumberType":"Mobile"}]}', 200)); 

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

        System.assert(results.size() == 2);
    }

    //Positive tests: records should be created
    @isTest
    static void insertPerson_TwoValidationRecordCreated_IfPhoneNumberProvided(){

        Test.setMock(HttpCalloutMock.class, new ResponseHttpCalloutMock('{"Items":[{"PhoneNumber":"+381645063016","RequestProcessed":true,"IsValid":"Yes","NetworkCode":"03","NetworkName":"Telekom Srbija ad Beograd (mts)","NetworkCountry":"RS","NationalFormat":"064 5063016","CountryPrefix":381,"NumberType":"Mobile"}]}', 200)); 


        Person__c person = new Person__c(Name = 'FirstName LastName', First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = 'cejicsasa17@gmail.com');
        person.Phone__c = '+381645063016';

        Test.startTest();

        insert person;

        Test.stopTest();

        String personId = String.valueOf(person.Id);

        List<Phone_Validation_Result__c> results = [SELECT Id FROM Phone_Validation_Result__c WHERE Person__r.Id = :personId];

        System.assert(results.size() == 2);
    }

    @isTest
    static void updatePerson_FourValidationRecordsCreated_IfNumberIsUpdated(){

        Test.setMock(HttpCalloutMock.class, new ResponseHttpCalloutMock('{"Items":[{"PhoneNumber":"+381645063016","RequestProcessed":true,"IsValid":"Yes","NetworkCode":"03","NetworkName":"Telekom Srbija ad Beograd (mts)","NetworkCountry":"RS","NationalFormat":"064 5063016","CountryPrefix":381,"NumberType":"Mobile"}]}', 200)); 


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
        
        System.assert(results.size() == 4);
    }


    @isTest
    static void canSendTheRequest_ReturnsFalse_IfYouAlreadyInsertedPersonInTheSameTransaction(){

        Test.setMock(HttpCalloutMock.class, new ResponseHttpCalloutMock('{"Items":[{"PhoneNumber":"+381645063016","RequestProcessed":true,"IsValid":"Yes","NetworkCode":"03","NetworkName":"Telekom Srbija ad Beograd (mts)","NetworkCountry":"RS","NationalFormat":"064 5063016","CountryPrefix":381,"NumberType":"Mobile"}]}', 200)); 


        Person__c person = new Person__c(Name = 'FirstName LastName', First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = 'cejicsasa17@gmail.com');
        person.Phone__c = '+381645063016';

        Test.startTest();

        insert person;

        Test.stopTest();
        
        System.assert(!PhoneValidationTriggerController.canSendTheRequest(Trigger.operationType));
    }

    @isTest
    static void canSendTheRequest_ReturnsFalse_IfTriggerOperationTypeIsDifferentThanAfterInsertOrAfterUpdate(){

        Test.startTest();

        boolean result = PhoneValidationTriggerController.canSendTheRequest(System.TriggerOperation.BEFORE_INSERT);

        Test.stopTest();
        
        System.assert(!result);
    }

}