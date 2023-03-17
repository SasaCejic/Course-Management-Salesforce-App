public with sharing class PersonDeleteController {

    public ApexPages.StandardController stdCtrl {get; set;}

    public Person__c person {get; set;}


    public PersonDeleteController(ApexPages.StandardController stdCtrl) {

        this.stdCtrl = stdCtrl;

        this.person = (Person__c)this.stdCtrl.getRecord();

    }

    public PageReference cancel(){
        return PersonHelper.redirect('/apex/vfPersonTable');
    }

    public PageReference deletePerson(){
        
        ApexPages.Message errorMessage = PersonHelper.deletePerson(this.person);

        if(errorMessage == null){
            String successMessage = 'Record has been deleted successfully';
            return PersonHelper.redirect('/apex/vfPersonTable?message=' + successMessage);
        }else{
            ApexPages.addMessage(errorMessage);
        }

        return null;

    }
}