public with sharing class PersonDataService {
    
    public static List<Person__c> getData(String query, String searchTerm, Integer offset){
        return Database.query(query);
    }

}