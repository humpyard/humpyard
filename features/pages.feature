Feature: Pages
  In order to access page content
  A user views pages

  Scenario: Localized Content in English
    Given the standard pages
    When I go to path "/en/index.html"
    Then I should see "My Homepage" within "/html/head/title"
    And I should see "This is some great text!"
    And I should see "This is text inside a container"

  Scenario: Localized Content in German
    Given the standard pages
    And the configured locales is "en,de"
    When I go to path "/de/index.html"
    Then I should see "Meine Startseite" within "/html/head/title"
    And I should see "Dies ist ein super Text!"
    And I should see "Dies ist ein Text in einem Container"  
  
  

#  Scenario: Debug Content in German
#    Given the standard pages
#    And the configured locales is "en,de"
#    When I go to path "/de/index.html"
#    Then put me the raw result





