import { LightningElement, track, wire } from 'lwc';
import getStudentRecordTypeId from '@salesforce/apex/PersonController.getStudentRecordTypeId';
import getTutorRecordTypeId from '@salesforce/apex/PersonController.getTutorRecordTypeId';
//TODO Use https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.data_considerations to retrieve record type infos
export default class CreateScreen extends LightningElement {

    showRecordTypePanel = true;

    createdRecordName;

    @wire(getStudentRecordTypeId)
    getStudentRecordTypeId;

    @wire(getTutorRecordTypeId)
    getTutorRecordTypeId;

    @track recordTypeValue = 'Tutor';

    selectedRecordTypeId;


    get recordTypeOptions() {
        return [
            { label: 'Tutor', value: 'Tutor' },
            { label: 'Student', value: 'Student' },
        ];
    }

    changeRecordTypeValue(event){
        this.recordTypeValue = (this.recordTypeValue == 'Tutor') ? 'Student' : 'Tutor';
        this.selectedRecordTypeId = (this.recordTypeValue == 'Tutor') ? this.getTutorRecordTypeId : this.getStudentRecordTypeId;
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
            this.selectedRecordTypeId = this.getTutorRecordTypeId;
        }
    }

    onSubmitHandler(event){
        event.preventDefault();
    
        const fields = event.detail.fields;

        this.createdRecordName = fields.First_Name__c + ' ' + fields.Last_Name__c;

        if(fields.Phone__c != null){
            fields.Phone__c = '+381 ' + fields.Phone__c;
        }
        if(fields.Work_Phone__c != null){
            fields.Work_Phone__c = '+381 ' + fields.Work_Phone__c;
        }
    
    this.template
        .querySelector('lightning-record-form').submit(fields);
    }

}