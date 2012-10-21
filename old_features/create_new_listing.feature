Feature: create new research listing

	As a registered user
	I want to be able to post research listings
	So that I can hire students and get student interest
	
	Background:
		Given I am logged in as "james"
		And there is a "Department" named "EECS"
		And there is a "Faculty" named "Armando Fox"
		And I visit /jobs/new
		
	Scenario: Logged in user is on create-a-listing page
		Then I should see "New Job"
		And I should see a <form> containing a textfield: "Job Title", textfield: "Job Description", textfield: "Category(ies)", textfield: "Required courses", textfield: "Desired Programming Languages"
		
	Scenario: Submit a listing
		When I fill in the following:
			| Job Title			|	RAD Lab Research Assistant	|
			| Job Description	|	Write tricky while loops	|
		And I select "2014-1-1" as the "Expiration Time of this Listing" date and time
		And I select "Armando Fox" from "faculty_name"
		And I press "Create"
		Then I should go to the Show page for the listing whose title is "RAD Lab Research Assistant"
		
	Scenario: Submit listing with requirements
		When I fill in the following:
			|	Job Title		|	Uber RAD Lab Research Assistant	|
			|	Job Description	|	Write super tricky for loops	|
			|	category_name	|	fun,rewarding					|
			|	proglang_name	|	Ruby,Java						|
		And I select "2014-1-1" as the "Expiration Time of this Listing" date and time
		And I select "Armando Fox" from "faculty_name"
		And I press "Create"
		Then I should go to the Show page for the listing whose title is "Uber RAD Lab Research Assistant"