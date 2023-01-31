trigger PhoneValidationTrigger on Person__c (after insert, after update) {

    PhoneValidationTriggerHelper.validate(Trigger.operationType);

}