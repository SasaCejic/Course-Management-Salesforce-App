@isTest
public with sharing class TestPhoneValidator {
    
    @isTest
    static void sendRequest_SuccessfullValidationResultCreated_IfValidPhoneNumberProvided(){
        Test.setMock(HttpCalloutMock.class, new ResponseHttpCalloutMock('{"Items":[{"PhoneNumber":"+381645063016","RequestProcessed":true,"IsValid":"Yes","NetworkCode":"03","NetworkName":"Telekom Srbija ad Beograd (mts)","NetworkCountry":"RS","NationalFormat":"064 5063016","CountryPrefix":381,"NumberType":"Mobile"}]}', 200)); 


        Person__c person = new Person__c(Name = 'FirstName LastName', First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = 'cejicsasa17@gmail.com');
        person.Phone__c = '+381645063016';

        Test.startTest();

        insert person; 

        Test.stopTest();

        String personId = Id.valueOf(person.Id);

        List<Phone_Validation_Result__c> results = [SELECT Id, Phone_Number__c, Request_Processed__c, Is_Valid__c, Network_Code__c, Network_Name__c, Network_Country__c, National_Format__c, Country_Prefix__c, Number_Type__c  FROM Phone_Validation_Result__c WHERE Person__r.Id = :personId];

        Phone_Validation_Result__c pvr = results[results.size() - 1];

        System.assert(pvr != null);
        System.assertEquals('+381645063016', pvr.Phone_Number__c);
        System.assertEquals(True, pvr.Request_Processed__c);
        System.assertEquals('Yes', pvr.Is_Valid__c);
        System.assertEquals('03', pvr.Network_Code__c);
        System.assertEquals('Telekom Srbija ad Beograd (mts)', pvr.Network_Name__c);
        System.assertEquals('RS', pvr.Network_Country__c);
        System.assertEquals('064 5063016', pvr.National_Format__c);
        System.assertEquals(381, pvr.Country_Prefix__c);
        System.assertEquals('Mobile', pvr.Number_Type__c);
    }


    @isTest
    static void sendRequest_ErrorValidationResultCreated_IfNoPhoneNumberProvided(){
        
        Test.setMock(HttpCalloutMock.class, new ResponseHttpCalloutMock('{"Items":[{"Error":"1001","Description":"Number Required","Cause":"The phone numbers is required.","Resolution":"Please ensure that you supply a phone number and try again."}]}', 200)); 

        Person__c person = new Person__c(Name = 'FirstName LastName', First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = 'cejicsasa17@gmail.com');
        insert person; 

        Test.startTest();

        PhoneValidator.sendRequest(Id.valueOf(person.Id));

        Test.stopTest();

        String personId = Id.valueOf(person.Id);

        List<Phone_Validation_Result__c> results = [SELECT Id, ErrorId__c, Error_Description__c, Error_Cause__c, Error_Resolution__c  FROM Phone_Validation_Result__c WHERE Person__r.Id = :personId];

        Phone_Validation_Result__c pvr = results[results.size() - 1];

        System.assert(pvr != null);
        System.assertEquals(1001, pvr.ErrorId__c);
        System.assertEquals('Number Required', pvr.Error_Description__c);
        System.assertEquals('The phone numbers is required.', pvr.Error_Cause__c);
        System.assertEquals('Please ensure that you supply a phone number and try again.', pvr.Error_Resolution__c);
    }

    @isTest
    static void sendRequest_InvalidResponseCodeValidationResultCreated_IfNoCode200Returned(){
        Test.setMock(HttpCalloutMock.class, new ResponseHttpCalloutMock('invalid response code', 500)); 

        Test.startTest();

        Person__c person = new Person__c(Name = 'FirstName LastName', First_Name__c = 'FirstName', Last_Name__c = 'LastName', Email__c = 'cejicsasa17@gmail.com');
        insert person; 

        PhoneValidator.sendRequest(Id.valueOf(person.Id));

        Test.stopTest();

        String personId = Id.valueOf(person.Id);

        Phone_Validation_Result__c pvr = [SELECT Id, Wrong_Response_Code_Body__c  FROM Phone_Validation_Result__c WHERE Person__r.Id = :personId LIMIT 1];

        System.assertEquals('invalid response code', pvr.Wrong_Response_Code_Body__c);
    }


}

