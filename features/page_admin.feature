Feature: Pages Admin
  In order to manage pages
  An admin user visits the backend

  Scenario: Page Admin 
  Given the standard pages
    And I am logged in as admin
  When I go to path "/admin/pages"
  Then I should see "Humpyard::Pages"
  
  Scenario: Page Admin 
  Given the standard pages
    And I am logged in as admin
  When I go to path "/admin/pages/42"
  Then I should get a status code of 200
    And I should see the page with id 42
  
  Scenario: Presence of admin adornments
  Given the standard pages
  And I am logged in as admin
  When I go to path "/"
  Then I should see a css element "#hy-top" 
  And I should see a button named "Edit" within "#hy-top"
  And I should see a button named "Logout" within "#hy-top"
  
  @javascript
  Scenario: Enter edit mode
  Given the standard pages
  And I am logged in as admin
  When I go to path "/"
  And I click on "Edit" within "#hy-top"
  Then I should see a css element "#hy-bottom"
  And the css element "#hy-bottom" should be within the window boundaries
  
  @javascript
  Scenario: Hovering over a content element
  Given the standard pages
  And I am logged in as admin
  When I go to path "/"
  And I click on "Edit" within "#hy-top"
  And I hover over the css element ".hy-el:first"
  Then I should see a css element ".hy-el-menu"

  @javascript
  Scenario: Editing a text element
  Given the standard pages
  And I am logged in as admin
  When I edit the page "/"
  And I edit the css element ".hy-el:first"
  And I change the field "content" to "Test content"
  And I click "Ok" on the dialog
  Then I should see /Test content/ within css element ".hy-el"
  And the dialog should be closed

  @javascript
  Scenario: Editing a text element with validation errors 1
  Given the standard pages
  And I am logged in as admin
  When I edit the page "/"
  And I edit the css element ".hy-el:first"
  And I change the field "content" to ""
  And I click "Ok" on the dialog
  Then I should see the error "can't be blank" on the field "content"
  And the dialog should be open

  @javascript
  Scenario: Editing a text element with validation errors 2
  Given the standard pages
  And I am logged in as admin
  When I edit the page "/"
  And I edit the css element ".hy-el:first"
  And I switch to the dialog tab "Generic Options"
  And I change the field "display_from" to "2010-02-01"
  And I change the field "display_until" to "2010-01-01"
  And I click "Ok" on the dialog
  Then I should see the error "cannot be after 'Display until'. Set an earlier date/time OR remove 'Display until'" on the field "display_from"
  Then I should see the error "cannot be before 'Display from'. Set a later date/time OR remove 'Display from'" on the field "display_until"
  And the dialog should be open

