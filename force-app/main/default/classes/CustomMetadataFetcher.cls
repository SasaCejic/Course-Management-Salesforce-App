public with sharing class CustomMetadataFetcher {
    @AuraEnabled(cacheable = true)
    public static String getNumberValidationKey(){
        String validationKey = Number_Validation_API_Key__mdt.getInstance('Validation_Key').Key__c;
        return validationKey;
    }
}