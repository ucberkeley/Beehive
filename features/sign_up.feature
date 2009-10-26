Feature: sign up for an account
	As an unregistered user
	I want to be able to sign up for an account
	So I can view and post research listings and professor reviews
	
	Scenario: Anonymous user can start creating an account
		Given I am an anonymous user
		When I go to /signup
		Then I should be on the "users/new" page
		And I should see a <form> containing a textfield: Login, textfield: Email, password: Password, password: 'Confirm Password', submit: 'Sign up'
		
	Scenario: Anonymous user can't post research listings
		Given I am an anonymous user
		And I am on the Show page for a listing
		Then I should not see a button called "Reply to Listing"		