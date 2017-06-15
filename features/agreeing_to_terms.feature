Feature: agreeing to terms of use

  Background:
    Given I am signed in as "robyn@example.org"
    And I visit the edit account page

  Scenario: I need to agree to the terms of use to save my details
    When I enter an organization of "Example Org"
    And I do not agree to the terms
    And I enter my current password
    And I click save
    Then there is an error message about agreeing to terms
    And my changes are not saved

  Scenario: I agree to terms of use and save my details
    When I enter an organization of "Example Org"
    And I agree to the terms
    And I enter my current password
    And I click save
    Then there is no error message
    And my changes are saved

