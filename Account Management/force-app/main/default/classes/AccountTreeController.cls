public with sharing class AccountTreeController {
    
    @AuraEnabled(cacheable=true)
    public static List<TreeItemWrapper> getAccountTree(){
        
        List<TreeItemWrapper> items = new List<TreeItemWrapper>();
        List<Account> accounts = [
            SELECT 
                Name,
                (SELECT 
                    Name 
                FROM Contacts
                ORDER BY Name)
            FROM Account
            ORDER BY Name
            ];

        for(Account acc: accounts) {

            List<TreeItemWrapper> contacts = new List<TreeItemWrapper>();
            for(Contact cont: acc.Contacts) {
                contacts.add(new TreeItemWrapper(
                    cont.Name, 
                    String.valueOf(cont.Id), 
                    false, 
                    null));
            }
            
            items.add(new TreeItemWrapper(
                acc.Name, 
                String.valueOf(acc.Id), 
                false, 
                contacts));
        }

        return items;
    }
    
    public class TreeItemWrapper {

        @AuraEnabled
        public String label {get; set;}

        @AuraEnabled
        public String name {get; set;}

        @AuraEnabled
        public Boolean expanded {get; set;}

        @AuraEnabled
        public List<TreeItemWrapper> items {get; set;}
        
        public TreeItemWrapper(String label, String name, Boolean expanded, List<TreeItemWrapper> items) {
            this.label = label;
            this.name = name;
            this.expanded = expanded;
            this.items = items;
        }
    }
}