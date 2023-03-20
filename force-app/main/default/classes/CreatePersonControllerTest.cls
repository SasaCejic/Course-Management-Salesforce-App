@isTest
public with sharing class CreatePersonControllerTest {
    
    @isTest
    static void cancel_shouldRedirectToPersonTablePage(){
        Pagereference expected = new Pagereference('/apex/vfPersonTable');

        Test.startTest();

        Person__c p = new Person__c();

        CreatePersonController cpc = new CreatePersonController(new ApexPages.StandardController(p));
        PageReference actual = cpc.cancel();

        Test.stopTest();

        System.assertEquals(expected.getUrl(), actual.getUrl());
    }

    @isTest
    static void save_shouldAddErrorMessage_ifFieldsAreNotValid(){

        Test.startTest();

        Person__c person = new Person__c(Name = 'name', First_Name__c = 'firstName', Last_Name__c = 'lastName',Email__c = 'lskjskj', Phone__c = '5857463');

        CreatePersonController cpc = new CreatePersonController(new ApexPages.StandardController(person));
        PageReference actual = cpc.save();

        Test.stopTest();

        System.assert(ApexPages.hasMessages());
    }


    @isTest
    static void save_shouldAddErrorMessage_ifRecordCannotBeInsertedSuccessfully(){

        Test.startTest();

        Person__c person = new Person__c();
        CreatePersonController cpc = new CreatePersonController(new ApexPages.StandardController(person));
        PageReference actual = cpc.save();

        Test.stopTest();

        System.assert(ApexPages.hasMessages());
    }


}