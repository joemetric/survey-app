Scenario: Calculating amount to be refunded for Nokia Phones survey after survey expiration
	When survey named Nokia Phones will expire when it has received 1 responses 
	Then refund amount should be $0.0 for Nokia Phones survey
	
Scenario: Calculating amount to be refunded for Comparison of Android Phones and Iphones survey after survey expiration
	When survey named Comparison of Android Phones and Iphones will expire when it has received 20 responses
	Then refund amount should be $55.0 for Comparison of Android Phones and Iphones survey
	
Scenario: Calculating amount to be refunded for LCD Televisions survey after survey expiration
	When survey named LCD Televisions will expire when it has received 15 responses
	Then refund amount should be $80.0 for LCD Televisions survey