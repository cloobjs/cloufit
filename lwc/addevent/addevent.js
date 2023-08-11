import { LightningElement, track, wire } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';

import EVT_OBJECT from '@salesforce/schema/Event__c';
import Name from '@salesforce/schema/Event__c.Name';
import Event_Organizer__c from '@salesforce/schema/Event__c.Event_Organizer__c';
import Start_Date_Time__c from '@salesforce/schema/Event__c.Start_Date_Time__c';
import End_Date_Time__c from '@salesforce/schema/Event__c.End_Date_Time__c';
import Max_Seats__c from '@salesforce/schema/Event__c.Max_Seats__c';
import Location__c from '@salesforce/schema/Event__c.Location__c';
import Event_Detail__c from '@salesforce/schema/Event__c.Event_Detail__c';
import Live__c from '@salesforce/schema/Event__c.Live__c';

import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AddEvent extends NavigationMixin(LightningElement) {

    @track eventRecord = {
        Name: '',
        Event_Organizer__c: '',
        Start_Date_Time__c: null,
        End_Date_Time__c: null,
        Max_Seats__c: null,
        Location__c: '',
        Event_Detail__c: '',
        Live__c: false
    }

    @track errors;

    handleChange(event) {
        let value = event.target.value;
        let name = event.target.name;
        this.eventRecord[name] = value;
    }

    handleLive(event) {
        this.eventRecord.Live__c = event.target.checked;
    }

    handleRichText(event) {
        this.eventRecord.Event_Detail__c = event.target.value;
    }

    handleLookup(event) {
        let selectedRecId = event.detail.selectedRecordId;
        let parentField = event.detail.parentfield;
        console.log(event.detail.parentField);
        this.eventRecord[parentField] = selectedRecId;
    }

    handleClick() {
        const fields = {};
        fields[Name.fieldApiName] = this.eventRecord.Name;
        fields[Event_Organizer__c.fieldApiName] = this.eventRecord.Event_Organizer__c;
        fields[Start_Date_Time__c.fieldApiName] = this.eventRecord.Start_Date_Time__c;
        fields[End_Date_Time__c.fieldApiName] = this.eventRecord.End_Date_Time__c;
        fields[Max_Seats__c.fieldApiName] = this.eventRecord.Max_Seats__c;
        fields[Location__c.fieldApiName] = this.eventRecord.Location__c;
        fields[Event_Detail__c.fieldApiName] = this.eventRecord.Event_Detail__c;
        fields[Live__c.fieldApiName] = (this.eventRecord.Live__c == true) ? true : false;
        console.log(fields);

        const eventRecord = { apiName: EVT_OBJECT.objectApiName, fields };
        
        if (fields[Name.fieldApiName] === ''
            || fields[Event_Organizer__c.fieldApiName] === ''
            || fields[Start_Date_Time__c.fieldApiName] === null
            || fields[Max_Seats__c.fieldApiName] === null
            || fields[Location__c.fieldApiName] === ''
            || fields[Event_Detail__c.fieldApiName] === '') {

                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error Occured',
                    message: 'Please fill all the mandatory fields',
                    variant: 'error'
                }));
        } else {
            createRecord(eventRecord)
                .then((eventRec) => {
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'Success',
                        message: 'Event created successfully',
                        variant: 'success'
                    }));
                    this[NavigationMixin.Navigate]({
                        type: 'standard__recordPage',
                        attributes: {
                            actionName: "view",
                            recordId: eventRec.id
                        }
                    });
                }).catch((err) => {
                    this.errors = JSON.stringify(err);
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'Error Occured',
                        message: this.errors,
                        variant: 'error'
                    }));
            });
        }
    }

    handleCancel() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                actionName: "home",
                objectApiName: "Event__c"
            }
        });
    }
}