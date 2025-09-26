trigger BookingTrigger_UpdateSeats on Booking__c (after insert, after update, after delete) {

    // Map to track seat changes per Show
    Map<Id, Decimal> seatChangeMap = new Map<Id, Decimal>();

    // Insert / Update
    if (Trigger.isInsert || Trigger.isUpdate) {
        for (Booking__c b : Trigger.new) {
            if (b.Show__c != null && b.Seats_Booked__c != null) {
                Decimal change = b.Seats_Booked__c;
                
                // For update, subtract old seats
                if (Trigger.isUpdate && Trigger.oldMap.containsKey(b.Id)) {
                    Decimal oldSeats = Trigger.oldMap.get(b.Id).Seats_Booked__c != null
                        ? Trigger.oldMap.get(b.Id).Seats_Booked__c
                        : 0;
                    change = b.Seats_Booked__c - oldSeats;
                }

                if (!seatChangeMap.containsKey(b.Show__c)) seatChangeMap.put(b.Show__c, 0);
                seatChangeMap.put(b.Show__c, seatChangeMap.get(b.Show__c) + change);
            }
        }
    }

    // Delete
    if (Trigger.isDelete) {
        for (Booking__c b : Trigger.old) {
            if (b.Show__c != null && b.Seats_Booked__c != null) {
                Decimal change = -b.Seats_Booked__c;
                if (!seatChangeMap.containsKey(b.Show__c)) seatChangeMap.put(b.Show__c, 0);
                seatChangeMap.put(b.Show__c, seatChangeMap.get(b.Show__c) + change);
            }
        }
    }

    // Update Show__c Available_Seats__c
    if (!seatChangeMap.isEmpty()) {
        List<Show__c> showsToUpdate = [SELECT Id, Available_Seats__c FROM Show__c WHERE Id IN :seatChangeMap.keySet()];
        for (Show__c s : showsToUpdate) {
            Decimal current = s.Available_Seats__c != null ? s.Available_Seats__c : 0;
            Decimal newAvailable = current - seatChangeMap.get(s.Id);
            s.Available_Seats__c = newAvailable >= 0 ? newAvailable : 0;
        }
        update showsToUpdate;
    }
}