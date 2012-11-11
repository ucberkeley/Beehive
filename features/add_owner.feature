Feature: A faculty user should be able to add owners to a listing.

  As a faculty user
  So that I can allocate listing management to grad students / other faculty
  I want to be able to add owners to a listing with permissions equal to mine (added
  owners can accept applicants and edit the listing following the same steps as the
  original owner)

  Background: Create a posting and add a faculty co-owner.
    Given I am signed in with provider "cas" as Fox
    And I go to the home page
    Then I should see "Logged in as Armando Fox"
    And I follow "Post a Listing"
    When I fill in "Listing title" with "titletitletitle"
    And I select "Armando Fox" from "faculty_id"
    And I select "Ras Bodik" from "co_owners"
    And I fill in "Listing description" with "descriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescription"
    And I press "Post"
    Then I should see "Thank your for submitting a listing."
    When I log out

  Scenario: Added owner should be able to accept applicants.
    Given I am logged in as "758752"
    When I follow "Browse Listings"
    Then I should see "titletitletitle"
    When I follow "titletitletitle"
    And I follow "[apply for this job]"
    And I fill in "applic[message]" with "message"
    And I press "Submit"
    Then I should see "Application sent"
    When I log out

    Given I am signed in with provider "cas" as Bodik
    And I go to the home page
    Then I should see "Logged in as Ras Bodik"
    When I follow "Browse Listings"
    Then I should see "titletitletitle"
    When I follow "titletitletitle"
    And I follow "Justin Vu Nguyen"
    And I press "Accept this Applicant"
    And I follow "Dashboard"
    Then I should see "Accepted Students: Justin Vu Nguyen"

  Scenario: Added owner should be able to edit the listing.
    Given I am signed in with provider "cas" as Bodik
    And I go to the home page
    Then I should see "Logged in as Ras Bodik"
    When I follow "Browse Listings"
    Then I should see "titletitletitle"
    When I follow "titletitletitle"
    And I follow "[edit]"
    And I select "Filled" from "job_status"
    And I press "Update"
    Then I should see "Listing was successfully updated."
    When I log out

    Given I am logged in as "758752"
    When I follow "Browse Listings"
    Then I should not see "titletitletitle"
    When I select "Filled" from "post_status"
    And I press "Search"
    Then I should see "titletitletitle"
    And I should not see "apply for this job"
