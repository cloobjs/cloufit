@isTest
private class EventSpeakerDuplicateTest {
	
    @testSetup
    private static void createSetup(){
        
        
        //enter mock orgarnizer
        List<Event_Organizer__c> testOrganizers = new List<Event_Organizer__c>();
        for (Integer i = 0; i < 10; i++) {
            testOrganizers.add(new Event_Organizer__c(
                Name = 'Test Organizer ' + i,
                Email__c = 'email'+i+'@email.com',
                Phone__c = '12345678'+i
            ));
        }
        insert testOrganizers;
        
        
        //create lists
        List<Speaker__c> testSpeakers = new List<Speaker__c>();
        List<Event__c> testEvents = new List<Event__c>();
        List<EventSpeaker__c> testES = new List<EventSpeaker__c>();
        
        
        //create initial events
        for(Integer i=0; i<10; i++){
            testSpeakers.add(new Speaker__c(
                Name='TestSpeaker'+i,
                Email__c = 'emailspeaker'+i+'@email.com',
                Phone__c = '23134678'+i
            ));
            testEvents.add(new Event__c(
                Name='TestEvent '+i,
                Event_Type__c='Virtual',
                Live__c=true,
                Recurring__c=false,
                Start_Date_Time__c=Datetime.now(),
                End_Date_Time__c=Datetime.now().addDays(1),
            	Name__c='ok',
                Max_Seats__c=50,
                Event_Organizer__c=testOrganizers[i].Id
            ));
        }
        insert testSpeakers;
        insert testEvents;
        
        //create initial eventspeakers
        for(Integer i=0; i<10; i++){
            testES.add(new EventSpeaker__c(Name='TestEventSpeaker'+i, Event__c=testEvents[i].id, Speaker__c=testSpeakers[i].id));
        }
        insert testES;
    }
    
    @isTest
    private static void duplicateTest(){
        
        //create duplicate records
        List<Speaker__c> speakers = [SELECT Id FROM Speaker__c WHERE Name LIKE 'TestSpeaker%'];
        List<Event__c> events = [SELECT Id FROM Event__c WHERE Name LIKE 'TestEvent%'];
      	List<EventSpeaker__c> eSduplicated = new List<EventSpeaker__c>();
        
        for(Integer i=0; i<speakers.size(); i++){
            if(i!=speakers.size()-1){
                eSDuplicated.add(new EventSpeaker__c(Name='Duplicate '+i, Speaker__c=speakers[i].Id, Event__c=events[i+1].Id));
            }
            else{
                eSDuplicated.add(new EventSpeaker__c(Name='Duplicate '+i, Speaker__c=speakers[i].Id, Event__c=events[0].Id));
            }
        }      
        
        //insert duplicates as test
        Test.startTest();        
        try {
            insert eSDuplicated;
        } catch (Exception e) {} 
       	Test.stopTest(); 

        //check if the duplicates were inserted
        Integer numberOfRecords = 0;
        for (EventSpeaker__c es : [SELECT id FROM EventSpeaker__c
                                WHERE Speaker__r.id IN : speakers]){
                                    numberOfrecords++;
                                }
        System.assertEquals(10, numberOfrecords, 'Number of records '+numberOfrecords);
    }
}