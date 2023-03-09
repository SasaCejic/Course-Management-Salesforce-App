({
    init : function(component, event, helper) {

        var selectedRecord = event.getParam("selectedRecord");
        
        helper.initializeParameters(component, selectedRecord.Id, selectedRecord.Name);

    },

    handleSuccess : function(component, event, helper){
        helper.showToast("Success!", "The record has been updated successfully.", "success", "dismissable");
        var recordId = component.get("v.recordId");

        helper.viewRecordDetailPage(component, event, recordId);
    },

    handleError : function(component, event, helper){
        helper.showToast("Error!", "Error occured while trying to update the record", "error", "dismissable");
    },

    closeModal : function(component,event, helper){
        helper.changeShowModalValue(false);
    }
})
