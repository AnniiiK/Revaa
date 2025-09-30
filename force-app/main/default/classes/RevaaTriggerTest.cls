@IsTest
public class RevaaTriggerTest {

    @IsTest
    static void testTransactionTrigger() {
        Property__c prop = new Property__c(
            Name = 'Test Prop',
            Price__c = 1000000,
            Total_Lots__c = 100
        );
        insert prop;

        Investor__c inv = new Investor__c(
            Name = 'Investor A'
        );
        insert inv;

        Transaction__c trans = new Transaction__c(
            Property__c = prop.Id,
            Investor__c = inv.Id,
            Lots_Purchased__c = 10
        );
        insert trans;

        inv = [SELECT Total_Investmen__c FROM Investor__c WHERE Id = :inv.Id];

        Decimal expectedInvestment = 10 * (prop.Price__c / prop.Total_Lots__c);
        System.assertEquals(expectedInvestment, inv.Total_Investmen__c, 'Investor Total Investment should be updated correctly.');
    }

    @IsTest
    static void testInvestmentLotTrigger() {
        Property__c prop = new Property__c(
            Name = 'Lot Test',
            Price__c = 500000,
            Total_Lots__c = 50
        );
        insert prop;

        Investor__c inv = new Investor__c(
            Name = 'Investor B'
        );
        insert inv;

        Investment_Lot__c lot = new Investment_Lot__c(
            Property__c = prop.Id,
            Investor__c = inv.Id
        );
        insert lot;

        Integer lotCount = [SELECT COUNT() FROM Investment_Lot__c WHERE Property__c = :prop.Id];
        System.assertEquals(1, lotCount, 'One lot should be linked to the property.');
    }
}