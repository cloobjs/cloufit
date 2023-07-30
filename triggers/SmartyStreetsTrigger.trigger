trigger SmartyStreetsTrigger on Location__c (before insert, before update) {

    for (Location__C location : Trigger.New) {
        
        System.debug(location.Country__c);
        
        if (location.Country__c == 'United States') {

            CalloutToSmartyStreets.doFuture(location.id);
            
            location.Verified__c = true;
            
        }
    }
}