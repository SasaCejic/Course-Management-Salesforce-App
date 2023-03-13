({

    initializeActionsAndComponents : function(component, fields){

        component.set('v.columns', fields);

        
        var action = component.get("c.searchPersons");
        action.setParams({"searchTerm" : '', "offset" : 0, "limitValue": null});
        action.setCallback(this, function(response){
            component.set("v.data", response.getReturnValue());
        });

        $A.enqueueAction(action);
    },

    createComponent : function(component, event, componentName, attributes){
        
        var modalBody;
        $A.createComponent(componentName, attributes,
           function(content, status) {
               if (status === "SUCCESS") {
                   modalBody = content;
                   component.find('overlayLib').showCustomModal({
                       body: modalBody,
                       showCloseButton: true
                   })
               }
           });

    },

    viewRecordDetailPage : function(component, event, recordId){

        var navService = component.find("navService");

        var pageReference = {
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: 'Person__c',
                actionName: 'view'
            }
        };

        event.preventDefault();
        navService.navigate(pageReference);

    }
})
