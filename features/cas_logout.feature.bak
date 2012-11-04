Feature: A Calnet user should be able to have true logout

  As a Calnet user
  So that personal information remains private and secure
  I want to be able to have a true logout from the CAS service, so that I can login as a different user under the CAS system

  Background:
    Given I am logged in as "james"
    And I visit /dashboard

  Scenario: Single Step Logout
    Given I follow "Logout"
    Then I should see "Logged out successfully" 

  Scenario: Dual Step Logout from CAS
    Given I follow "Logout"
    Then I should see "Click Here to logout of CAS"
    Given I follow "Click Here"
    Then I should be redirected to the CAS logout page
    