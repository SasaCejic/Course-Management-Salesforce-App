({
    myAction : function(component, event, helper) {

    },

    closeModal : function(component, event, helper){
        component.find('overlayLib').notifyClose();
    },

    next : function(component, event, helper){

        var action = component.get("c.getRecordTypeIdByName");
    
        action.setParams({"name" : component.get("v.selectedRecordTypeName")});
        action.setCallback(this, function(response){
            
            var recordTypeId = response.getReturnValue();

            helper.createComponent(component, event, "c:auraCreatePersonModal", {selectedRecordTypeId : recordTypeId});
        });

        $A.enqueueAction(action);  



    }
})
