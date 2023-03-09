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

    }

})
