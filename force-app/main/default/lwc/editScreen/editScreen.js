import { LightningElement, api } from 'lwc';

export default class EditScreen extends LightningElement {

    @api recordid;
    @api recordname;

    sendShowModalValue(event){
        this.dispatchEvent(
            new CustomEvent('closemodal', {detail: false})
        );
    }

    sendShowErrorMessage(event){
        this.dispatchEvent(
            new CustomEvent('errormessage')
        );
    }

    sendHandleSuccess(event){
        this.dispatchEvent(
            new CustomEvent('successedit', {detail: this.recordid})
        );
       
    }

}