Feature: Basic Test
  As a user
  I want to access the site

  @xbrowser
  Scenario: Finding the banner button
    Given I am on the homepage
    Then browserstack tunnel is running
    And Capybara is not :rack_test
    And I should see "got here"
