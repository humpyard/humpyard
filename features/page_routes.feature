Feature: Page Routing
  In order to access pages
  A user enters a pretty URL
  and gets the corrosponding page

  Background:
	Given the standard pages

  Scenario: View Index
    When I go to path "/"
    Then I should get a status code of 200
	And I should see the page with id 42

  Scenario: View Index
    When I go to path "/en/index.html"
    Then I should get a status code of 200
	And I should see the page with id 42

  Scenario: View Imprint
	When I go to path "/en/imprint.html"
	Then I should get a status code of 200
	And I should see the page with id 89

  Scenario: View Imprint with additional slashes in url
	When I go to path "/en///imprint.html"
	Then I should get a status code of 200
	And I should see the page with id 89

  Scenario: Miss Page
	When I go to path "/en/foo.html"
	Then I should get a status code of 404
	
  Scenario: View Index without www prefix
	Given the www prefix is ""
	When I go to path "/imprint.html"
	Then I should get a status code of 200
	And I should see the page with id 89
	
  Scenario: View Index with custom www prefix without locale
	Given the www prefix is "cms/"
	When I go to path "/cms/index.html"
	Then I should get a status code of 200
	And I should see the page with id 42

  Scenario: View Index with custom www prefix with locale
	Given the www prefix is "cms/:locale/"
	When I go to path "/cms/en/index.html"
	Then I should get a status code of 200
	And I should see the page with id 42

 Scenario: Miss Index with custom www prefix with locale
	Given the www prefix is "cms/:locale/"
	When I go to path "/en/index.html"
	Then I should get a status code of 404
	
  Scenario: View Index with custom www prefix with inline locale
	Given the www prefix is "cms_:locale/"
	When I go to path "/cms_en/index.html"
	Then I should get a status code of 200
	And I should see the page with id 42
	
  Scenario: View Index with custom www non-path prefix
	Given the www prefix is "cms_"
	When I go to path "/cms_index.html"
	Then I should get a status code of 200
	And I should see the page with id 42

		
  Scenario: View Subpage with default www prefix
	Given the www prefix is ":default"
    When I go to path "/en/about/contact.html"
    Then I should get a status code of 200
	And I should see the page with id 60

  Scenario: Miss Subpage with wrong path
    When I go to path "/en/contact.html"
  	Then I should get a status code of 404
