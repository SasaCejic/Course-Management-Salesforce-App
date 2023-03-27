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
    phoneValue;

    connectedCallback(){
        this.title = `${this.phoneFieldName} Validation Component`;
        this.fieldsToRetrieve = [`Person__c.${this.phoneFieldName}`];
        this.fieldsToShow = [this.phoneFieldName];
    }


    get phoneValue(){
        if(!this.recordId){
            return this.template.querySelector("lightning-input").value;
        }
        return this.person.data ? getFieldValue(this.person.data.fields, this.fieldsToRetrieve[0])[this.phoneFieldName].value : '';
    }

    get fieldVisible(){
        return this.person.data ? this.checkFieldVisibility(this.phoneFieldName) : false;
    }

    checkFieldVisibility(fieldName) {
        return (this.person.data.fields[fieldName] != undefined) ? true : false;
    }

    validate(){
        let result = true;
        if(!this.recordId){
            this.phoneValue = this.template.querySelector("lightning-input").value;
            let pattern = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/im;
            result = pattern.test(this.phoneValue);
        }else{
            this.phoneValue = this.person.data ? getFieldValue(this.person.data.fields, this.fieldsToRetrieve[0])[this.phoneFieldName].value : '';
        }
        this.validatedPhones = (!this.validatedPhones.includes(this.phoneValue) && result) ? [...this.validatedPhones, this.phoneValue] : this.validatedPhones;
    }

}