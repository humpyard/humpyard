Feature: Page Routing
  In order to access pages
  A user enters a pretty URL
  and gets the corrosponding page

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
	
  Scenario: View Index with custom www prefix
	Given the www prefix is "cms/:locale/"
	When I go to path "/cms/en/index.html"
	Then I should see "My Homepage"

  Scenario: Miss Index without custom www prefix
	Given the www prefix is "cms/:locale/"
	When I go to path "/en/index.html"
	Then I should see "Routing Error"
	
  Scenario: View Index with default www prefix
	Given the www prefix is ":default"
    When I go to path "/en/index.html"
    Then I should see "My Homepage"
