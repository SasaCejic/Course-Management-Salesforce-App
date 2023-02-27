import { LightningElement, track, wire } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import PERSON_NAME_FIELD from '@salesforce/schema/Person__c.Name';
import PERSON_RECORD_TYPE_FIELD from '@salesforce/schema/Person__c.Record_Type_Name__c';
import PERSON_PHONE_FIELD from '@salesforce/schema/Person__c.Phone__c';
import PERSON_EMAIL_FIELD from '@salesforce/schema/Person__c.Email__c';
import searchPersons from '@salesforce/apex/PersonController.searchPersons';
import LightningConfirm from 'lightning/confirm';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const actions = [
    { label: 'Edit', name: 'edit' },
    { label: 'Delete', name: 'delete' }
];

const COLUMNS = [
    { label: 'Name', fieldName: PERSON_NAME_FIELD.fieldApiName, sortable: true,
     type: 'button', typeAttributes: {label: { fieldName: 'Name' }, name : 'urlredirect', variant: 'base' }},
    { label: 'Record Type Name', fieldName: PERSON_RECORD_TYPE_FIELD.fieldApiName, type: 'text', sortable: true },
    { label: 'Phone', fieldName: PERSON_PHONE_FIELD.fieldApiName, type: 'text', sortable: true },
    { label: 'Email', fieldName: PERSON_EMAIL_FIELD.fieldApiName, type: 'text', sortable: true },
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

    persons = [];

    searchTerm = '';

    recordSize = 0;

    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;

    
    isLoading = true;
    infiniteLoading = true;


    @wire(searchPersons, {searchTerm: '$searchTerm',  offset: '$recordSize'})
    wiredPerson({data, error}){
        
        if(data){

            if(data.length > 0){
                if(this.recordSize > 0){
                    this.persons = [...this.persons, ...data];
                }else{
                    this.persons = data;
                }
            }else{
                this.infiniteLoading = false;
                
            }
            this.isLoading = false;
        }else if(error){
            this.error = error;

            this.toast('Error loading person records', this.error.body.message, 'error', 'dismissable');
        }
    }
    
    loadMore(){

        this.isLoading = true;
        this.recordSize += 10;
       
    }

    resetData(){
        this.persons = [];
        this.recordSize = 0;
        this.isLoading = true;
        this.infiniteLoading = true;
    }
   

    handleSearchTermChange(event) {
		
		window.clearTimeout(this.delayTimeout);
		const searchTerm = event.target.value;
		
		this.delayTimeout = setTimeout(() => {

            this.resetData();

			this.searchTerm = searchTerm;
            
		}, 300);
	}
	get hasResults() {
        return this.persons.length > 0;
	}

    sortBy(field, reverse, primer) {
        const key = primer
            ? function (x) {
                  return primer(x[field]);
              }
            : function (x) {
                  return x[field];
              };

        return function (a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }

    onHandleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.persons];

        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.persons = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
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
        this.navigate('standard__recordPage', this.record.Id, 'c__Person', 'view');
    }

    async handleConfirm(event,row) {
        const result = await LightningConfirm.open({
            message: `Are you sure you want to delete "${row.Name}" record?`,
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
                
                this.toast('Success', `Record ${row.Id} deleted`, 'success', 'dismissable');
                
                location.reload();

            })
            .catch(error => {
                this.toast('Error deleting record', error.body.message, 'error', 'dismissable');
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

        this.toast('Error', 'Record cannot be edited', 'error', 'dismissable');
    }

    handleSendHandleSuccess(event){
        this.editRecordId = event.detail;
        this.handleSuccess(event);
    }

    handleSuccess(event){
        this.hideModalBox();

        this.toast('Success', `Record "${this.editRecordName}" has been updated`, 'success', 'dismissable');

        this.navigate('standard__recordPage', this.editRecordId, 'c__Person', 'view');
       
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
        
        this.toast('Success', `Record "${event.detail.recordName}" has been created`, 'success', 'dismissable');

        this.navigate('standard__recordPage', event.detail.recordId, 'c__Person', 'view');
    }

    showCreateErrorMessage(event) {
        this.toast('Error', 'Record cannot be created', 'error', 'dismissable');
    }

    navigate(type, recordId, objectApiName, actionName){
        this[NavigationMixin.Navigate]({
            type: type,
            attributes:{
                recordId: recordId,
                objectApiName: objectApiName,
                actionName: actionName
            }
        });
    }

    toast(title, message, variant, mode){
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
                mode: mode
            })
        );
    }
    
}