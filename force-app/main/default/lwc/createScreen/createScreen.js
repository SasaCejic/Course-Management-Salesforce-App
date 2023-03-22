import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {NavigationMixin} from 'lightning/navigation';

export default class CreateScreen extends NavigationMixin(LightningElement) {

    createdRecordName;

    @api selectedRecordTypeId;

    goBack(event){
        window.history.back();
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

    showErrorMessage(event){
        this.toast('Error', 'Record cannot be created', 'error', 'dismissable');
    }

    showSuccessMessage(event){
        this.toast('Success', `Record "${this.createdRecordName}" has been created successfully`, 'success', 'dismissable');
        this.navigate('standard__recordPage', event.detail.id, 'Person__c', 'view');
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