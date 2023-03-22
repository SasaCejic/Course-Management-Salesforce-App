({
    init : function(component, event, helper) {
        var recordTypeId = component.get("v.pageReference").state.recordTypeId;
        component.set("v.selectedRecordTypeId", recordTypeId);
    },

    changePageReference : function(component, event, helper){
        var recordTypeId = component.get("v.pageReference").state.recordTypeId;
        component.set("v.selectedRecordTypeId", recordTypeId);
        $A.get('e.force:refreshView').fire();
    },

    refresh : function(component, event, helper){
        $A.get('e.force:refreshView').fire();
    }
})
