({
    init : function(component, event, helper) {

    },

    handleSuccess : function(component, event, helper){
        helper.showToast("Success!", "The record has been updated successfully.", "success", "dismissable");
        var recordId = component.get("v.recordId");

        helper.viewRecordDetailPage(component, event, recordId);
    },

    handleError : function(component, event, helper){
        helper.showToast("Error!", "Error occured while trying to update the record", "error", "dismissable");
    },

    closeModal : function(component, event, helper){
        component.find('overlayLib').notifyClose();
    }
})
