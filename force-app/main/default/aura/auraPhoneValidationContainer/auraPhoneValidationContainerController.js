({
    onRecordIdChange : function(component, event, helper) {
        var newRecordId = component.get("v.recordId");
    },

    checkPermission : function(component, event, helper){
        var action = component.get("c.hasPermission");
        action.setParams({"permission" : 'Access_Phone_Validation_Component'});
        action.setCallback(this, function(response){
            component.set("v.hasPermission", response.getReturnValue());
        });
        $A.enqueueAction(action);
    }
})
