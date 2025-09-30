public class ProfitDistributionHandler {

    // Distribute profit for a property
    public static void distributeProfit(Id propertyId, Decimal totalProfit) {

        // Get all transactions for the property
        List<Transaction__c> transactions = [
            SELECT Id, Investor__c, Ownership__c
            FROM Transaction__c
            WHERE Property__c = :propertyId
        ];

        List<Profit_Distribution__c> profitsToInsert = new List<Profit_Distribution__c>();

        for(Transaction__c t : transactions){
            if(t.Investor__c != null && t.Ownership__c != null){
                Decimal investorProfit = (t.Ownership__c / 100) * totalProfit;

                profitsToInsert.add(new Profit_Distribution__c(
                    Property__c = propertyId,
                    Investor__c = t.Investor__c,
                    Profit_Amount__c = investorProfit,
                    Distribution_Date__c = Date.today()
                ));
            }
        }

        if(!profitsToInsert.isEmpty()){
            insert profitsToInsert;
        }
    }
}