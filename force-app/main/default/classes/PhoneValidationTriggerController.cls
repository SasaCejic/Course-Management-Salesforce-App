public with sharing class PhoneValidationTriggerController {
    
    public static boolean called = false;

    public static boolean validateRecord(Person__c processingPerson){

        if(called){
            return false;
        }
        called = true;

        if(processingPerson.Phone__c != NULL && String.isNotBlank(processingPerson.Phone__c)){
            return true;
        }
        return false;
    }

    public static boolean validateRecord(Person__c processingPerson, Person__c oldRecord){

    if(called){
        return false;
    }

    called = true;
    
    if((processingPerson.Phone__c != NULL && String.isNotBlank(processingPerson.Phone__c) && processingPerson.Phone__c != oldRecord.Phone__c)){

        return true;
    }

    return false;

    }

}