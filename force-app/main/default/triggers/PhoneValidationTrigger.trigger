trigger PhoneValidationTrigger on Person__c (after insert, after update) {

    
    Person__c processingPerson = Trigger.new[0];
    
    if((Trigger.isInsert && processingPerson.Phone__c != NULL) || (Trigger.isUpdate && processingPerson.Phone__c != NULL && processingPerson.Phone__c != Trigger.oldMap.get(processingPerson.Id).Phone__c)){

        PhoneValidator.sendRequest(Id.valueOf(processingPerson.Id));
    }
    

}