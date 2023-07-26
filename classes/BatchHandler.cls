public class BatchHandler {
	
    
    public void batchJob() {
        String jobId = System.scheduleBatch(new DeleteBatch(), 'DeleteBatchJob', 0);
    }
}