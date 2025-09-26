public with sharing class PaymentGatewayService {
    // Simple synchronous callout method (used by Queueable or for testing)
    public static HttpResponse processPaymentRequest(String endpointPath, String jsonPayload) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();

        // callout:<Named_Credential_Name> + path
        req.setEndpoint('callout:PaymentGateway' + endpointPath); 
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(jsonPayload);

        // Send request (must be executed from an async context if called in trigger)
        HttpResponse res = http.send(req);
        return res;
    }
}