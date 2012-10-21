Feature: Use tags and classes to search for listings

	As a user
	I want to search for research listings by class or tag
	So that I can find ones relevant to my interests/experience
	
	Background:
		Given there is a research listing with title "Uber RAD Lab Research Assistant" with class "CS70" grade "A" tag "Java proficient"
		And there is a research listing with title "Okay RAD Lab Research Assistant" with class "CS70" grade "B" tag "Scheme proficient"
		And there is a research listing with title "Any RAD Lab Research Assistant" with class "CS61A" grade "A" tag "Java proficient"
		And there is a research listing with title "Babak's apprentice" with class "CS70" grade "A" class "EE20N" grade "A" tag "FORTRAN proficient" tag "Java proficient"
		And there is a user named "joe" class "CS70" grade "B"
		And there is a user named "superjoe" class "CS70" grade "A" class "EE20N" grade "A" class "CS61A" grade "A"
		And I am on the listings search page

	Scenario: Find listing by class
		Given I press "Classes"
		 And I fill in "class" with "CS70"
		 And I press "Search"
		Then I should see "Uber RAD Lab Research Assistant"
		 And I should see "Okay RAD Lab Research Assistant"
		 And I should see "Babak's apprentice"
		 And I should not see "Any RAD Lab Research Assistant"
	
	Scenario: Find listing by class by grade
		Given I press "Classes"
		 And I am logged in as "joe"
		 And I press "Search by my profile"
		Then I should see "Okay RAD Lab Research Assistant" first
		 And I should see "Uber RAD Lab Research Assistant"
		 And I should not see "Any RAD Lab Research Assistant"
		 And I should not see "Babak's apprentice"
		
	Scenario: Find listing by class by tag
		Given I press "Tags"
		 And I fill in "tags" with "Java proficient"
		 And I press "Search"
		Then I should see "Uber RAD Lab Research Assistant"
		 And I should see "Any RAD Lab Research Assistant"
		 And I should see "Babak's apprentice"
		 And I should see "Okay RAD Lab Research Assistant" 4th	#last because it doesn't have the java tag
		
	Scenario: Find listing by multiple classes
		Given I am logged in as "superjoe"
		 And I press "Classes"
		 And I press "Search by my profile"
		Then I should see "Uber RAD Lab Research Assistant"
		 And I should see "Okay RAD Lab Research Assistant"
		 And I should see "Any RAD Lab Research Assistant"
		 And I should see "Babak's apprentice"