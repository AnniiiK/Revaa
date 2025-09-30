import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import PRICE_FIELD from '@salesforce/schema/Property__c.Price__c';
import AVAILABLE_LOTS_FIELD from '@salesforce/schema/Property__c.Available_Lots__c';
import ID_FIELD from '@salesforce/schema/Property__c.Id';

export default class RevaaDashboard extends LightningElement {
    @api recordId;
    @track message = '';

    @wire(getRecord, { recordId: '$recordId', fields: [PRICE_FIELD, AVAILABLE_LOTS_FIELD] })
    property;

    handlePurchase() {
        if(this.property.data.fields.Available_Lots__c.value > 0){
            const fields = {};
            fields[ID_FIELD.fieldApiName] = this.recordId;
            fields[AVAILABLE_LOTS_FIELD.fieldApiName] = this.property.data.fields.Available_Lots__c.value - 1;

            updateRecord({ fields })
                .then(() => {
                    this.message = 'Lot Purchased Successfully!';
                })
                .catch(error => {
                    this.message = 'Error purchasing lot: ' + error.body.message;
                });
        } else {
            this.message = 'No lots available.';
        }
    }
}