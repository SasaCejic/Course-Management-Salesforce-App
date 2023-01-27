trigger PhoneValidationTrigger on Person__c (after insert, after update) {

    if(PhoneValidationTriggerController.canSendTheRequest(Trigger.operationType)){
        PhoneValidator.sendRequest(String.valueOf(Trigger.new[0].Id), String.valueOf(Trigger.new[0].Name), String.valueOf(Trigger.new[0].Phone__c), String.valueOf(Trigger.new[0].Work_Phone__c), String.valueOf(Trigger.new[0].Country__c));
    }

}