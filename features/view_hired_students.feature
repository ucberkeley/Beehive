Feature: View hired students for a position

	As a faculty user
	So that I can check up on students I have hired and have a log for that given position
	I want to be able to see which students I have hired for a position and easily access these records.

	Scenario: View hired students
		Given I am logged in as "49538"
		And I follow "Post a Listing"
		When I fill in "Listing title" with "titletitletitle"
		And I select "Ras Bodik" from "faculty_id"
		And I fill in "Listing description" with "descriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescription"
		And I press "Post"
		Then I should see "Thank your for submitting a listing."
		When I log out
		Given I am logged in as "759170"
		When I follow "Browse Listings"
		Then I should see "titletitletitle"
		When I follow "titletitletitle"
		And I follow "[apply for this job]"
		And I fill in "applic[message]" with "message"
		And I press "Submit"
		Then I should see "Application sent"
		When I log out
		Given I am logged in as "49538"
		When I follow "Browse Listings"
		Then I should see "titletitletitle"
		When I follow "titletitletitle"
		And I follow "Jeffrey Tsui"
		And I press "Accept this Applicant"
		And I follow "Dashboard"
		Then I should see "Accepted Students: Jeffrey Tsui"
