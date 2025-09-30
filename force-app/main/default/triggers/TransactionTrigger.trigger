trigger TransactionTrigger on Transaction__c (after insert, after update) {

    Set<Id> investorIds = new Set<Id>();
    for(Transaction__c t : Trigger.new){
        if(t.Investor__c != null) investorIds.add(t.Investor__c);
    }

    Map<Id, Investor__c> investorMap = new Map<Id, Investor__c>(
        [SELECT Id, Total_Investmen__c FROM Investor__c WHERE Id IN :investorIds]
    );

    Set<Id> propertyIds = new Set<Id>();
    for(Transaction__c t : Trigger.new){
        if(t.Property__c != null) propertyIds.add(t.Property__c);
    }

    Map<Id, Property__c> propertyMap = new Map<Id, Property__c>(
        [SELECT Id, Price__c, Total_Lots__c FROM Property__c WHERE Id IN :propertyIds]
    );

    List<Investor__c> investorsToUpdate = new List<Investor__c>();

    for(Transaction__c t : Trigger.new){
        Investor__c inv = investorMap.get(t.Investor__c);
        Property__c prop = propertyMap.get(t.Property__c);

        if(inv != null && prop != null){
      
            Decimal transactionAmount = t.Lots_Purchased__c * (prop.Price__c / prop.Total_Lots__c);

            inv.Total_Investmen__c = (inv.Total_Investmen__c != null ? inv.Total_Investmen__c : 0) + transactionAmount;
            investorsToUpdate.add(inv);
        }
    }

    if(!investorsToUpdate.isEmpty()){
        update investorsToUpdate;
    }
}