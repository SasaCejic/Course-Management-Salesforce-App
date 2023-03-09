
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
                helper.editPerson(cmp, row);
                break;
            case 'urlredirect':
                var recordId = row.Id;
                helper.viewRecordDetailPage(cmp, event, recordId);
                break;
            default:
        }
    },

    closeEdit : function(component, event, helper){
        var showEditValue = event.getParam("showEdit");
        helper.changeShowEditValue(component, showEditValue);
    },

    createNewPerson : function(component, event, helper){
        helper.changeShowCreateValue(component, true);
    },

    closeCreate : function(component, event, helper){
        helper.changeShowCreateValue(component, false);
    }
})
