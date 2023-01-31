trigger PersonTrigger on Person__c (after insert, after update, before insert) {

    PersonTriggerHelper.validate(Trigger.operationType);

}