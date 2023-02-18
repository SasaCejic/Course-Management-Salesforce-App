import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import PERSON_RECORD_TYPE from '@salesforce/schema/Person__c.Record_Type_Name__c';
import PERSON_NAME_FIELD from '@salesforce/schema/Person__c.Name';

export default class PersonDetailView extends LightningElement {
    @api recordId;
    @wire(getRecord, {recordId: '$recordId', fields: [PERSON_RECORD_TYPE, PERSON_NAME_FIELD]})
    person; 

    get recordType(){
        return getFieldValue(this.person.data, PERSON_RECORD_TYPE);
    }

    get name(){
        return getFieldValue(this.person.data, PERSON_NAME_FIELD);
    }
}