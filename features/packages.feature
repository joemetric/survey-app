Background I am logged in as Admin

Scenario: Create a Package and Save it
	Given I am visiting the Pricing Administration Page
	And Pricing Administration Page should have link as Create New Package
	
	When I click on Create New Package
	Then It should display Create New Package Form
	
	When I submit package form with Name: Premium, Code: PREMIUM700
	Then It should save package details Name: Premium, Code: PREMIUM700
	And Redirect to Pricing Administration Page
	
	When I submit package form with Name: Pre, Code: PREMIUM 700
	Then It should not save package details Name: Pre, Code: PREMIUM 700
	
	When I submit package form with Name: P, Code: 7
	Then It should not save package details Name: P, Code: 7