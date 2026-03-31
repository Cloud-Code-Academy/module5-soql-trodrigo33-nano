// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

        Set<Id> accountIds = new Set<Id>();
		List<Opportunity> oppsFromMethod = SOQL.getOpportunityDetailsForClosedWon();
        System.debug('RETRIEVED LIST: ' + oppsFromMethod);
        System.debug('RETRIEVED LIST SIZE: ' + oppsFromMethod.size());

		for (Opportunity oppFromMethod : oppsFromMethod) {
		if (oppFromMethod != null) {
			accountIds.add(oppFromMethod.AccountId);
            System.debug('INSIDE LOOP SET: ' + accountIds);
		}
         System.debug('LOOPED SET: ' + accountIds);
         System.debug('LOOPED SET SIZE: ' + accountIds.size());
		}

		// Query the Contacts (TR - using the Id - child to Parent)
		List <Contact> accountContacts = [SELECT Id, AccountId FROM Contact WHERE AccountId IN :accountIds ORDER BY Name ASC];
        System.debug('QUERIED CONTACTS: ' + accountContacts);
        System.debug('QUERIED CONTACTS SIZE: ' + accountIds.size());

		// Loop through each Contact and add the Account Id and Contact to the map
		Map<Id,Id> accountToContactMap = new Map<Id,Id>();

		for (Contact accountContact : accountContacts) {
			if (accountContact != null) {
				accountToContactMap.put(accountContact.AccountId, accountContact.Id);
			}
            System.debug('LOOPED CONTACTS: ' + accountToContactMap);
            System.debug('LOOPED CONTACTS SIZE: ' + accountToContactMap.size());
		}
        for (Opportunity oppUpdated : oppsFromMethod) 
        if (accountToContactMap.containsKey(oppUpdated.AccountId)) {
        System.debug((oppUpdated.AccountId));
        System.debug(accountToContactMap.get(oppUpdated.AccountId));
        }
          /*
		// Loop through each Opportunity (TR - Loop through each opportunity in the list returned from method. Find opp Where accountId in map matches accountId in current loop item)
		// Update the Opportunity primary contact from accountToContactMap
  
		for (Opportunity oppUpdated : oppsFromMethod) 
		  if (accountToContactMap.containsKey(oppUpdated.AccountId)) {
		       String PrimaryContact = accountToContactMap.get(oppUpdated.AccountId.toString()); //Get accountId in Map to return paired value (contactId)
	}
            System.debug('LOOPED OPP UPDATE: ' + accountToContactMap);
            System.debug('LOOPED OPP SIZE: ' + accountToContactMap.size());
            */