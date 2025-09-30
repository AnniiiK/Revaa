public class PortfolioCalculator {
    
    // Method to calculate portfolio value for an investor
    public static Decimal calculatePortfolio(Id investorId) {
        Decimal totalValue = 0;
        List<Transaction__c> txns = [SELECT Investment_Amount__c FROM Transaction__c WHERE Investor__c = :investorId];
        for(Transaction__c t : txns){
            totalValue += t.Investment_Amount__c;
        }
        return totalValue;
    }

}