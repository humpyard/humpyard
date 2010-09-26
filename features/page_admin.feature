Feature: Pages Admin
  In order to manage pages
  An admin user visits the backend

  Scenario: Page Admin without auth
    Given the standard pages
    And I am not logged in
    When I go to path "/admin/pages"
    Then I should see "You are not authorized to access this page."

  Scenario: Page Admin 
    Given the standard pages
    And I am logged in as admin
    When I go to path "/admin/pages"
    Then I should see "Manage Pages"
    When I go to path "/admin/pages/42"
    Then I should get a status code of 200
    And I should see the page with id 42
  
  @javascript
  Scenario: Presence of admin adornments
    Given the standard pages
    And I am logged in as admin
    When I go to path "/"
    Then I should see a css element "#hy-top" 
    And I should see a button named "Edit" within "#hy-top"
    And I should see a button named "Logout" within "#hy-top"
    When I follow "Edit" within "#hy-top"
    Then I should see a css element "#hy-bottom"
    And the css element "#hy-bottom" should be within the window boundaries
  


  

