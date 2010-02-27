Background I am logged in as Admin

Scenario: Create an Organization and Save it
	Given I am visiting the Charity Organization Administration Page
	And Charity Organization Administration Page should have button as Create a New Organization
	
	When I click on Create a New Organization
	Then It should display Create a New Organization Form
	
	When I submit organization form with Name: Test Organization, Address1: Test Address, City1: Test City, State1: CA, ZipCode1: 12345, Phone: 1234567890, Email: testorg@orgdomain.com, Tax Status: Approved, Tax ID: 12321 
	Then It should save package details Name: Test Organization, Address1: Test Address, City1: Test City, State1: CA, ZipCode1: 12345, Phone: 1234567890, Email: testorg@orgdomain.com, Tax Status: Approved, Tax ID: 12321
	And Redirect to Pricing Administration Page
	
	When I submit package form with Name: , Address1: , City1: , State1: , ZipCode1: , Phone: , Email: , Tax Status: , Tax ID: 
	Then It should not save package details Name: , Address1: , City1: , State1: , ZipCode1: , Phone: , Email: , Tax Status: , Tax ID:
	
	When I submit package form with Name: Test Organization, Address1: Test Address, City1: Test City, State1: CA, ZipCode1: sdfasdas, Phone: 12233234567890, Email: testorgATorgdomainDOTcom, Tax Status: Approved, Tax ID: charbutneedint
	Then It should not save package details Name: Test Organization, Address1: Test Address, City1: Test City, State1: CA, ZipCode1: sdfasdas, Phone: 12233234567890, Email: testorgATorgdomainDOTcom, Tax Status: Approved, Tax ID: charbutneedint