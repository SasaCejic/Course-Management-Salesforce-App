
({

    init : function(component, event, helper) {

        var actions = [
            { label: 'Edit', name: 'edit' }
        ];

        var fields = [{ label: 'Name', fieldName: "Name", sortable: true,
                        type: 'button', typeAttributes: {label: { fieldName: 'Name' }, name : 'urlredirect', variant: 'base' }},
                        { label: 'Record Type Name', fieldName: "Record_Type_Name__c", type: 'text', sortable: true },
                        { label: 'Phone', fieldName: "Phone__c", type: 'text', sortable: true },
                        { label: 'Email', fieldName: "Email__c", type: 'text', sortable: true },
                        {
                            type: 'action',
                            typeAttributes: { rowActions: actions },
                        }];

    helper.initializeActionsAndComponents(component, fields);

    },

    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');

        switch (action.name) {
            case 'edit':
                helper.createComponent(cmp, event, "c:auraEditPerson", {recordId: row.Id, personName: row.Name});
                break;
            case 'urlredirect':
                var recordId = row.Id;
                helper.viewRecordDetailPage(cmp, event, recordId);
                break;
            default:
        }
    },

    createNewPerson : function(component, event, helper){

        

        var action = component.get("c.getRecordTypeNames");
        
        action.setCallback(this, function(response){

            var recordTypes = response.getReturnValue();
            
            var options = [];

            for(var rt in recordTypes){

                options.push({"label" : recordTypes[rt], "value" : recordTypes[rt]});

            }

            helper.createComponent(component, event, "c:auraRecordTypesModal", {options : options});
            
        });

        $A.enqueueAction(action);
       
        

    }

})
