Feature: registering a new account

  Background:
    Given I visit the home page
    And I click "Register"

  Scenario: I can sign up for an account successfully
    When I enter my email address
    And I enter my password
    And I confirm my password
    And I agree to the terms
    And I click sign up
    Then an account should be created

  Scenario: Dumb bots that autotick boxes can't make accounts
    When I enter my email address
    And I enter my password
    And I confirm my password
    And I agree to the terms
    And I tick the inhuman box
    And I click sign up
    Then an account should not be created
    And there is an error message about being human
