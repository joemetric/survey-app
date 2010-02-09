Background I am logged in as aaron

Scenario: Create Survey and Pay for it
	Given  I am visiting the Create Survey Page
	When I will create new survey titled Comparison of IPhone and Android Phones
	Then survey payment status should be incomplete
	And I am shown Paypal Website page to make the payment
	Then survey payment status should be authorized
	When I make payment on Paypal
	Then survey payment status should be paid

Scenario: Create Survey and Do not Pay for it	
	Given I am visiting the Create Survey Page
	When I will create new survey titled Comparison of IPhone and Android Phones
	Then survey payment status should be incomplete
	And I am shown Paypal Website page to make the payment
	Then survey payment status should be authorized
	When I do not make payment on Paypal and return to the site
	Then survey payment status should be cancelled
	
