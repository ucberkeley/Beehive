Feature: A Calnet user should be able to have true logout

Scenario: Log in and log out
  Given I am logged in as "758752"
  And I go to the home page
  Then I should see "Logged in as Justin Vu Nguyen"
  When I log out
  Then I should see "Log In"
  Given I am logged in as "1005472"
  Then I should not see "Logged in as Justin Vu Nguyen"
  And I should see "Logged in as Justina Nguyen"