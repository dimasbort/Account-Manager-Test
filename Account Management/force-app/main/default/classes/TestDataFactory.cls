@isTest
public class TestDataFactory {
    public static List<Account> createAccountsWithConts(Integer numAccts, Integer numContsPerAcct) {

        List<Account> accts = new List<Account>();
        for(Integer i = 0; i < numAccts; i++) {
            Account a = new Account(Name = 'TestAccount' + i);
            accts.add(a);
        }

        insert accts;

        List<Contact> conts = new List<Contact>();
        for (Integer j = 0; j < numAccts; j++) {

            Account acct = accts[j];
            for (Integer k = 0; k < numContsPerAcct; k++) {
                conts.add(new Contact(
                    LastName = acct.Name + ' Contact ' + k,
                    AccountId = acct.Id
                ));
            }
        }

        insert conts;
        return accts;
    }
}