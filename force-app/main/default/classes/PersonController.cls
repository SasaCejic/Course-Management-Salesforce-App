public with sharing class PersonController {

    @AuraEnabled(cacheable = true)
    public static List<Person__c> searchPersons(String searchTerm, Integer offset){
    
        searchTerm = (String.isBlank(searchTerm)) ? '' : searchTerm.trim();
        offset = (offset == null) ? 0 : Integer.valueOf(offset);

        String query = '';

        if (searchTerm == '') {
            query = 'SELECT Name, Record_Type_Name__c, Phone__c, Email__c FROM Person__c WITH SECURITY_ENFORCED ORDER BY Name LIMIT 10 OFFSET :offset';
        }else{

            searchTerm = '%' + searchTerm + '%';


            query = 'SELECT Name, Record_Type_Name__c, Phone__c, Email__c FROM Person__c WHERE Name LIKE :searchTerm OR Phone__c LIKE :searchTerm OR Email__c LIKE :searchTerm WITH SECURITY_ENFORCED ORDER BY Name LIMIT 10 OFFSET :offset';

        }

        
        return PersonDataService.getData(query, searchTerm, offset);

    }

}