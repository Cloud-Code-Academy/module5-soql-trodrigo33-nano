/**
 * The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
 * It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
 *
 * This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
 * a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
 * records, and manage data volume using the LIMIT keyword.
 *
 * Topics covered in this class include:
 * - Understanding the structure of a SOQL query.
 * - Crafting basic SELECT statements in SOQL.
 * - Applying filters using the WHERE clause in SOQL.
 * - Fetching related records using Relationship queries.
 * - Controlling the amount of data retrieved using the LIMIT keyword.
 *
 * Users of this class can expect to gain a solid understanding of SOQL in Apex and
 * be prepared to handle data retrieval tasks in Salesforce development.
 *
 * @author Thayne Rodrigo
 */

public with sharing class SOQL {
	/**
	 * Question 1
	 * Update/Uncomment the template code to create a method
	 * Returns all leads from Salesforce Org
	 * @return List of all leads with Id, LastName, Company, Phone, Email
	 * Update the corresponding test class and testGetAllLeads method to cover this method
	 */
	public static List<Lead> getAllLeads () {
	List<Lead> getLeads = [
		SELECT Id, LastName, Company, Phone, Email 
		FROM Lead];
	return getLeads;
	}
	
	/**
	 * Question 2
	 * Update/Uncomment the template code to create a method
	 * Returns all contacts with first name of John.
	 * @return A list of Contact records.
	 * Update the corresponding test class and testGetContactsByFirstName method to cover this method
	 */
	public static List<Contact> getByFirstName () {
	//  The body of the method
	// TR - Trying to keep it dynamic per lecture video by using a list variable for the query, rather than hardcoding a string. This allows for flexibility in updating the method and what it retrieves in future. Easier to debug too.
	List<String> contactName = new List<String>{'John'};
	List<Contact> getContacts = [
		SELECT Id, Name 
		FROM Contact 
		WHERE FirstName 
		IN :contactName];
	return getContacts;
	}

	/**
	 * Question 3
	 * Update/Uncomment the template code to create a method
	 * Returns the Contact Id for all contacts with last name of Smith or Jones
	 * @return A list of Contact Ids.
	 * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
	 * 
	 * TR: Note to self, this did not need a check for null values on the return, as we are allowed to return an empty list (''). A null return would return an error.
	 * Because we've created a list out of the SOQL query, it would return as an empty list rather than a ... 'null' list/one that doesn't exist.
	 */
	public static List<Id> getIdByLastName () {
	 List<String> lastNames = new List<String>{'Smith', 'Jones'};
	 List<Id> contactIds = new List<Id>();
     
	 for (Contact cont : [SELECT Id FROM Contact WHERE LastName IN :lastNames]) {
		contactIds.add(cont.Id)	;
	 }
	 return contactIds;
	}

	/**
	 * Question 4
	 * Update/Uncomment the template code to create a method
	 * Returns List of closed won opportunities for a specific Account.
	 * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A list of Opportunities with important opportunities fields
	 * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
	 * 
	 * TR: Reminder that using ':variable' means to bind the value of the APEX variable within the SOQL query, so that it can be used.
	 */
	public static List<Opportunity> getClosedWonOpportunitiesByAccount (Id accountId) {
		List<Opportunity> opportunities = new List<Opportunity>();
		for (Opportunity opp : [
			SELECT Id, Name, StageName, CloseDAte, AccountId, Amount 
			FROM Opportunity 
			WHERE AccountId = :accountId 
			AND StageName = 'Closed Won']) {
			opportunities.add(opp);
		}
		return opportunities;
	}

	/**
	 * Question 5
	 * Update/Uncomment the template code to create a method
	 * Returns the total count of Account records.
	 * @return The Integer count of Account records.
	 * Update the corresponding test class and testGetAccountCount method to cover this method
	 * 
	 * TR: Reminder for Count(); because we use this aggregate function, we don't need to initialize the integer var with 0, because the function returns a value of 0 if
	 * no record is returned in the query.
	 * 
	 * TR2 - Hey teach. Just wondering if I can get your thoughts about this. I made a design decision to include a new variable to store the query results in instead of
	 * just writing 'return = [SELECT...]'. I know we talked about how less is more, but what about in this situation? I kept it this way because I wanted to make it readable/
	 * easier to work with when debugging in the future for me/others. Would this be more of a preferential call at this point?
	 */
	public static Integer totalCountofAccounts () {
	Integer countAccounts = [SELECT COUNT() FROM Account];
	return countAccounts;
	}

	/**
	 * Question 6
	 * Update/Uncomment the template code to create a method
	 * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
	 * @return A map of Task Ids to Task records.
	 * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
	 * 
	 * TR: Hey teach, I got a bit confused with this question. I'm not sure if this is asking to return a map of Task Id : Task Object (fully retrieved). On reading the test
	 * class, I surmised that it means to return the Activity date field.
	 */

	public static Map <Id, Task> getTasksDueNextWeek () {
	//gets the records due within next 7 days (7 days less or equals to activityDate).
	//TR: Note - I can query within a map constructor. The map constructor will automatically map the Id of the task to the key, and the record to the value of the pair.
	Map<Id, Task> TasksDue = new Map<Id, Task>([
		SELECT Id, ActivityDate 
		FROM Task 
		WHERE ActivityDate <= NEXT_N_DAYS:7]);
	return TasksDue;
	}

	/**
	 * Question 7
	 * Update/Uncomment the template code to create a method
	 * Retrieves all Contacts that have a example.com domain in their Email.
	 * @return A list of Contact records.
	 * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
	 * 
	 * TR: retrieve Contacts where emails ENDS with example.com; similar to %example.com% which checks if variable CONTAINS it.
	 */
	public static List <Contact> getContactByEmailDomain () {
		List<Contact> contactEmailDomain = [
			SELECT Id, Name, Email 
			FROM Contact 
			WHERE Email 
			LIKE '%example.com'];
		return contactEmailDomain;
	}

	/**
	 * Question 8
	 * Retrieves all Opportunities that have a specific keyword in their Name.
	 * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
	 * @param keyword The keyword to search for in the Opportunity Name.
	 * @return A list of Opportunity records.
	 */
	public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
		keyword = '%' + keyword + '%';
		List<Opportunity> opportunities = [
			SELECT Id, Name, StageName, AccountId 
			FROM Opportunity 
			WHERE Name 
			LIKE :keyword];
		return opportunities;
	}

	/**
	 * Question 9
	 * Retrieves all Cases that Case Origin is not Web or Email or Blank
	 * @return A list of Case records.
	 */
	public static List<Case> getFilterCaseOrigins() {
		List<Case> cases =[SELECT Id, Origin FROM Case WHERE Origin NOT IN('Web', 'Email', '')];
		return cases;
	}

	/**
	 * Question 10
	 * Update/Uncomment the template code to create a method
	 * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
	 * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
	 * @param leadSource The Lead Source to search for.
	 * @param keyword The keyword to search for in the Lead Title.
	 * @return A list of Lead records.
	 * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
	 */
	public static List<Lead> getLeadsBySourceOrTitle (String leadSource, String keyword ) {
	keyword = '%' + keyword + '%'; 
	List<Lead> leadsFiltered = new List<Lead> ([
		SELECT Id, LastName, Company, Phone, Email, LeadSource, Title 
		FROM Lead 
		WHERE (LeadSource LIKE :leadSource OR Title LIKE :keyword)]);
	return leadsFiltered;
	}

	/**
	 * Question 11
	 * Returns the names of all Contacts associated with an Account.
	 * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A list of Contact LastName.
	 */
	public static List<String> getContactNamesByAccount(Id accountId) {
		List<String> contacts = new List<String>();
		for (Contact cont : [SELECT Id, LastName FROM Contact WHERE AccountId = :accountId]) {
			contacts.add(cont.LastName);
		}
		return contacts; 
	}

	/**
	 * Question 12
	 * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
	 * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for the found opportunities
	 * @param stage The Stage value to filter Opportunities.
	 * @return The total revenue.
	 * 
	 */
	public static Decimal getTotalRevenueByStage(String stage) {
		AggregateResult totalRevenue = [
			SELECT SUM(Amount) totalAmount 
			FROM Opportunity 
			WHERE (StageName =:stage OR Amount >= 10000)];
		Decimal result = (Decimal)totalRevenue.get('totalAmount');
		return (result);
	}

	/**
	 * Question 13
	 * Retrieves the first 10 Accounts ordered by Name.
	 * @return A list of the first 10 Accounts ordered by Name.
	 */
	public static List<Account> getFirstTenAccounts() {
		List<Account> firstTenAccounts = new List<Account>([
			SELECT Id, Name 
			FROM Account
			ORDER BY Name ASC
			LIMIT 10
		]);
		return firstTenAccounts;
	}

	/**
	 * Question 14
	 * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
	 * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
	 */
	public static List<Opportunity> getHighValueOpportunities() {
			List<Opportunity> highValueOpps = [
			SELECT Id, Name, CloseDate, Amount
			FROM Opportunity
			WHERE Amount > 100000
			ORDER BY CloseDate
			LIMIT 5
		];
		return highValueOpps; 
	}

	/**
	 * Question 15
	 * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
	 * @return A list of Contacts
	 */
	public static List<Contact> getBirthdateContacts() {
			List<Contact> contacts = new List<Contact>([
			SELECT Id, Name, Birthdate
			FROM Contact
			ORDER BY Birthdate DESC
			LIMIT 3
		]);
		return contacts; 
	}

	/**
	 * Question 16
	 * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
	 * @return A list of Cases
	 */
	public static List<Case> getCasesWithStatus() {
		List<Case> cases = new List<Case>([
		SELECT Id, CaseNumber, Status, CreatedDate
		FROM Case
		WHERE Status = 'Open'
		ORDER BY CreatedDate ASC
		LIMIT 10
		OFFSET 5
		]);
		return cases; 
	}

	/**
	 * Question 17
	 * Returns Set of Case Ids for a specific Account.
	 * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A set of Case Ids.
	 */
	public static Set<Id> getCaseIdsByAccount(Id accountId) {
		Set<Id> caseIds = new Set<Id> ();
		for (Case c : [SELECT Id FROM Case WHERE AccountId = :accountId]) {
			caseIds.add(c.Id);
		}
		return caseIds;
	}

	/**
	 * Question 18
	 * Return Map of Account Ids to Account Names Not in a specific Country.
	 * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
	 * @param country The country to filter Accounts.
	 * @return A map of Account Ids to Account Names.
	 */
	public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
		Map<Id, String> accountIdsToNames = new Map<Id, String>();
		 for (Account acc : [SELECT Id, Name FROM Account WHERE BillingCountry != :country]) {
			accountIdsToNames.put(acc.Id, acc.Name);
		}
		return accountIdsToNames; 
	}

	/**
	 * Question 19
	 * Retrieves the Account Name for a given Contact.
	 * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
	 * @param contactId The Id of the Contact.
	 * @return The Account Name of the Contact.
	 */
	public static String getAccountNameForContact(String contactId) {
		Contact cont = [SELECT Account.Name FROM Contact WHERE Id = :contactId];
		return cont.Account.Name; 
	}

	/**
	 * Question 20
	 * Returns single Account that has related opportunities in the same query
	 * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
	 * @param accountId The ID of the Account.
	 * @return An Account record with related Opportunities.
	 * 
	 * TR - Would add an if/else statement to check for null in real world scenario, but for the exercise I assume it's all good.
	 */
	public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {
		Account acc = [
			SELECT Id, Name, 
			(SELECT Id, Name FROM Opportunities) 
			FROM Account 
			WHERE Id = :accountId];
		return acc;
	}

	/**
	 * Question 21
	 * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
	 * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
	 * @param Account Id
	 * @return List of contacts with the same Mailing State as the Account Billing State
	 * 
	 * TR - Hey teach, the question is a bit misleading. The first sentence states 'similar to..' while the rest states 'same'. To me, 'similar to' means it's not quite identical. Could mean fuzzy, partial, or exact match on initial read.
	 */
	public static List<Contact> getAccountsWithContactsByState(Id accountId) {
		// Query the Account
		// Store the Account's BillingState
		Account acc = [
		SELECT Id, BillingState 
		FROM Account
		WHERE Id = :accountId
		];
		// Query the Contacts
		List<Contact> cont = [
			SELECT Id, Name, MailingState
			FROM Contact
			WHERE MailingState = :acc.BillingState
		];
		return cont;
	}

	/**
	 * Question 22
	 * Extracts email domains from leads, then finds Accounts with matching website domains
	 * If Lead Email = test@test.com return account with website = www.test.com
	 * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
	 * @param leadIds set of Lead Ids.
	 * @return A list of Accounts with matching email domains.
	 * 
	 * TR - This was tricky. Keen to know what a better way to write this is...
	 */
	public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) {
		
        // Query the Leads
		// Create a set of email domains from the Leads
		// Loop through each Lead
		// Get the email from the Lead
		// Check if the email is not null
		// Add the email domain to the set
		// Query the Accounts
			//TR - Extract domain from account Website to compare with Set.
			//TR - After the websiteDomain is extracted, check if the domain is in the set. 

			//TR (26/3/26)- Removing query per feedback; to consolidate with first for loop; building domain set.
/*
		List <Lead> leads = new List<Lead>([
		SELECT Id, Email
		FROM Lead
		WHERE Id IN :leadIds
		AND Email != null
		]);
*/

		Set<String> setEmailDomains = new Set<String>();
		for (Lead lead : [
		SELECT Id, Email
		FROM Lead
		WHERE Id IN :leadIds
		AND Email != null
		]) {
		setEmailDomains.add('www.' + lead.Email.substringAfter('@'));
		}
		
		List <Account> accounts = new List<Account>();
        for (Account acc : [SELECT Id, Website FROM Account WHERE Website LIKE :setEmailDomains]) {
			String websiteDomain = acc.Website;
			if (websiteDomain.startsWithIgnoreCase('www.')) {
				websiteDomain = websiteDomain.substringAfter('.');
			}
			 if (setEmailDomains.contains(acc.Website)) {
				accounts.add(acc);
			 }
		}
		return accounts; 
	}

	/**
	 * Question 23
	 * Clones and Inserts Opportunity Line Items from the original Opportunity to a list of cloned Opportunities.
	 * Adds a randomized number between 1 to 3 to the quantity of each line item.
	 * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
	 * @param Original Opportunity Id
	 * @param List of cloned Opportunity Ids
	 * 
	 * 
	 *  TR - Used sObject.clone to create a new object in memory. I don't fully understand the difference between this clone and list.clone/deepclone yet, but it looks like
	 * - using the list clone methods does not give the expected behaviour; the cloned objects create a like for like OLI list. Deep clone will create new list/new (and cloned) objects from original.
	 * - TR - sObject clone will create a new copy of a single record.
	 * - TR: POST SUBMISSION / BEFORE FEEDBACK - I slept on this question after submission as I knew that looping within a loop is not necessarily efficient. I realized on review today that I could use the enhanced loop for this scenario.
	 */
	public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
		

		// Query the original Opportunity Line Items
		// Create a list to hold the new line items
		// Loop through each cloned Opportunity Id 
		 // Generate a random number between 1 and 3 for quantity
			// Loop through each original line item
		// Clone the original line item and add the random number to the quantity
		  // Insert the new line items
		
		List<OpportunityLineItem> originalOppLineItems = [
        SELECT Id, OpportunityId, PricebookEntryId, UnitPrice, Quantity
        FROM OpportunityLineItem
        WHERE OpportunityId = :origOppId
        ]; 

		List<OpportunityLineItem> newOppLineItems = new List<OpportunityLineItem>();
		for (Integer i = 0; i < originalOppLineItems.size(); i++) {
			Integer randomnum = (Integer) (Math.floor(Math.random()) * 3) + 1;
			OpportunityLineItem OLIcopy = originalOppLineItems.get(i).clone(false, false, false, false);
			OLIcopy.OpportunityId = cloneOppIds.get(i);
			OLIcopy.Quantity = randomnum;
			newOppLineItems.add(OLIcopy);
		}
		if (!newOppLineItems.isEmpty()) {
			insert newOppLineItems;
		}
	}

	/**
	 * Question 24
	 * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
	 * @return A list of filtered Opportunity
	 * 
	 * TR - Hey teach, I might be missing something here; is this the right way to approach it or did I need to do it a different way?
	 * TR - Note to self; when I do a child to parent query (getting values through lookups), the list will (I think) get the id of the object you're looking up to, and the field you queried.
	 */
	public static List<Opportunity> getOpportunityDetailsForClosedWon() {
		List <Opportunity> opps = [SELECT Id, Name, Account.Name, Owner.Name FROM Opportunity WHERE StageName = 'Closed Won'];
		return opps;
	}

	/**
	 * Question 25
	 * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to the Contact on the associated Account with the alphabetically first first name.
	 * Example: if there are two Contacts on the Account, "Billy" and "Abby," the 'Primary_Contact__c' will be set to "Abby." (TR - ... on all closed won opps related to the account.)
	 * 
	 * TR - (THOUGHTS) I can see how this wouldn't work in the real world, as there's always a chance of contacts, who share the same first name, related to account.
	 * - I would probably have to use a combination of first name and last name alphabetically in that case.
	 * 
	 */

	public static void setPrimaryContact() {

		//BLOCK 1
		// Create a set of Account Ids from the Opportunities
		//Use the getOpportunityDetailsForClosedWon() method to get the Opportunities
		 // TR - created a list to populate results from method. This is to avoid calling the method more than once (I nearly did this later down the line and thought it would be inefficient to do so)
		// TR - loop throught each opportunity object from the list/method to collect the set of accountIds. 

		//BLOCK 2
		//TR - Created Map <Id, Id> as I wanted to only collect one contact out of multiple contacts related to the set of accountIds. It will also be the first alphabetically as it is ordered by ASC order.
		// Query the Contacts 
		// Loop through each Contact and add the Account Id and Contact to the map
		//TR - This is a loop that goes through a list that orders contacts (related to account) by Name (A-Z). Because a key/pair value can only have one unique key, the if condition checks if the key already exists in the map. -
		//- If it does, it already has the contact FOR the accountId in the map, and as it was collected by Name (ASC), we ensure that we are setting the value to be the contactId of the contact that is first alphabetically.

		//BLOCK 3
		// Loop through each Opportunity 
		// TR - The loop first aims to assign the contactId var with the accountId key value in the map. It does this by getting the current opportunity item and using its accountId in the map.get() method to return the paired contactId value.
		// TR - Then it checks if the contactId is NOT null. This ensures that the current opportunity item has an accountId in the map before it actually updates the custom contact lookup field with the already set contactId.
		// TR - I initially used a containskey() method instead in the if statement and later used the get() method to retrieve the contact id, but, on review and some investigating and help from goodolGPT, I understood this approach was better
		// - as it calls one less method and also achieves a simpler way to check for the right condition while setting the contactId for use immediately after the if statement.
		
		// Update the Opportunity primary contact from accountToContactMap
		// Update the Opportunities


		Set<Id> accountIds = new Set<Id>();
		List<Opportunity> oppsFromMethod = getOpportunityDetailsForClosedWon();
		
		//loop through opps from method to populate the accountIds SET. 
		for (Opportunity oppFromMethod : oppsFromMethod) {
			accountIds.add(oppFromMethod.AccountId);
		}

		//create map that contains accountId and Contact Id
		Map<Id,Id> accountToContactMap = new Map<Id,Id>();

		//loop through each contact retrieved from the accountIds SET. If the current contact's accountId is not in the map, put key/pair value in.
		for (Contact accountContact :[SELECT Id, AccountId FROM Contact WHERE AccountId IN :accountIds ORDER BY Name ASC]) {
			if (!accountToContactMap.containsKey(accountContact.AccountId)) {
			accountToContactMap.put(accountContact.AccountId, accountContact.Id);
			}
		}
		//loop through each opp in the list from the method using the now populated map.
		for (Opportunity opp : oppsFromMethod) {
			Id contactId = accountToContactMap.get(opp.AccountId);
		  if (contactId != null) {
		    opp.Primary_Contact__c = contactId;
		}
		}	
		update oppsFromMethod;
}
}