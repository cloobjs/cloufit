trigger EventSpeakerNoDuplicates on EventSpeaker__c (before insert, before update) {
    
    Set<Id> idTriggerSpeaker = new Set<Id>();
    for (EventSpeaker__c triggerSpeaker : Trigger.new) {
        if (triggerSpeaker.Speaker__c != null) {
            idTriggerSpeaker.add(triggerSpeaker.Speaker__c);
        }
    }

    List<Speaker__c> triggerSpeakers = [SELECT Id, Name FROM Speaker__c WHERE Id IN :idTriggerSpeaker];
    
    for (EventSpeaker__c eventSpeaker : [SELECT Id, Speaker__r.Name FROM EventSpeaker__c WHERE Speaker__c IN :idTriggerSpeaker]) {
        for (EventSpeaker__c ev : Trigger.new) {
            if (ev.Speaker__c == eventSpeaker.Speaker__c && ev.Speaker__c != null) {
                ev.addError('Cannot insert duplicate error.');
                ErrorLogInsert.insertLog('Cannot insert duplicate error.', 'EventSpeakerNoDuplicates');
            }
        }
    }
}
