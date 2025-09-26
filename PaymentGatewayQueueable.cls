public class PaymentGatewayQueueable implements System.Queueable, Database.AllowsCallouts {
    private String bookingId;

    // Constructor - just pass Booking Id
    public PaymentGatewayQueueable(Id bookingId) {
        this.bookingId = bookingId;
    }

    public void execute(System.QueueableContext ctx) {
        try {
            // Query Booking to get Total Payment
            Booking__c b = [SELECT Id, Total_Payment__c FROM Booking__c WHERE Id = :bookingId LIMIT 1];

            // Prepare JSON payload
            Map<String, Object> payloadMap = new Map<String, Object>{
                'bookingId' => b.Id,
                'amount'    => b.Total_Payment__c
            };
            String jsonPayload = JSON.serialize(payloadMap);

            // Call the payment API
            HttpResponse res = PaymentGatewayService.processPaymentRequest('/processPayment', jsonPayload);
            System.debug('Payment API response: ' + res.getBody());

        } catch (Exception e) {
            System.debug('Payment callout failed: ' + e.getMessage());
        }
    }
}