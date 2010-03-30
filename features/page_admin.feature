Feature: Pages Admin
  In order to manage pages
  An admin user visits the backend

  Scenario: Page Admin 
  Given the standard pages
    And I am logged in as admin
  When I go to path "/admin/pages"
  Then I should see "CMS Admin"

  Scenario: Page Admin 
  Given the standard pages
    And I am logged in as admin
  When I go to path "/admin/pages/42"
  Then I should get a status code of 200
    And I should see the page with id 42
