trigger PhoneValidationTrigger on Person__c (after insert, after update) {

    if(Trigger.isInsert && PhoneValidationTriggerController.validateRecord(Trigger.new[0])){

        PhoneValidator.sendRequest(String.valueOf(Trigger.new[0].Id));

    }else if(Trigger.isUpdate && PhoneValidationTriggerController.validateRecord(Trigger.new[0], Trigger.oldMap.get(Trigger.new[0].Id))){

        PhoneValidator.sendRequest(String.valueOf(Trigger.new[0].Id));
    }
    

}