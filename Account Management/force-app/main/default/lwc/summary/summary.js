import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from "lightning/uiRecordApi";
import { getRelatedListRecords } from 'lightning/uiRelatedListApi';

import { subscribe, MessageContext } from 'lightning/messageService';
import DETAIL_INFO_CHANNEL from '@salesforce/messageChannel/Detail_Info__c';

export default class Summary extends LightningElement {

    mainId;
    objectApiName;

    accountType = false;
    accountId;
    relatedContacts;

    icon = 'custom:custom1';
    isSpinner = false;

    @wire(getRecord, { recordId: '$mainId', layoutTypes: ['Compact']})
    wiredRecord({ error, data }) {
        if (data) {
            let mainRecord = data;
            this.handleRecord(mainRecord);
        } else if (error) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error!',
                message:
                    error.body.message,
                    variant: 'error'
                }));
        }
    }
    
    handleRecord(record) {
        this.objectApiName = record.apiName;
        if(this.objectApiName === 'Account'){
            this.accountId = this.mainId;
            this.accountType = true;
            this.icon = 'standard:account';
            this.isSpinner = false;
        } else {
            this.accountType = false;
            this.icon = 'standard:contact';
            this.isSpinner = false;
        }
    }

    @wire(getRelatedListRecords, { 
        parentRecordId: '$accountId', 
        relatedListId: 'Contacts',
        sortBy: ['Contact.Name']
    })
    listInfo({ error, data }) {
        if (data) {            
            this.relatedContacts = data.records.length === 0 ? undefined : data.records;
        } else if (error) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error!',
                message:
                    error.body.message,
                    variant: 'error'
                }));
        }
    }

    @wire(MessageContext)
    messageContext;

    subscription = null;
    subscribeToMessageChannel() {
        this.subscription = subscribe(
        this.messageContext,
        DETAIL_INFO_CHANNEL,
        (message) => this.handleMessage(message)
        );
    }

    handleMessage(message) {
        if(this.mainId !== message.objectId) {
            this.isSpinner = true;
        }

        this.mainId = message.objectId;
    }

    connectedCallback() {
        this.subscribeToMessageChannel();
    }
}