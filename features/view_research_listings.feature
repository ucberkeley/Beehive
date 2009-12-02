Feature: view research listings

	As a user
	I want to be able to view all research listings
	So that I can view individual listings
	
	Background:
		Given there is a "Department" named "EECS"
		And I am logged in as "james"
		And I visit /jobs
	
	Scenario: View listings
		Then I should see "Title/Description"
		
	Scenario: View individual listing		
		Given I follow "job"
		Then I should see "Faculty Sponsor"

	Scenario: Search for listings 
		Given I fill in "job" for "search_terms_query"
		And I press "Filter Results"
		Then I should see "job"
		