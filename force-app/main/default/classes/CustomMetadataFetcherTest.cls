@isTest
public with sharing class CustomMetadataFetcherTest {
    @isTest
    static void getNumberValidationKey_shouldReturnValidKeyValue(){
        String expected = Number_Validation_API_Key__mdt.getInstance('Validation_Key').Key__c;
        Test.startTest();
        String actual = CustomMetadataFetcher.getNumberValidationKey();
        Test.stopTest();

        System.assertEquals(expected, actual);
    }
}