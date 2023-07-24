@isTest
private class EventAttendeeEmailTest {
    @testSetup
    private static void testSendMail() {
        
    }
    
    @isTest
    static void sendMail(){
        
        Test.startTest();
        
        Attendee__c attendee;
        Event__c event;
        Event_Attendee__c eventAttendee;
        
        Event_Organizer__c org = new Event_Organizer__c (
            Name = 'Organizer',
            Phone__c = '1234567890',
            Email__c = 'organ@organ.com'
        );
        insert org;
        
        attendee = new Attendee__c(
            Name='Atten Dee',
            Email__c='attendee@attendee.com',
            Phone__c='123-456-7890',
            Last_Event_Date__c = Datetime.now() 
        );
        insert attendee;
        
        event = new Event__c(
            Name='Test Event',
            Name__c='ok',
            Event_type__c='Virtual',
            Start_Date_Time__c=Datetime.now(),
            End_Date_Time__c=Datetime.now().addDays(1),
            Event_Organizer__c=org.Id,
            Live__c=true,
            Max_Seats__c=100
        );
        insert event;
        
        eventAttendee = new Event_Attendee__c(
            Attendee__c=attendee.Id,
            Event__c=event.Id
        );
        insert eventAttendee;
        Test.stopTest();
    }
}
