@isTest
private class BookingTriggerTest {
    @isTest static void testBookingTrigger() {
        // Create Show
        Show__c s = new Show__c(Name='Test Show', Available_Seats__c=50);
        insert s;

        // Insert Booking
        Booking__c b = new Booking__c(Name='B1', Show__c=s.Id, Seats_Booked__c=5);
        insert b;

        // Verify seats decreased
        s = [SELECT Available_Seats__c FROM Show__c WHERE Id = :s.Id];
        System.assertEquals(45, s.Available_Seats__c);

        // Update Booking
        b.Seats_Booked__c = 8;
        update b;
        s = [SELECT Available_Seats__c FROM Show__c WHERE Id = :s.Id];
        System.assertEquals(42, s.Available_Seats__c);

        // Delete Booking
        delete b;
        s = [SELECT Available_Seats__c FROM Show__c WHERE Id = :s.Id];
        System.assertEquals(50, s.Available_Seats__c);
    }
}