Feature: add review for faculty
	As a registered user
	I want to be able to post reviews for specific faculty members whom I've worked for
	So that I can help other users make informed choices about their research opportunities
	
	Background:
		Given I am logged in as "james"
		And there is a review for "Armando Fox" from "person 1" with score 5
		And I am on the new Reviews page for professor "Armando Fox"
	
	Scenario: Go to add reviews page when logged in
		Then I should see a menu with choices "1,2,3,4,5"
		And I should see a textbox called "Write your review here"
		And I should see a button called "Submit review"
		
	Scenario: Submit a review
		When I select "5" from "review_score"
		And I fill in "review_text" with "Armando is an awesome prof."
		And I press "Submit review"
		Then I should go to the Reviews page for professor "Armando Fox"
		And I should see "Armando is an awesome prof."