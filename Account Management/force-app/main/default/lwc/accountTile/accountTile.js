import { LightningElement, api } from 'lwc';

import NAME_FIELD from '@salesforce/schema/Account.Name';
import TYPE_FIELD from '@salesforce/schema/Account.Type';
import PHONE_FIELD from '@salesforce/schema/Account.Phone';
import WEBSITE_FIELD from '@salesforce/schema/Account.Website';

export default class AccountTile extends LightningElement {
    @api
    accountId;

    nameField = NAME_FIELD;
    typeField = TYPE_FIELD;
    phoneField = PHONE_FIELD;
    websiteField = WEBSITE_FIELD;
}