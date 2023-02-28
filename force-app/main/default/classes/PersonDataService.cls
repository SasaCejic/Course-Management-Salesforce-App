public with sharing class PersonDataService {
    
    public static List<Person__c> getData(String searchTerm, Integer offset){

        searchTerm = (String.isBlank(searchTerm)) ? '' : '%' + searchTerm.trim() + '%';
        offset = (offset == null) ? 0 : Integer.valueOf(offset);
        

        String whereClause = (searchTerm == '') ? '' : 'WHERE Name LIKE :searchTerm OR Phone__c LIKE :searchTerm OR Email__c LIKE :searchTerm';


        String query = 'SELECT Name, Record_Type_Name__c, Phone__c, Email__c FROM Person__c ' + whereClause + ' WITH SECURITY_ENFORCED ORDER BY Name LIMIT 10 OFFSET :offset';

        return Database.query(query);
    }

}