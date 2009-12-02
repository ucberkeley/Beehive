Feature: sign up for an account
	As an unregistered user
	I want to be able to sign up for an account
	So I can view and post research listings and professor reviews
	
	Scenario: Anonymous user can start creating an account as a student or gsi
		Given I am an anonymous user
		When I visit /signup		
		And I choose "user_is_faculty"
		Then I should see a <form> containing a textfield: 'Full Name', textfield: 'Student email', password: Password, password: 'Confirm Password', submit: 'Submit'

	Scenario: Anonymous user can start creating an account as a faculty member
		Given I am an anonymous user
		When I visit /signup		
		And I choose "Faculty"
		Then I should see a <form> containing a select: 'Faculty Member', password: Password, password: 'Confirm Password', submit: 'Submit'
		
	Scenario: Anonymous user can't post research listings
		Given I am an anonymous user
		And I visit /jobs/new
		Then I should be visiting /session/new