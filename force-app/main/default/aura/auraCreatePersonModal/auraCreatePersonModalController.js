({
    closeModal : function(component, event, helper){
        component.find('overlayLib').notifyClose();
    },

    handleError : function(component, event, helper){
        helper.showToast("Error!", "Error occured while trying to create the record", "error", "dismissable");
    },

    handleSuccess : function(component, event, helper){
        helper.showToast("Success!", "The record has been created successfully.", "success", "dismissable");

        helper.viewRecordDetailPage(component, event);
    },

    onSubmitHandler : function(component, event, helper){
        helper.addPhoneNumberPrefix(component, event, "+381");
    }
})
