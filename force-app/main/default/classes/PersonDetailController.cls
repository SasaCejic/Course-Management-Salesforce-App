public with sharing class PersonDetailController {

    public ApexPages.StandardController stdCtrl {get; set;}


    public PersonDetailController(ApexPages.StandardController stdCtrl) {

        this.stdCtrl = stdCtrl;

        String successMessage = System.currentPagereference().getParameters().get('message');

        if(String.isNotBlank(successMessage)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, successMessage));
        }

    }
}