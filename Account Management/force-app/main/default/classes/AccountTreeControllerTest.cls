@isTest
private class AccountTreeControllerTest {
    
    @isTest 
    static void TestGetTreeSysMode() {

        TestDataFactory.createAccountsWithConts(15, 5);

        Test.startTest();
        List<AccountTreeController.TreeItemWrapper> wrapper = AccountTreeController.getAccountTree();
        Test.stopTest();

        System.assertEquals(15, wrapper.size());

        System.assertEquals('TestAccount0', wrapper[0].label);
        System.assertEquals('TestAccount1', wrapper[1].label);
        System.assertEquals('TestAccount10', wrapper[2].label);

        System.assertEquals(5, wrapper[5].items.size());
        System.assertEquals(5, wrapper[8].items.size());
        System.assertEquals(5, wrapper[10].items.size());
    }

    @isTest 
    static void TestGetTreeUserMode() {

        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='Test Profile'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName=uniqueUserName);

        TestDataFactory.createAccountsWithConts(15, 5);
        System.runAs(u) {            

            Test.startTest();
            List<AccountTreeController.TreeItemWrapper> wrapper = AccountTreeController.getAccountTree();
            Test.stopTest();

            System.assertEquals(0, wrapper.size());
        }
    }
}