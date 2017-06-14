Feature: registering a new account

  Background:
    Given I visit the home page
    And I click "Register"

  Scenario: I sign up for an account
    When I enter my email address
    And I enter my password
    And I confirm my password
    And I agree to the terms
    And I click sign up
    Then my account should be created
