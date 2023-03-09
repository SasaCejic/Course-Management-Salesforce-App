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

    editPerson : function(cmp, row) {
        cmp.set('v.showEdit', true);
        

        var editEvent = $A.get("e.c:editEvent");
        editEvent.setParams({"selectedRecord": row});

        editEvent.fire();

    },

    changeShowEditValue : function(component, value){
        component.set('v.showEdit', value);
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
