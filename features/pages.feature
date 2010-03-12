Feature: Page Admin
  In order to access admin pages
  A admin edits pages

  Background:
    Given the following page records 
    | title       | name    |
    | My Homepage | index   |
    | Contact     | contact |
    | Imprint     | imprint |

  Scenario: Page Admin 
    When I go to path "/admin/pages"
    Then I should see "CMS Admin"


