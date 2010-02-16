Scenario Outline: Calculating amount to be refunded for a survey using the Default Package after survey expiration
	Given I have created a survey using the <Package Type> Package
	And I have used <Standard Questions> Standard Questions, <Premium Questions> Premium Questions, <Standard Demographic Restrictions> Standard Demographic Restrictions, and <Premium Demographic Restrictions> Premium Demographic Restrictions
	When the survey expires with <Responses> responses
	Then the refund amount should be <Refund Amount> for the survey
	
Scenarios:
	|Standard Questions|Premium Questions|Standard Demographic Restrictions|Premium Demographic Restrictions|Responses|Refund Amount|Package Type|
	| 4 | 3 | 2 | 1 | 20 | 0.0  | Default |
	| 4 | 3 | 2 | 1 | 0  | 50.0 | Default |
