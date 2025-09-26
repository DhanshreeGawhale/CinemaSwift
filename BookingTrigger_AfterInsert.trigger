trigger BookingTrigger_AfterInsert on Booking__c (after insert) {
    for (Booking__c b : Trigger.new) {
        // Enqueue the Queueable with only Booking Id
        System.enqueueJob(new PaymentGatewayQueueable(b.Id));
    }
}