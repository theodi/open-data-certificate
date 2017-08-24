Feature: registering a new account

  Background:
    Given I visit the home page
    And I click "Register"

  Scenario: I can sign up for an account successfully
    When I enter my email address
    And I enter my password
    And I confirm my password
    And I agree to the terms
    And I fill in the CAPTCHA
    And I click sign up
    Then an account should be created

  Scenario: Can't sign up if I don't fill in the CAPTCHA
    When I enter my email address
    And I enter my password
    And I confirm my password
    And I agree to the terms
    And I don't fill in the CAPTCHA
    And I click sign up
    Then an account should not be created
    And there is an error message about being human
