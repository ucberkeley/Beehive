Feature: An administrator should be able to upload a CSV as an authorization system
  
  As an admin
  So that I can add one or more CSV's as a substitute for a full fledged authorization system.
  I want to be able to upload user data in a csv format with columns: name, user role, login id. New users who login will be authorized based on the data supplied in the csv, and the csv will override any settings for existing users.

  Scenario: Change multiple users' role via csv.
    Given I am signed in with provider "cas" as Justin
    Then I should not see "Post a Listing"
    When I log out

    Given I am signed in with provider "cas" as Justina
    When I set "1005472" as admin
    When I follow "Dashboard"
    When I follow "Admin" 
    When I upload a file with valid data
    Then I should see "CSV successfully uploaded!"
    When I log out

    Given I am signed in with provider "cas" as Justin
    And I follow "Post a Listing"
    When I fill in "Listing title" with "titletitletitle"
    And I select "Armando Fox" from "faculty_id"
    And I fill in "Listing description" with "descriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescription"
    And I press "Post"
    Then I should see "Thank your for submitting a listing."

  Scenario: Uploading a file with bad data
    Given I am signed in with provider "cas" as Justina
    When I set "1005472" as admin
    When I follow "Dashboard"
    When I follow "Admin" 
    When I upload a file with bad data
    Then I should see "The following error(s) occurred with the CSV upload"
