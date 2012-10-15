Feature: View hired students for a position

	As a faculty user
	So that I can check up on students I have hired and have a log for that given position
	I want to be able to see which students I have hired for a position and easily access these records.

	Background:
		Given there is a "Department" named "EECS"
		And I am logged in as "james"
		And I visit /dashboard

	Scenario: View hired students
		Then I should see "Hired students:"

	Scenario: View hiring history for a particular listing
		Given I follow "Listing #1"
		Then I should see "Date Hired"
		And I should see "Date End"
		And I should see "Name"
		And I should see "Louis Reasoner"
		