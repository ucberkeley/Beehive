Feature: post new research listing

  As a registered user
  I want to be able to post research listings
  So that I can hire students and obtain student interest

  Background: Logged in
    Given I am logged in as "james"
		And there is a "Department" named "EECS"
		And there is a "Faculty" named "Armando Fox"
		And I visit /jobs/new

  Scenario: Logged-in user is on create page
    Given I am on the create listing page
    Then I should see "Post New Research Listing"
