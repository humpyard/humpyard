Feature: Page Admin
  In order to access admin pages
  A admin edits pages

  Scenario: Localized Content in English
    Given the standard pages
	When I go to path "/en/index.html"
	Then I should see "My Homepage" within "/html/head/title"
	And I should see "This is some great text!"

  Scenario: Localized Content in German
    Given the standard pages
	And the configured locales is "en,de"
	When I go to path "/de/index.html"
	Then I should see "Meine Startseite" within "/html/head/title"
	And I should see "Dies ist ein super Text!"
	
  Scenario: Localized Content in English
    Given the standard pages
	When I go to path "/en/index.html"
	Then I should see "My Homepage" within "/html/head/title"
	And I should see "This is some great text!"

  Scenario: Localized Content in German
    Given the standard pages
	And the configured locales is "en,de"
	When I go to path "/de/index.html"
	Then I should see "Meine Startseite" within "/html/head/title"
	And I should see "Dies ist ein super Text!"

  Scenario: Localized Content in English
    Given the standard pages
	When I go to path "/en/index.html"
	Then I should see "My Homepage" within "/html/head/title"
	And I should see "This is some great text!"

  Scenario: Localized Content in German
    Given the standard pages
	And the configured locales is "en,de"
	When I go to path "/de/index.html"
	Then I should see "Meine Startseite" within "/html/head/title"
	And I should see "Dies ist ein super Text!"

  Scenario: Localized Content in English
    Given the standard pages
	When I go to path "/en/index.html"
	Then I should see "My Homepage" within "/html/head/title"
	And I should see "This is some great text!"

  Scenario: Localized Content in German
    Given the standard pages
	And the configured locales is "en,de"
	When I go to path "/de/index.html"
	Then I should see "Meine Startseite" within "/html/head/title"
	And I should see "Dies ist ein super Text!"

  Scenario: Localized Content in English
    Given the standard pages
	When I go to path "/en/index.html"
	Then I should see "My Homepage" within "/html/head/title"
	And I should see "This is some great text!"

  Scenario: Localized Content in German
    Given the standard pages
	And the configured locales is "en,de"
	When I go to path "/de/index.html"
	Then I should see "Meine Startseite" within "/html/head/title"
	And I should see "Dies ist ein super Text!"

  Scenario: Page Admin 
	Given the standard pages
    When I go to path "/admin/pages"
    Then I should see "CMS Admin"

#  Scenario: Debug Content in German
#    Given the standard pages
#	And the configured locales is "en,de"
#    When I go to path "/de/index.html"
#    Then put me the raw result





