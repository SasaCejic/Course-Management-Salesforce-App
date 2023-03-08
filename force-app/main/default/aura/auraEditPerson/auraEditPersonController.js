({
    init : function(component, event, helper) {

        var selectedRecord = event.getParam("selectedRecord");
        
        helper.initializeParameters(component, selectedRecord.Id, selectedRecord.Name);

    },

    handleSuccess : function(component, event, helper){
        helper.showToast("Success!", "The record has been updated successfully.", "success", "dismissable");
    },

    handleError : function(component, event, helper){
        helper.showToast("Error!", "Error occured while trying to update the record", "error", "dismissable");
    },

    closeModal : function(component,event, helper){
        helper.changeShowModalValue(false);
    }
})
