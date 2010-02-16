Given: I am logged in as quentin

Scenario: I have created a survey with Plan A - Everything Included
	When I create a Survey named Nokia Phones which includes 20 responses for 4 Standard Questions, 3 Premium Questions, 2 Demographic Questions with Plan A 
	Then total price for survey Nokia Phones will be $340

Scenario: I have created a survey with Plan A - Extra Questions
	When I create a Survey named LCD Televisions which includes 20 responses for 5 Standard Questions, 3 Premium Questions, 2 Demographic Questions with Plan A 
	Then total price for survey LCD Televisions will be $370

Scenario: I have a created a survey with Plan A - Extra Questions and Responses
	When I create a Survey named Comparison of Android Phones and Iphones which includes 30 responses for 5 Standard Questions, 0 Premium Questions, 0 Demographic Questions with Plan A
	Then total price for survey Comparison of Android Phones and Iphones will be $235	

Scenario: I have a created a survey with Plan A - Extra Responses
	When I create a Survey named Comparison of Android Phones and Iphones which includes 30 responses for 4 Standard Questions, 3 Premium Questions, 2 Demographic Questions with Plan A
	Then total price for survey Comparison of Android Phones and Iphones will be $235