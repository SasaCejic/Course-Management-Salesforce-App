import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import PERSON_NAME_FIELD from '@salesforce/schema/Person__c.Name';

export default class PersonDetailView extends LightningElement {
    @api recordId;
    @wire(getRecord, {recordId: '$recordId', fields: [PERSON_NAME_FIELD]})
    person; 

    get name(){
        return getFieldValue(this.person.data, PERSON_NAME_FIELD);
    }
}