@isTest
public with sharing class PersonDetailControllerTest {
    

    @isTest
    static void PersonDetailController_shouldInitializeStandardController_ifStandardControllerPassed(){
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(new Person__c());

        Test.startTest();

        PersonDetailController pdc = new PersonDetailController(stdCtrl);

        Test.stopTest();

        System.assertEquals(stdCtrl, pdc.stdCtrl);
    }

}