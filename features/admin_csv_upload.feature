Feature: An administrator should be able to upload a CSV as an authorization system
  
  As an admin
  So that I can add one or more CSV's as a substitute for a full fledged authorization system.
  I want to be able to upload user data in a csv format with columns: name, user role, department, user id. New users who login will be authorized based on the data supplied in the csv, and the csv will override any settings for existing users.

  Scenario: Change multiple users' role via csv.
    Given I am signed in as a admin
    When I follow "Admin" 
    When I upload a file with valid data
    And I should see "users uploaded successfully."

    Given I am signed in with provider "cas" as Justin
    And I follow "Post a Listing"
    When I fill in "Listing title" with "titletitletitle"
    And I select "Armando Fox" from "faculty_id"
    And I fill in "Listing description" with "descriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescription"
    And I press "Post"
    Then I should see "Thank your for submitting a listing."

  Scenario: Uploading a malformed file
    Given I am signed in as a admin
    When I follow "Admin" 
    When I upload a malformed file
    And I should see "bad csv. users could not be uploaded."
