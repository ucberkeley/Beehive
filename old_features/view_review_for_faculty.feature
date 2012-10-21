Feature: view reviews for faculty
	As a registered user
	I want to be able to view reviews posted by others about a specific professor
	So that I can decide whether to apply for his/her listing
	
	Background:
		Given I am logged in as "james"
		And there is a review for "Armando Fox" from "person 1" with score 5
		And there is an anonymous review for "Armando Fox" from "person 2" with score 4
		And I am on the "Browse Listings" page
	
	Scenario: browse list of professors with ratings
		Then I should see professor listing "Armando Fox" with rating 4.5
		And I should see a button called "Read reviews"
		
	Scenario: read reviews about a professor
		When I click the button called "Read reviews"
		Then I should go to the Reviews page for professor "Armando Fox"
		And I should see a review from "person 1" with score 5
		And I should see a review from "Anonymous" with score 4
		And I should see a button called "Post your review"