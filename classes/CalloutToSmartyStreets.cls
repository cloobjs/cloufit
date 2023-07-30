public with sharing class CalloutToSmartyStreets {
    
    public static Boolean doFutureResult = null;
    
    
    @future(callout = true)
    public static void doFuture(Id recordId) {

        Location__c loc = [SELECT Id, City__c, State__c, Street__c, Postal_Code__c, Verified__c FROM Location__c WHERE id =: recordId];
        Boolean isVerified = calloutToVerifyLocation( loc.city__c,  loc.state__c, loc.street__c, loc.Postal_Code__c);
        
        //if (isVerified == true) {
        //    loc.Verified__c = true;
        //    update loc;
        //}
        //else {
        //    loc.Verified__c = false;
        //    update loc;
        //} 
    }
   

    public static Boolean calloutToVerifyLocation(String City, String State, String Street,String PostalCode) {
       
        String street2 = street.replace(' ','%20');
        System.debug(street2);

        Http http = new Http();
        HttpRequest request = new HttpRequest();
       
        String smartStreet = 'https://us-street.api.smartystreets.com/street-address?auth-id=6a9fa49a-f21a-1c77-76e0-1a8c14f3a4eb&auth-token=Wq9w2q7cVrJysBVXY6Ql&street='+street2+'&street2=&city='+City+'&state='+State+'&zipcode='+PostalCode+'&candidates=10&match=invalid';
       
        request.setEndpoint(smartStreet);
        request.setMethod('GET');

        HttpResponse httpResponse = http.send(request);

        try {

            if(httpResponse.getStatusCode() == 200) {
                System.debug(httpResponse.getBody());
                String  response = httpResponse.getBody();
                doFutureResult = true;

                return true;
                
               
            } else {
            
                System.debug('The status code returned was not expected: ' + httpResponse.getStatusCode() + ' ' + HttpResponse.getStatus());
                System.debug(httpResponse.getBody());
                String  response = httpResponse.getBody();
                doFutureResult = false;
                return false;
            }

        } catch (System.CalloutException ex) {
            System.debug('Exception ' +ex);
        }
    

        return null;

    }
}