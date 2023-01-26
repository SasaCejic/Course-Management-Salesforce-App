trigger PhoneValidationTrigger on Person__c (after insert, after update) {

    if(PhoneValidationTriggerController.canSendTheRequest(Trigger.operationType)){
        PhoneValidator.sendRequest(String.valueOf(Trigger.new[0].Id));
    }

}