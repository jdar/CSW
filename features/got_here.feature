Feature: Basic Test
  As a user
  I want to access the site

  @xbrowser
  Scenario: Finding the banner button
    Given I am on the homepage
    Then I should see "got here"
