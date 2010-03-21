Feature: Pages
  In order to access page content
  A user views pages

  Scenario: Page Admin 
	Given the standard pages
    When I go to path "/admin/pages"
    Then I should see "CMS Admin"

  Scenario: Page Admin 
	Given the standard pages
    When I go to path "/admin/pages/42"
    Then I should get a status code of 200
	And I should see the page with id 42
