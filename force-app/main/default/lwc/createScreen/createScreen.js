import { LightningElement, track, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import PERSON_OBJECT from '@salesforce/schema/Person__c';
//TODO Use https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.data_considerations to retrieve record type infos
export default class CreateScreen extends LightningElement {

    showRecordTypePanel = true;

    createdRecordName;


    tutorRecordTypeId;
    studentRecordTypeId;

    @track recordTypeValue = 'Tutor';

    selectedRecordTypeId;

    @wire(getObjectInfo, { objectApiName: PERSON_OBJECT })
    objectInfo;

    setRecordTypeIds() {

        const rtis = this.objectInfo.data.recordTypeInfos;

        this.tutorRecordTypeId = Object.keys(rtis).find(rti => rtis[rti].name === 'Tutor');

        this.studentRecordTypeId = Object.keys(rtis).find(rti => rtis[rti].name === 'Student');
    }

    connectedCallback(){
        this.setRecordTypeIds();
    }


    get recordTypeOptions() {
        return [
            { label: 'Tutor', value: 'Tutor' },
            { label: 'Student', value: 'Student' },
        ];
    }

    changeRecordTypeValue(event){
        this.recordTypeValue = (this.recordTypeValue == 'Tutor') ? 'Student' : 'Tutor';
        this.selectedRecordTypeId = (this.recordTypeValue == 'Tutor') ? this.tutorRecordTypeId : this.studentRecordTypeId;
    }



    sendCreateScreenValue(event){
        this.dispatchEvent(
            new CustomEvent('closecreatescreen')
        );
    }

    sendCreateErrorMessage(event){
        this.dispatchEvent(
            new CustomEvent('createerrormessage')
        );
    }

    sendCreateHandleSuccess(event){
        this.dispatchEvent(
            new CustomEvent('successcreate', {detail: {recordId : event.detail.id, recordName : this.createdRecordName}})
        );
    }

    hideRecordTypePanel(){
        this.showRecordTypePanel = false;

        if(typeof this.selectedRecordTypeId === 'undefined'){
            this.selectedRecordTypeId = this.tutorRecordTypeId;
        }
    }

    onSubmitHandler(event){
        event.preventDefault();
    
        const fields = event.detail.fields;

        this.createdRecordName = fields.First_Name__c + ' ' + fields.Last_Name__c;

        if(fields.Phone__c != null){
            fields.Phone__c = `+381 ${fields.Phone__c}`;
        }
        if(fields.Work_Phone__c != null){
            fields.Work_Phone__c = `+381 ${fields.Work_Phone__c}`;
        }
    
    this.template
        .querySelector('lightning-record-form').submit(fields);
    }

}