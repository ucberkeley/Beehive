Feature: create new research listing

	As a registered user
	I want to be able to post research listings
	So that I can hire students and get student interest
	
	Background:
		Given I am logged in as "james"
		And I visit /jobs/new
		
	Scenario: Logged in user is on create-a-listing page
		Then I should see "New Job"
		And I should see a <form> containing a textfield: title, textfield: desc, textfield: Category(ies), textfield: "Required courses", textfield: "Desired programming languages"
		
	Scenario: Submit a listing
		When I fill in the following:
			| Desc				|	Write tricky while loops	|
			| Exp date			|	3000-1-1					|
			| Faculty sponsor	|	Armando Fox					|
		And I press "Create"
		Then I should go to the Show page for the listing whose title is "RAD Lab Research Assistant"
		
	Scenario: Submit listing with requirements
		When I fill in the form with title "Uber RAD Lab Research Assistant"
		And I fill in the textbox called "tags" with "Java-proficient"
		And I add a class "CS70" with grade "A"
		And I press "Submit Listing"
		Then I should go to the Show page for the listing whose title is "Uber RAD Lab Research Assistant"