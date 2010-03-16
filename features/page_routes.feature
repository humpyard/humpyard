Feature: Page Routing
  In order to access pages
  A user enters a pretty URL
  and gets the corrosponding page

  Background:
	Given the standard pages

  Scenario: View Index
    When I go to path "/"
    Then I should see "My Homepage"

  Scenario: View Index
    When I go to path "/en/index.html"
    Then I should see "My Homepage"

  Scenario: View Imprint
	When I go to path "/en/imprint.html"
	Then I should see "Imprint"

  Scenario: View Imprint with additional slashes in url
	When I go to path "/en///imprint.html"
	Then I should see "Imprint"

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
	
  Scenario: View Index with custom www prefix without locale
	Given the www prefix is "cms/"
	When I go to path "/cms/index.html"
	Then I should see "My Homepage"
	
  Scenario: View Index with custom www prefix incorporation locale
	Given the www prefix is "cms_:locale/"
	When I go to path "/cms_en/index.html"
	Then I should see "My Homepage"
	
  Scenario: View Index with custom www non-path prefix
	Given the www prefix is "cms_"
	When I go to path "/cms_index.html"
	Then I should see "My Homepage"

		
  Scenario: View Subpage with default www prefix
	Given the www prefix is ":default"
    When I go to path "/en/about/contact.html"
    Then I should see "Contact"

  Scenario: Miss Subpage with wrong path
    When I go to path "/en/contact.html"
    Then I should see "not found"
