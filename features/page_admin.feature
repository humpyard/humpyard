Feature: Pages Admin
  In order to manage pages
  An admin user visits the backend

  Scenario: Page Admin 
  Given the standard pages
    And I am logged in as admin
  When I go to path "/admin/pages"
  Then I should see "CMS Admin"
  # 
  # Scenario: Page Admin 
  # Given the standard pages
  #   And I am logged in as admin
  # When I go to path "/admin/pages/42"
  # Then I should get a status code of 200
  #   And I should see the page with id 42
  # 
  # Scenario: Presence of admin adornments
  # Given the standard pages
  # And I am logged in as admin
  # When I go to path "/"
  # Then I should see a css element "#hy-top" 
  # And I should see a button named "Edit" within "#hy-top"
  # And I should see a button named "Logout" within "#hy-top"
  # 
  # @javascript
  # Scenario: Enter edit mode
  # Given the standard pages
  # And I am logged in as admin
  # When I go to path "/"
  # And I click on "Edit" within "#hy-top"
  # Then I should see a css element "#hy-bottom"
  # And the css element "#hy-bottom" should be within the window boundaries
  # 
  # @javascript
  # Scenario: Hovering over a content element
  # Given the standard pages
  # And I am logged in as admin
  # When I go to path "/"
  # And I click on "Edit" within "#hy-top"
  # And I hover over the css element ".hy-el:first"
  # Then I should see a css element ".hy-el-menu"

  @javascript
  Scenario: Editing a text element
  Given the standard pages
  And I am logged in as admin
  When I edit the page "/"
  And I edit the css element ".hy-el:first"
  And I change the content to "Test content"
  And I click "Ok" on the dialog
  Then I should see /Test content/ within css element ".hy-el"
  
