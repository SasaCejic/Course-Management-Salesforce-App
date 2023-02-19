import { LightningElement, wire, track } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import PERSON_NAME_FIELD from '@salesforce/schema/Person__c.Name';
import PERSON_RECORD_TYPE_FIELD from '@salesforce/schema/Person__c.Record_Type_Name__c';
import PERSON_PHONE_FIELD from '@salesforce/schema/Person__c.Phone__c';
import PERSON_EMAIL_FIELD from '@salesforce/schema/Person__c.Email__c';
import getPersons from '@salesforce/apex/PersonController.getPersons';
import LightningConfirm from 'lightning/confirm';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

const actions = [
    { label: 'Edit', name: 'edit' },
    { label: 'Delete', name: 'delete' }
];

const COLUMNS = [
    { label: 'Name', fieldName: PERSON_NAME_FIELD.fieldApiName,
     type: 'button', typeAttributes: {label: { fieldName: 'Name' }, name : 'urlredirect', variant: 'base',
      sortable: true }},
    { label: 'Record Type Name', fieldName: PERSON_RECORD_TYPE_FIELD.fieldApiName, type: 'text' },
    { label: 'Phone', fieldName: PERSON_PHONE_FIELD.fieldApiName, type: 'text' },
    { label: 'Email', fieldName: PERSON_EMAIL_FIELD.fieldApiName, type: 'text' },
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    }
];


export default class PersonTable extends NavigationMixin (LightningElement) {
    record = {};
    columns = COLUMNS;

    @track error;

    @wire(getPersons)
    persons;

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'edit':
                console.log('Edit row');
                //TODO: call function for record edit
                break;
            case 'delete':
                this.handleConfirm(event, row);
                break;
            case 'urlredirect':
                this.showRowDetails(row);
                break;
            default:
        }
    }

    showRowDetails(row){
        this.record = row;
        this[NavigationMixin.Navigate]({
            type:'standard__recordPage',
            attributes:{
                recordId: this.record.Id,
                objectApiName: 'c__Person',
                actionName: 'view'
            }
        });
    }

    async handleConfirm(event,row) {
        const result = await LightningConfirm.open({
            message: 'Are you sure you want to delete \"' + row.Name + '\" record?',
            theme: 'info',
            label: 'Confirm your action',
        });
        if(result){
            this.delete(event, row);
        }
        
    }

    delete(event, row) {
        deleteRecord(row.Id)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Record ' + row.Id + ' deleted',
                        variant: 'success'
                    })
                );
                refreshApex(this.persons);

            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }

    
}