Feature: A faculty user should be able to see hiring analytics.

  As a faculty user
  So that I can study the pattern of undergraduate research hires.
  I want to be able to see hiring analytics including, how many undergrads were
  hired per month? Average length of time an undergrad stays in a position? 
  For those how have left the position, was it because the job was completed, the
  student graduated, the student was fired, or some other reason?

  Scenario: View hiring analytics
    Given I am signed in with provider "cas" as Fox
    And I go to the home page
    Then I should see "Logged in as Armando Fox"
    And I follow "Post a Listing"
    When I fill in "Listing title" with "titletitletitle"
    And I select "Ras Bodik" from "faculty_id"
    And I fill in "Listing description" with "descriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescription"
    And I press "Post"
    Then I should see "Thank your for submitting a listing."
    And I follow Dashboard
    Then I should see "students hired this month: 0"
    And I should see "average duration per position: N/A"
    And I should see "reason for leaving: (completed N/A) (graduated N/A) (fired N/A) (other N/A)"
    When I log out
    
    Given I am logged in as "758752"
    When I follow "Browse Listings"
    Then I should see "titletitletitle"
    When I follow "titletitletitle"
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
    And I follow "Dashboard"
    Then I should see "students hired this month: 1"
    And I should see "average duration per position: N/A"
    And I should see "reason for leaving: (completed N/A) (graduated N/A) (fired N/A) (other N/A)"
    And I follow "Justin Vu Nguyen"
    And I press "Completed"
    And I follow "Dashboard"
    Then I should see "students hired this month: 1"
    And I should not see "average duration per position: N/A"
    And I should see "reason for leaving: (completed 100%) (graduated 0%) (fired 0%) (other 0%)"
