public with sharing class PersonTableController {

    public String recordType {get; set;}


    public PersonTableController(){

        String successMessage = System.currentPagereference().getParameters().get('message');

        if(String.isNotBlank(successMessage)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, successMessage));
        }
    
    }
    
    public List<Person__c> getPersons(){
        return [SELECT Name, Record_Type_Name__c, Phone__c, Email__c FROM Person__c];
    }

    public PageReference createTutor(){
        this.recordType = 'Tutor';
        return PersonHelper.redirect('/apex/vfCreatePerson?recordType=' + this.recordType);
    }

    public PageReference createStudent(){
        this.recordType = 'Student';
        return PersonHelper.redirect('/apex/vfCreatePerson?recordType=' + this.recordType);
    }

}