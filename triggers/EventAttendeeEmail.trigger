trigger EventAttendeeEmail on Event_Attendee__c (after insert) {

    EventAttendeeEmailHandler eh = new EventAttendeeEmailHandler ();
    
    try {
        if(Trigger.new != null) {
            eh.sendEmailHandler(Trigger.new);
        }
        
    } catch (Exception ex) {
        system.debug(ex.getMessage());
    } 

}