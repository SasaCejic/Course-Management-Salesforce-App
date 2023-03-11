public with sharing class PersonController {

    @AuraEnabled(cacheable = true)
    public static List<Person__c> searchPersons(String searchTerm, Integer offset, Integer limitValue){

        return PersonDataService.getData(searchTerm, offset, limitValue);

    }

    @AuraEnabled(cacheable = true)
    public static Id getRecordTypeIdByName(String name){
        return PersonDataService.getRecordTypeId(name);
    }

    @AuraEnabled(cacheable = true)
    public static List<String> getRecordTypeNames(){
        return PersonDataService.getRecordTypeNames();
    }

}