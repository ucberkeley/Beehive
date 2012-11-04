Feature: A Calnet user should be able to have true logout

Scenario: Log in and log out
  Given I am logged in as "764489"
  And I go to the home page
  Then I should see "Logged in as Henry Kwan"
  When I log out
  Then I should see "Log In"
  Given I am logged in as "762062"
  Then I should not see "Logged in as Henry Kwan"
  And I should see "Logged in as Edward Chin"