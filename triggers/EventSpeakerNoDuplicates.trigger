trigger EventSpeakerNoDuplicates on EventSpeaker__c (before insert, before update ) {
    List<EventSpeaker__c> eventSpeakersList = new List<EventSpeaker__c>( [SELECT Id, Speaker__r.Name FROM EventSpeaker__c] );
    
    Set<Id> idTriggerSpeaker = new Set<Id>();
    
    for(EventSpeaker__c triggerSpeaker : Trigger.new){
      
        if(triggerSpeaker.Speaker__c != null)
        {
            idTriggerSpeaker.add(triggerSpeaker.Speaker__c);
        }
        
    }

    Speaker__c triggerSpeaker = [SELECT Id, Name FROM Speaker__c WHERE Id IN : idTriggerSpeaker ];
    
    for(EventSpeaker__c eventSpeaker : eventSpeakersList){
         
        if(eventSpeaker.Speaker__r.Name == triggerSpeaker.Name ){
         
            for(EventSpeaker__c ev : Trigger.new){
                ev.addError('Cannot insert duplicate error.');      
                
                ErrorLogInsert.insertLog('Cannot insert duplicate error.', 'EventSpeakerNoDuplicates');        
            }
                 
        }
            
    }
    
}