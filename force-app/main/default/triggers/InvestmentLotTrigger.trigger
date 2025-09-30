trigger InvestmentLotTrigger on Investment_Lot__c (before insert, after insert) {

    if(Trigger.isBefore){
        Set<String> lotKeys = new Set<String>();
        for(Investment_Lot__c lot : Trigger.new){
            if(lot.Property__c != null && lot.Lot_Number__c != null){
                String key = lot.Property__c + '-' + lot.Lot_Number__c;
                if(lotKeys.contains(key)){
                    lot.addError('This lot is already being processed.');
                } else {
                    lotKeys.add(key);
                }
            }
        }

        List<Investment_Lot__c> existingLots = [
            SELECT Id, Property__c, Lot_Number__c
            FROM Investment_Lot__c
            WHERE Property__c IN :lotKeys
        ];
        for(Investment_Lot__c exLot : existingLots){
            String key = exLot.Property__c + '-' + exLot.Lot_Number__c;
            if(lotKeys.contains(key)){
                for(Investment_Lot__c lot : Trigger.new){
                    if(lot.Property__c == exLot.Property__c && lot.Lot_Number__c == exLot.Lot_Number__c){
                        lot.addError('This lot has already been sold.');
                    }
                }
            }
        }
    }

    if(Trigger.isAfter){
        Set<Id> investorIds = new Set<Id>();
        Set<Id> propertyIds = new Set<Id>();

        for(Investment_Lot__c lot : Trigger.new){
            if(lot.Investor__c != null) investorIds.add(lot.Investor__c);
            if(lot.Property__c != null) propertyIds.add(lot.Property__c);
        }

    }
}