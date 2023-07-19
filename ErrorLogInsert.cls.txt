public with sharing class ErrorLogInsert {
    public static void insertLog(Datetime log_datetime, String log_details, String process_name) {
        Error_Log__c error_log = new Error_Log__c(
            Log_DateTime__c = log_datetime,
            Log_Details__c = log_details,
            Process_Name__c = process_name
        );
        
        //error_log.Log_DateTime__c = log_datetime;
        //error_log.Log_Details__c = log_details;
        //error_log.Process_Name__c = process_name;

        insert error_log;
    }
}