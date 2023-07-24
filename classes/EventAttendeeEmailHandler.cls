public with sharing class EventAttendeeEmailHandler {
   
    public void sendEmailHandler(List<Event_Attendee__c> listEventAttendee) {
        
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
        Set<Id> triggerAttendeeId = new Set<Id>();
        Set<Id> triggerEventId = new Set<Id>();
            
        for(Event_Attendee__c eventAttendee : listEventAttendee){
            triggerAttendeeId.add(eventAttendee.Attendee__c);
            triggerEventId.add(eventAttendee.Event__c);
            //System.debug('AttendeeId =' + triggerAttendeeId + 'EventId =' + triggerEventId);    
        }
        
        Attendee__c  triggerAttendee =
            [ SELECT Id, Name, Email__c FROM Attendee__c WHERE Id IN : triggerAttendeeId ];
       
        Event__c triggerEvent =
            [ SELECT Id, Name, Start_Date_Time__c, Location__c, Event_Organizer__c FROM Event__c  WHERE Id IN : triggerEventId ];
        
        Location__c triggerLocation =
            [ SELECT Id, Name, City__c, Street__c FROM Location__c WHERE Id = : triggerEvent.Location__c ];
        
        Event_Organizer__c triggerOrganizer =
            [ SELECT Id, Name FROM Event_Organizer__c WHERE Id = : triggerEvent.Event_Organizer__c ];
        
        
        List<String> sendTo = new List<String>();
        sendTo.add(triggerAttendee.Email__c);
        
        String body = 'Dear ' + triggerAttendee.Name +
         ',<p> Thank you for registering for ' +  triggerEvent.Name + ' which will be Organized on ' + 
         triggerEvent.Start_Date_Time__c +' & will be held in '+ triggerLocation.Street__c +
         '. We are excited to have you, see you in the event . <p>Find the Google Map Location for the Event Here. (https://www.google.com/maps/place/'+
          triggerLocation.city__c +')  <p> Thanks, '+triggerOrganizer.Name +'';

        Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
        mail.setToAddresses(sendTo);
        mail.setSubject('Pass for the  '+ triggerAttendee.Name);
        
        mail.setHtmlBody(body);
        mails.add(mail);
        Messaging.sendEmail(mails);
    }
    
}