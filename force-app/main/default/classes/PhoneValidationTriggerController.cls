public with sharing class PhoneValidationTriggerController {
    
    public static boolean called = false;

    public static boolean canSendTheRequest(System.TriggerOperation operationType){
        if(!called){
            switch on operationType {
                when AFTER_INSERT{
    
                    Person__c processingPerson= (Person__c) Trigger.new[0];
    
                    if(String.isNotBlank(processingPerson.Phone__c)){
                        return true;
                    }
                    return false;
                    
                }
                when AFTER_UPDATE{
    
                    Person__c processingPerson = (Person__c) Trigger.new[0];
                    Person__c oldRecord = (Person__c) Trigger.oldMap.get(processingPerson.Id);
                    
                    if(String.isNotBlank(processingPerson.Phone__c) && processingPerson.Phone__c != oldRecord.Phone__c){
    
                        return true;
                    }
                
                    return false;
                
                }when else{
                    return false;
                } 
        
            }
        }
        return false;
    }

}