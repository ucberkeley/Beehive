Feature: A faculty user should be able to mark a listing is either "open", "filled", or "inactive"

	As a faculty user
	So that my listings are better organized and their availabilities are accurately reflected
	I want to be able to manually mark each listing as any of the following: "open" means I am
	currently looking to hire. "filled" means I have already hired a student and the position
	is filled. "inactive" means that there is nobody currently filling that position nor am I
	looking for someone to do so, but for archival purposes I don't want to delete it yet.

	Background: 
		Given I am logged in as "49538"
		And I follow "Post a Listing"
		When I fill in "Listing title" with "titletitletitle"
		And I select "Ras Bodik" from "faculty_id"
		And I fill in "Listing description" with "descriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescription"
		
	Scenario: Mark listing as "Open"
		When I select "Open" from "job_status"
		And I press "Post"
		Then I should see "Thank your for submitting a listing."
		Then I should see "Open" after "Listing Status:"

	Scenario: Mark listing as "Filled"
		When I select "Filled" from "job_status"
		And I press "Post"
		Then I should see "Thank your for submitting a listing."
		Then I should see "Filled" after "Listing Status:"
	
	Scenario: Mark listing as "Inactive"
		When I select "Inactive" from "job_status"
		And I press "Post"
		Then I should see "Thank your for submitting a listing."
		Then I should see "Inactive" after "Listing Status:"