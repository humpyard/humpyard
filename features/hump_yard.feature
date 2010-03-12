Feature: something something
  In order to something something
  A user something something
  something something something

  Background:
	Given the following page records 
	 | title       | name    |
	 | My Homepage | index   |
	 | Contact     | contact |
	 | Imprint     | imprint |


  Scenario: View Index
    When I go to path "/"
    Then I should see "My Homepage"

  Scenario: View Index
    When I go to path "/en/index.html"
    Then I should see "My Homepage"

  Scenario: Miss Page
	When I go to path "/en/foo.html"
	Then I should see "not found"
