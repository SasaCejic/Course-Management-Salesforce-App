import { LightningElement, wire, track } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import PERSON_NAME_FIELD from '@salesforce/schema/Person__c.Name';
import PERSON_RECORD_TYPE_FIELD from '@salesforce/schema/Person__c.Record_Type_Name__c';
import PERSON_PHONE_FIELD from '@salesforce/schema/Person__c.Phone__c';
import PERSON_EMAIL_FIELD from '@salesforce/schema/Person__c.Email__c';
import searchPersons from '@salesforce/apex/PersonController.searchPersons';
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
    @track showModal;
    @track createScreen;
    editRecordId;
    editRecordName;

    @track error;

    searchTerm = '';

    @wire(searchPersons, {searchTerm: '$searchTerm'})
	persons;

    handleSearchTermChange(event) {
		
		window.clearTimeout(this.delayTimeout);
		const searchTerm = event.target.value;
		
		this.delayTimeout = setTimeout(() => {
			this.searchTerm = searchTerm;
		}, 300);
	}
	get hasResults() {
        if(this.persons.data && this.persons.data.length > 0){
            return true;
        }
        return false;
	}

    handleCloseModal(event){
        this.showModal = event.detail;
    }

    handleErrorMessage(event){
        this.showEditErrorMessage(event);
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'edit':
                this.showEditRecordModal(row);
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

    showEditRecordModal(row){
        this.editRecordId = row.Id;
        this.editRecordName = row.Name;
        this.showModal = true;
    }

    hideModalBox(){
        this.showModal = false;
    }

    showEditErrorMessage(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: 'Record cannot be edited',
                variant: 'error',
                mode: 'dismissable'
            })
        );
    }

    handleSendHandleSuccess(event){
        this.editRecordId = event.detail;
        this.handleSuccess(event);
    }

    handleSuccess(event){
        this.hideModalBox();
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Record ' + this.editRecordName + ' was updated',
                variant: 'success',
                mode: 'dismissable'
            })
        );
        this[NavigationMixin.Navigate]({
            type:'standard__recordPage',
            attributes:{
                recordId: this.editRecordId,
                objectApiName: 'c__Person',
                actionName: 'view'
            }
        });
       
    }

    showCreateScreen(){
        this.createScreen = true;
    }

    handleCloseCreateScreen(event){
        this.createScreen = false;
    }

    handleCreateErrorMessage(event){
        this.showCreateErrorMessage(event);
    }

    handleSuccessCreate(event){
        this.handleCloseCreateScreen(event);
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Record \'' + event.detail.recordName +'\' has been created',
                variant: 'success',
                mode: 'dismissable'
            })
        );
        console.log('Event detail: ' + event.detail);
        this[NavigationMixin.Navigate]({
            type:'standard__recordPage',
            attributes:{
                recordId: event.detail.recordId,
                objectApiName: 'c__Person',
                actionName: 'view'
            }
        });
    }

    showCreateErrorMessage(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: 'Record cannot be created',
                variant: 'error',
                mode: 'dismissable'
            })
        );
    }
    
}