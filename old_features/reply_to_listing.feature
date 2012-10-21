Feature: reply to a listing
	As a registered user
	I want to be able to contact the listing poster after viewing their listing
	So that I can obtain a research position
	
	Scenario: Reply to listing
		Given I am on the Show page for a listing
		And I am logged in
		Then I should see a button called "Reply to Listing"
		
	Scenario: Form to contact poster
		Given I am on the page to contact the poster of a listing
		And I fill in the form called "Contact User"
		And I press the button called "Send"
		Then I should see "Message Sent"