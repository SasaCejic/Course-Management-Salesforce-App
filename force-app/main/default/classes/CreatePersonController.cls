public with sharing class CreatePersonController {

    public ApexPages.StandardController stdCtrl {get; set;}

    public String recordType {get; set;}

    public Map<String, Object> fields {get; set;}

    public Set<String> keys {get; set;}


    public CreatePersonController(ApexPages.StandardController stdCtrl) {

        this.stdCtrl = stdCtrl;
        
        this.recordType = System.currentPagereference().getParameters().get('recordType');

        this.fields = PersonHelper.getFieldsByLayout(this.recordType);

        this.keys = this.fields.keySet();


    }

    public PageReference cancel(){
        return PersonHelper.redirect('/apex/vfPersonTable');
    }


    public PageReference save(){

        this.fields = PersonHelper.setFieldTypes(this.fields);

        ApexPages.Message errorMessage = PersonHelper.validateFields(this.fields);

        if(errorMessage == null){

            this.fields = PersonHelper.addPhoneNumberPrefix('+381 ', this.fields);

            Person__c person = PersonHelper.insertPerson(this.fields, this.recordType);

            if(person != null){

                String succcessMessage = 'Record ' + person.First_Name__c + ' ' + person.Last_Name__c + ' has beed created successfully';

                return PersonHelper.redirect('/apex/vfPersonDetailView?id=' + person.Id + '&message=' + succcessMessage);
            }else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error occured while trying to insert the record'));
            }
        }else{
            ApexPages.addMessage(errorMessage);
        }

        return null;
        
    }

}