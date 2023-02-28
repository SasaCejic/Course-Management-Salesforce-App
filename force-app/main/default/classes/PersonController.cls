public with sharing class PersonController {

    @AuraEnabled(cacheable = true)
    public static List<Person__c> searchPersons(String searchTerm, Integer offset){

        return PersonDataService.getData(searchTerm, offset);

    }

}