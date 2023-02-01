trigger PersonNameAndCreatedCheckboxTrigger on Person__c (before insert) {

    
    for(Person__c person : Trigger.new){
        //Set Person Name
        person.Name = String.format('{0} {1}', new List<String>{person.First_Name__c, person.Last_Name__c});

        //Check the Created checkbox
        person.Created__c = true;

    }

}