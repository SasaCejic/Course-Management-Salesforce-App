public with sharing class EditPersonController {

    public ApexPages.StandardController stdCtrl {get; set;}

    public Map<String, Object> fields {get; set;}

    public Set<String> keys {get; set;}

    public Person__c person {get; set;}


    public EditPersonController(ApexPages.StandardController stdCtrl) {
        this.stdCtrl = stdCtrl;

        this.fields = PersonHelper.initializeFields(this.stdCtrl.getId());

        this.keys = this.fields.keySet();

        this.person = PersonHelper.initializePerson(this.fields, this.stdCtrl.getId());

        this.fields = PersonHelper.populateFieldValues(this.fields, this.person);

    }

    public PageReference cancel(){
        return PersonHelper.redirect('/apex/vfPersonTable');
    }

    
    

    public PageReference save(){

        this.fields = PersonHelper.setFieldTypes(this.fields);

        ApexPages.Message errorMessage = PersonHelper.validateFields(this.fields);

        if(errorMessage == null){

            this.fields = PersonHelper.addPhoneNumberPrefix('+381 ', this.fields, this.person);


            errorMessage = PersonHelper.updatePerson(this.fields, this.person);

            if(errorMessage == null){

                String succcessMessage = 'Record ' + this.person.First_Name__c + ' ' + this.person.Last_Name__c + ' has beed updated successfully';
                return PersonHelper.redirect('/apex/vfPersonDetailView?id=' + stdCtrl.getId() + '&message=' + succcessMessage);
            }else{
                ApexPages.addMessage(errorMessage);
            }

        }else{
            ApexPages.addMessage(errorMessage);
        }

        return null;

    }

}