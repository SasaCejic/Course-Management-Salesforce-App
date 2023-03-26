import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import getNumberValidationKey from '@salesforce/apex/CustomMetadataFetcher.getNumberValidationKey';

export default class PhoneValidationComponent extends LightningElement {
    @api phoneFieldName;
    @api recordId;
    @wire(getRecord, {recordId: '$recordId', fields: '$fieldsToRetrieve'})
    person;
    title;
    fieldsToRetrieve;
    validatedPhones = [];
    fieldsToShow;
    @wire(getNumberValidationKey)
    numberValidationKey;

    connectedCallback(){
        this.title = `${this.phoneFieldName} Validation Component`;
        this.fieldsToRetrieve = [`Person__c.${this.phoneFieldName}`];
        this.fieldsToShow = [this.phoneFieldName];
    }


    get phoneValue(){
        return this.person.data ? getFieldValue(this.person.data.fields, this.fieldsToRetrieve[0])[this.phoneFieldName].value : 'no data';
    }

    get fieldVisible(){
        return this.person.data ? this.checkFieldVisibility(this.phoneFieldName) : false;
    }

    checkFieldVisibility(fieldName) {
        return (this.person.data.fields[fieldName] != undefined) ? true : false;
    }

    validate(){
        this.validatedPhones = (!this.validatedPhones.includes(this.phoneValue)) ? [...this.validatedPhones, this.phoneValue] : this.validatedPhones;
    }

}