Feature: Page sitemap
  In order to get an overview of the structure of the page
  As a robot
  I want to get the sitemap
 
  Scenario: check sitemap XML validity
   Given the standard pages
   When go to path "/sitemap.xml"
   Then the page is valid XML
 
  Scenario: check sitemap for root page
    Given the standard pages
    When go to path "/sitemap.xml"
	Then I should see "http://example.org/"
  
  Scenario: check sitemap for imprint page
    Given the standard pages
    When go to path "/sitemap.xml"
	Then I should see "http://example.org/en/imprint.html"

  Scenario: check sitemap for about page
    Given the standard pages
    When go to path "/sitemap.xml"
	Then I should see "http://example.org/en/about.html"
  
  Scenario: check sitemap for contacts page
    Given the standard pages
    When go to path "/sitemap.xml"
	Then I should see "http://example.org/en/about/contact.html"

  Scenario: check sitemap for contacts page without www prefix 
	Given the standard pages
	And the www prefix is ""
	When go to path "/sitemap.xml"
	Then I should see "http://example.org/about/contact.html"

  Scenario: check sitemap for contacts page with custom www prefix 
	Given the standard pages
	And the www prefix is "cms/"
	When go to path "/sitemap.xml"
	Then I should see "http://example.org/cms/about/contact.html"

  Scenario: check sitemap for contacts page with custom www prefix with locale
	Given the standard pages
	And the www prefix is "cms/:locale/"
	When go to path "/sitemap.xml"
	Then I should see "http://example.org/cms/en/about/contact.html"

  Scenario: check sitemap for contacts page with custom www prefix with inline locale
	Given the standard pages
	And the www prefix is "cms_:locale/"
	When go to path "/sitemap.xml"
	Then I should see "http://example.org/cms_en/about/contact.html"

  Scenario: check sitemap for contacts page with custom www non-path prefix
	Given the standard pages
	And the www prefix is "cms_"
	When go to path "/sitemap.xml"
	Then I should see "http://example.org/cms_about/contact.html"

  Scenario: check sitemap for contacts page with default www prefix
	Given the standard pages
	And the www prefix is ":default"
    When go to path "/sitemap.xml"
	Then I should see "http://example.org/en/about/contact.html"

#  Scenario: debug sitemap
#   Given the standard pages
#   When go to path "/sitemap.xml"
#   Then put me the raw result

