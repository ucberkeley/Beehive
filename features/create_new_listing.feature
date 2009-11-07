Feature: create new research listing

	As a registered user
	I want to be able to post research listings
	So that I can hire students and get student interest
	
	Background:
		Given I am logged in as "james"
		And I am on the Create Listing page
		
	Scenario: Logged in user is on create-a-listing page
		Then I should see a form called "Create a Listing"
		And I should see a button called "Submit Listing"
		
	Scenario: Submit a listing
		When I fill in the form with title "RAD Lab Research Assistant"
		And I press "Submit Listing"
		Then I should go to the Show page for the listing whose title is "RAD Lab Research Assistant"
		
	Scenario: Submit listing with requirements
		When I fill in the form with title "Uber RAD Lab Research Assistant"
		And I fill in the textbox called "tags" with "Java-proficient"
		And I add a class "CS70" with grade "A"
		And I press "Submit Listing"
		Then I should go to the Show page for the listing whose title is "Uber RAD Lab Research Assistant"