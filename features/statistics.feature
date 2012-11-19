Feature: A user should be able to see ResearchMatch statistics.

  As a user
  So that I can view the usage of ResearchMatch.
  I want to be able to see statistics including: how many undergrads were
  within the last month? What are the most desirable courses? What are the
  most desirable programming languages?

  Scenario: View statistics
    Given I am signed in with provider "cas" as Fox
    And I go to the home page
    Then I should see "Logged in as Armando Fox"
    And I follow "Post a Listing"
    When I fill in "Listing title" with "titletitletitle"
    And I select "Ras Bodik" from "faculty_id"
    And I fill in "Listing description" with "descriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescription"
    And I fill in "course_name" with "CS61A, CS61B"
    And I fill in "proglang_name" with "Python, Java"
    And I press "Post"
    Then I should see "Thank your for submitting a listing."
    And I follow "Post a Listing"
    When I fill in "Listing title" with "titletitletitle2"
    And I select "Ras Bodik" from "faculty_id"
    And I fill in "Listing description" with "2descriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescription"
    And I fill in "course_name" with "CS61B"
    And I fill in "proglang_name" with "Java"
    And I press "Post"
    Then I should see "Thank your for submitting a listing."
    And I follow "Statistics" 
    Then I should see "Number of applications accepted this month 0"
    And I should see "Number of active jobs 2"
    And I should see "Total watches 0"
    When I log out
    
    Given I am logged in as "758752"
    When I follow "Browse Listings"
    Then I should see "titletitletitle"
    When I follow "titletitletitle"
    And I follow "[watch]"
    And I follow "[apply for this job]"
    And I fill in "applic[message]" with "message"
    And I press "Submit"
    Then I should see "Application sent"
    When I log out

    Given I am signed in with provider "cas" as Fox
    And I go to the home page
    Then I should see "Logged in as Armando Fox"
    When I follow "Browse Listings"
    Then I should see "titletitletitle"
    When I follow "titletitletitle"
    And I follow "Justin Vu Nguyen"
    And I press "Accept this Applicant"
    And I follow "Statistics"
    Then I should see "Number of applications accepted this month 1"
    And I should see "Most desired courses CS61B, CS61A"
    And I should see "Most desired programming languages Java, Python"
    And I should see "Total watches 1"

