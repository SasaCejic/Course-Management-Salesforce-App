import { LightningElement, api } from 'lwc';

export default class ValidationScreen extends LightningElement {
    @api phone;
    showResultTable = false;
    detialsButtonTitle = "View details";
    response;
    columns = [];
    resId = 1;
    @api numbervalidationkey;

    connectedCallback(){
        this.sendRequest(this.numbervalidationkey, this.phone);
    }
    
    viewOrHideDetails(){
        this.showResultTable = (this.showResultTable) ? false : true;
        this.detialsButtonTitle = (this.showResultTable) ? "Hide details" : "View details";
    }

    sendRequest(validationKey, phoneNumber){
        const url = 'https://api.addressy.com/PhoneNumberValidation/Interactive/Validate/v2.20/json3.ws?Key=' + validationKey + '&Phone=' + phoneNumber;
        fetch(url)
        .then(
            data=>{
                return data.json()
            }).then(
                res=>{
                    (Object.keys(res.Items[0])).forEach(element => {
                        this.columns = [...this.columns, { label: element, fieldName: element, type: 'text' }];
                    });
                    this.response = res.Items;
                    this.response.Id = this.resId;
                    this.resId++;
                })
    }
}