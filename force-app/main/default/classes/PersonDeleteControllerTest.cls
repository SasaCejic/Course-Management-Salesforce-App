@isTest
public with sharing class PersonDeleteControllerTest {


    @isTest
    static void cancel_shouldRedirectToPersonTablePage(){
        Pagereference expected = new Pagereference('/apex/vfPersonTable');

        Test.startTest();

        Person__c p = new Person__c();

        PersonDeleteController pdc = new PersonDeleteController(new ApexPages.StandardController(p));
        PageReference actual = pdc.cancel();

        Test.stopTest();

        System.assertEquals(expected.getUrl(), actual.getUrl());
    }

    @isTest
    static void deletePerson_shouldRedirectToPersonTablePage_ifPersonIsDeletedSuccessfully(){
        Pagereference expected = new Pagereference('/apex/vfPersonTable?message=Record has been deleted successfully');

        Test.startTest();

        Person__c p = new Person__c(Name = 'Person Name', First_Name__c = 'Person FirstName', Last_Name__c = 'Person LastName', Email__c = 'personmail@gmail.com');
        insert p;

        PersonDeleteController pdc = new PersonDeleteController(new ApexPages.StandardController(p));
        PageReference actual = pdc.deletePerson();

        Test.stopTest();

        System.assertEquals(expected.getUrl(), actual.getUrl());
    }

    @isTest
    static void deletePerson_shouldAddErrorMessage_ifPersonCannotBeDeleted(){
        

        Test.startTest();

        Person__c p = new Person__c();

        PersonDeleteController pdc = new PersonDeleteController(new ApexPages.StandardController(p));
        PageReference pr = pdc.deletePerson();

        Test.stopTest();

        System.assert(ApexPages.hasMessages());
    }

}