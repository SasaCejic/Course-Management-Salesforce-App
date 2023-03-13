({
    showToast : function(title, message, variant, mode) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "variant": variant,
            "mode": mode
        });
        toastEvent.fire();
    },

    viewRecordDetailPage : function(component, event){

        var navService = component.find("navService");

        var pageReference = {
            type: 'standard__recordPage',
            attributes: {
                recordId: event.getParam("id"),
                objectApiName: 'Person__c',
                actionName: 'view'
            }
        };

        event.preventDefault();
        navService.navigate(pageReference);

    },

    addPhoneNumberPrefix : function(component, event, prefix){

        event.preventDefault();

        var fields = event.getParam("fields");

        if(fields["Phone__c"] != null){
            fields["Phone__c"] = prefix + " " + fields["Phone__c"];
        }

        if(fields["Work_Phone__c"] != null){
            fields["Work_Phone__c"] = prefix + " " + fields["Work_Phone__c"];
        }

        component.find("myRecordCreateForm").submit(fields);

        
    }
})
