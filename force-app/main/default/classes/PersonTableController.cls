public with sharing class PersonTableController {

    public boolean showCreateButtons {get; set;}
    public boolean showCreateForm {get; set;}
    public String selectedRecordType {get; set;}

    public PersonTableController(){
        this.showCreateButtons = true;
        this.showCreateForm = false;

    }
    
    public List<Person__c> getPersons(){
        return [SELECT Name, Record_Type_Name__c, Phone__c, Email__c FROM Person__c];
    }

    public void createTutor(){
        this.selectedRecordType = 'Tutor';
        this.showCreateButtons = false;
        this.showCreateForm = true;
    }

    public void createStudent(){
        this.selectedRecordType = 'Student';
        this.showCreateButtons = false;
        this.showCreateForm = true;
    }

    public void closeCreateForm(){
        this.showCreateForm = false;
        this.showCreateButtons = true;
    }

}