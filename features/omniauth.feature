Feature: Use OmniAuth to support a user from any supported academic institution who wants to log in
As a non-Berkeley developer wishing to adopt ResearchMatch
So that I can easily modify the ResearchMatch source code to support login through my own academic institution
I want to be able to add other authentication systems with ease, using the OmniAuth ruby gem.

Scenario: Log in and log out as different user with OmniAuth as backend.
  Given I am signed in with provider "cas" as Justin
  And I go to the home page
  Then I should see "Logged in as Justin Vu Nguyen"
  When I log out
  Then I should see "Log In"
  Given I am signed in with provider "cas" as Justina
  Then I should not see "Logged in as Justin Vu Nguyen"
  And I should see "Logged in as Justina Nguyen"
