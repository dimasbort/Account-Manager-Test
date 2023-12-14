import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { publish, MessageContext } from 'lightning/messageService';
import DETAIL_INFO_CHANNEL from '@salesforce/messageChannel/Detail_Info__c';

import getAccountTree from '@salesforce/apex/AccountTreeController.getAccountTree';

export default class AccountTree extends LightningElement {
    
    @wire(MessageContext)
    messageContext;

    items;
    isSpinner = true;
    showEmpty = false;

    handleOnselect(event) {
        const payload = { 
            objectId: event.detail.name
        };
        
        publish(this.messageContext, DETAIL_INFO_CHANNEL, payload);
    }

    @wire(getAccountTree)
    wiredAccounts({ error, data }) {
        if (data) {
            this.items = data;
            if(data.length === 0) this.showEmpty = true;
            this.isSpinner = false;
        } else if (error) {
            this.isSpinner = false;
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error!',
                message:
                    error.body.message,
                    variant: 'error'
                }));
        }
    }
}