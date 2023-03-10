({
    changeShowRecordTypePanelValue : function(component, value) {

        component.set("v.showRecordTypePanel", value);

    },

    changeShowCreateModalValue : function(value){
        var closeCreateModal = $A.get("e.c:closeCreateModal");
        closeCreateModal.setParams({"showCreate": value});

        closeCreateModal.fire();
    },

    setSelectedRecordTypeId : function(component){
        
        var action = component.get("c.getRecordTypeIdByName");
        
        action.setParams({"name" : component.get("v.selectedRecordTypeName")});
        action.setCallback(this, function(response){
            
            component.set("v.selectedRecordTypeId", response.getReturnValue());
            
        });

        $A.enqueueAction(action);        

    },

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
