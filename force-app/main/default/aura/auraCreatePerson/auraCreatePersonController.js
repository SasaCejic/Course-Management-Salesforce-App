({
    init : function(component, event, helper) {
        
    },

    hideRecordTypePanel : function(component, event, helper){
        helper.setSelectedRecordTypeId(component);
        helper.changeShowRecordTypePanelValue(component, false);
    },

    closeModal : function(component, event, helper){
        helper.changeShowCreateModalValue(false);
    },

    handleError : function(component, event, helper){
        helper.showToast("Error!", "Error occured while trying to create the record", "error", "dismissable");
    },

    handleSuccess : function(component, event, helper){
        helper.showToast("Success!", "The record has been created successfully.", "success", "dismissable");

        helper.viewRecordDetailPage(component, event);
    }

})
