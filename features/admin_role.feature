Feature: A faculty user should be able to add owners to a listing.

  As a faculty user
  So that I can allocate listing management to grad students / other faculty
  I want to be able to add owners to a listing with permissions equal to mine (added
  owners can accept applicants and edit the listing following the same steps as the
  original owner)

  Scenario: Admin should be able to edit someone else's posting.
    Given I am signed in with provider "cas" as Fox
    And I go to the home page
    Then I should see "Logged in as Armando Fox"
    And I follow "Post a Listing"
    When I fill in "Listing title" with "titletitletitle"
    And I select "Armando Fox" from "faculty_id"
    And I fill in "Listing description" with "descriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescription"
    And I press "Post"
    Then I should see "Thank your for submitting a listing."
    When I log out

    Given I am signed in as a admin
    When I follow "Browse Listings"
    Then I should see "titletitletitle"
    When I follow "titletitletitle"
    And I follow "[edit]"
    And I select "Inactive" from "job_status"
    And I press "Update"
    Then I should see "Listing was successfully updated."
    When I log out

    Given I am logged in as "758752"
    When I follow "Browse Listings"
    Then I should not see "titletitletitle"

  Scenario: Admin should be able to change a user's role.
    Given I am signed in with provider "cas" as Justin
    When I log out
    Given I am signed in as a admin
    When I follow "Admin"
    And I select "Justin Vu Nguyen - Student" from "user_role"
    And I select "Professor" from "user_role_new"
    And I press "Update"
    Then I should see "User role successfully updated."
    When I log out

    Given I am signed in with provider "cas" as Justin
    And I follow "Post a Listing"
    When I fill in "Listing title" with "titletitletitle"
    And I select "Armando Fox" from "faculty_id"
    And I fill in "Listing description" with "descriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescription"
    And I press "Post"
    Then I should see "Thank your for submitting a listing."
