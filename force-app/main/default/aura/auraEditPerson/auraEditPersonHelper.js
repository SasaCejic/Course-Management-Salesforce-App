({

    initializeParameters : function(component, selectedRecordId, selectedRecordName){

        component.set('v.recordId', selectedRecordId);
        component.set('v.personName', selectedRecordName);

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

    changeShowModalValue : function(value){
        var showModalValue = $A.get("e.c:closeEditModal");
        showModalValue.setParams({"showEdit": value});

        showModalValue.fire();
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
