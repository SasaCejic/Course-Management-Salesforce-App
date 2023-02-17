import { LightningElement, wire, track } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import PERSON_NAME_FIELD from '@salesforce/schema/Person__c.Name';
import PERSON_RECORD_TYPE_FIELD from '@salesforce/schema/Person__c.Record_Type_Name__c';
import PERSON_PHONE_FIELD from '@salesforce/schema/Person__c.Phone__c';
import PERSON_EMAIL_FIELD from '@salesforce/schema/Person__c.Email__c';
import getPersons from '@salesforce/apex/PersonController.getPersons';

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
                //TODO: call function for record deletion
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

    
    
}