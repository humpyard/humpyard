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

#  Scenario: debug sitemap
#   Given the standard pages
#   When go to path "/sitemap.xml"
#   Then put me the raw result

