public with sharing class PaymentGatewayInvocable {

    public class Request {
        @InvocableVariable(required=true)
        public Id bookingId;
    }

    @InvocableMethod(label='Process Payment' description='Call payment API for a booking')
    public static void processPayment(List<Request> requests) {
        for (Request r : requests) {
            // Enqueue the Queueable class with only Booking Id
            System.enqueueJob(new PaymentGatewayQueueable(r.bookingId));
        }
    }
}