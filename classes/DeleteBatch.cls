public class DeleteBatch implements Database.Batchable<SObject> {
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Name FROM Event__c WHERE Live__c = true AND End_Date_Time__c < LAST_N_MONTHS:2';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<Event__c> records) {
        if (records.size() > 0) {
            //List<Database.DeleteResult> results = Database.delete(records);
            Database.delete(records);
        }
    }

    public void finish(Database.BatchableContext BC) {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSubject('Execution of the batch has been processed');

        List<String> to = new List<String>();
        to.add('jan.szewczul@cloobees.com');
        message.setToAddresses(to);

        message.setHtmlBody('Event records batch deletion has been completed');
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        messages.add(message);
        Messaging.sendEmail(messages);
    }
}