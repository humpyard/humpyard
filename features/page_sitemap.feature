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
	Then I should see "http://www.example.com/"
  
  Scenario: check sitemap for imprint page
    Given the standard pages
    When go to path "/sitemap.xml"
	Then I should see "http://www.example.com/en/imprint.html"

  Scenario: check sitemap for about page
    Given the standard pages
    When go to path "/sitemap.xml"
	Then I should see "http://www.example.com/en/about.html"
  
  Scenario: check sitemap for contacts page
    Given the standard pages
    When go to path "/sitemap.xml"
	Then I should see "http://www.example.com/en/about/contact.html"

  Scenario: check sitemap for contacts page without www prefix 
	Given the standard pages
	And the configured www prefix is ""
	When go to path "/sitemap.xml"
	Then I should see "http://www.example.com/about/contact.html"

  Scenario: check sitemap for contacts page with custom www prefix 
	Given the standard pages
	And the configured www prefix is "cms/"
	When go to path "/sitemap.xml"
	Then I should see "http://www.example.com/cms/about/contact.html"

  Scenario: check sitemap for contacts page with custom www prefix with locale
	Given the standard pages
	And the configured www prefix is "cms/:locale/"
	When go to path "/sitemap.xml"
	Then I should see "http://www.example.com/cms/en/about/contact.html"

  Scenario: check sitemap for contacts page with custom www prefix with inline locale
	Given the standard pages
	And the configured www prefix is "cms_:locale/"
	When go to path "/sitemap.xml"
	Then I should see "http://www.example.com/cms_en/about/contact.html"

  Scenario: check sitemap for contacts page with custom www non-path prefix
	Given the standard pages
	And the configured www prefix is "cms_"
	When go to path "/sitemap.xml"
	Then I should see "http://www.example.com/cms_about/contact.html"

  Scenario: check sitemap for contacts page with default www prefix
	Given the standard pages
	And the configured www prefix is ":default"
    When go to path "/sitemap.xml"
	Then I should see "http://www.example.com/en/about/contact.html"
	
  Scenario: check sitemap for contacts page with locales
	Given the standard pages
	And the configured locales is "en,de"
	When go to path "/sitemap.xml"
	Then I should see "http://www.example.com/en/about/contact.html"
	And I should see "http://www.example.com/de/about/contact.html"

#  Scenario: debug sitemap
#   Given the standard pages
#   When go to path "/sitemap.xml"
#   Then put me the raw result

