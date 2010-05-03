Feature: Elements
  In order to edit or create page elements 
  As an admin
  A admin can edit elements

  @javascript
  Scenario: Hovering over a content element
  Given the standard pages
  And I am logged in as admin
  When I go to path "/"
  And I follow "Edit" within "#hy-top"
  And I hover over the css element ".hy-el:first"
  Then I should see a css element ".hy-el-menu"

  @javascript
  Scenario: Editing a text element
  Given the standard pages
  And I am logged in as admin
  When I edit the page "/"
  And I edit the css element ".hy-el:first"
  And I fill in "" for "element[content]" within ".ui-dialog form"
  And I press "Ok" within ".ui-dialog"
  Then I should see the error "can't be blank" on the field "content"
  And the dialog should be open
  When I fill in "Test content" for "element[content]" within ".ui-dialog form"
  And I switch to the dialog tab "Generic Options"
  And I fill in "2010-02-01" for "element[display_from]" within ".ui-dialog form"
  And I fill in "2010-01-01" for "element[display_until]" within ".ui-dialog form"
  And I press "Ok" within ".ui-dialog"
  Then I should see the error "cannot be after 'Display until'. Set an earlier date/time OR remove 'Display until'" on the field "display_from"
  Then I should see the error "cannot be before 'Display from'. Set a later date/time OR remove 'Display from'" on the field "display_until"
  And the dialog should be open 
  When I fill in "" for "element[display_from]" within ".ui-dialog form"
  And I fill in "" for "element[display_until]" within ".ui-dialog form"
  And I press "Ok" within ".ui-dialog"
  Then I should see /Test content/ within css element ".hy-el"
  And the dialog should be closed
