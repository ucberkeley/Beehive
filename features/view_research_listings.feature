Feature: view research listings

	As a user
	I want to be able to view all research listings
	So that I can view individual listings
	
	Scenario: View listings
		Given I am on the home page
		And I press "Browse"
		Then I should see a list of listings
		
	Scenario: View individual listing
		Given I am on the listings page
		And I press "Details" for the first listing in the list
		Then I should go to the Show page for that listing

	Scenario: Search for listings by class
		Given I am on the listings search page
		And I press "Classes"
		Then I should see the "Search by class" form
		
	Scenario: Search for listings by tag
		Given I am on the listings search page
		And I press "Tags"
		Then I should see the "Search by tags" form