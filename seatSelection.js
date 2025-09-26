import { LightningElement, track } from 'lwc';

export default class SeatSelection extends LightningElement {
    @track seats = [
        { id: 1, label: 'A1' },
        { id: 2, label: 'A2' },
        { id: 3, label: 'A3' }
    ];

    selectSeat(event) {
        alert('You selected: ' + event.target.label);
        // Later, you can connect this to Booking__c via Apex
    }
}