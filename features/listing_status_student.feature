Feature: A student should be able to view "open" and "filled" listings but not "inactive" ones

	As a student user
	So that I receive relevant search results when I browse listings
	I want to be able to see both "open" and "filled" positions (in case I want to contact the 
	professor about a filled position opening up in the future), but I don't want to see positions
	which are "inactive".

	Background: 
		Given I am logged in as "49538"
		And I follow "Post a Listing"
		When I fill in "Listing title" with "titletitletitle"
		And I select "Ras Bodik" from "faculty_id"
		And I fill in "Listing description" with "descriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescription"
		
	Scenario: Student sees "Open" listing and can apply
		When I select "Open" from "job_status"
		And I press "Post"
		Then I should see "Thank your for submitting a listing."
		Given I am logged in as "758752"
		And I follow "Browse Listings"
		Then I should see "titletitletitle"
		And I should see "apply for this job"
		
	Scenario: Student sees "Filled" listing and cannot apply
		When I select "Filled" from "job_status"
		And I press "Post"
		Then I should see "Thank your for submitting a listing."
		Given I am logged in as "758752"
		And I follow "Browse Listings"
    When I select "Filled" from "post_status"
    And I press "Search"
		Then I should see "titletitletitle"
		And I should not see "apply for this job"
		
	Scenario: Student does not see "Inactive" listing
		When I select "Inactive" from "job_status"
		And I press "Post"
		Then I should see "Thank your for submitting a listing."
		Given I am logged in as "758752"
		And I follow "Browse Listings"
		Then I should not see "titletitletitle"
