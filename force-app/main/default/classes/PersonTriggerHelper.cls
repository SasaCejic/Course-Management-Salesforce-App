public with sharing class PersonTriggerHelper {
    
    public static boolean called = false;

    public static void validate(System.TriggerOperation operationType){
        if(!called){
            switch on operationType {
                when AFTER_INSERT{
    
                    Person__c processingPerson= (Person__c) Trigger.new[0];
    
                    if(String.isNotBlank(processingPerson.Phone__c)){

                        PhoneValidator.sendRequest(processingPerson.Id, processingPerson.Name, processingPerson.Phone__c, 'Phone__c', processingPerson.Country__c);

                    }
                    
                    if(String.isNotBlank(processingPerson.Work_Phone__c)){
                        
                        PhoneValidator.sendRequest(processingPerson.Id, processingPerson.Name, processingPerson.Work_Phone__c, 'Work_Phone__c', processingPerson.Country__c);

                    }

                    called = true;

                    
                }when AFTER_UPDATE{
    
                    Person__c processingPerson = (Person__c) Trigger.new[0];
                    Person__c oldRecord = (Person__c) Trigger.oldMap.get(processingPerson.Id);
                    
                    if((String.isNotBlank(processingPerson.Phone__c) && processingPerson.Phone__c != oldRecord.Phone__c)){
                        
                        PhoneValidator.sendRequest(processingPerson.Id, processingPerson.Name, processingPerson.Phone__c, 'Phone__c', processingPerson.Country__c);

                    }
                    
                    if(String.isNotBlank(processingPerson.Work_Phone__c) && processingPerson.Work_Phone__c != oldRecord.Work_Phone__c){
    
                        PhoneValidator.sendRequest(processingPerson.Id, processingPerson.Name, processingPerson.Work_Phone__c, 'Work_Phone__c', processingPerson.Country__c);
                        
                    }

                    called = true;
                
                }when BEFORE_INSERT{

                    Person__c person = (Person__c) Trigger.new[0];
                    person.Name = String.format('{0} {1}', new List<String>{person.First_Name__c, person.Last_Name__c});
                    person.Created__c = true;


                }when else{
                    called = true;
                } 
        
            }
        }
    }

}