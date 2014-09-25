@api
Feature: Track certificate generation campaigns

  Scenario: Apply campaign tags to certificate generator
    Given I want to create a certificate via the API
    And I apply a campaign "brian"
    And I request a certificate via the API
    Then my certificate should be linked to a campaign
    And that campaign should be called "brian"

  Scenario: Don't link to campaign if no campaign specified
    Given I want to create a certificate via the API
    And I request a certificate via the API
    Then my certificate should not be linked to a campaign

  Scenario: Link multiple requests with the same name to the same campaign
    Given I request 2 certifcates with the campaign "fred"
    Then there should be 1 campaign
    And that campaign should have 2 certificate generators

  Scenario: Count duplicate certificates requested in a campaign
    Given I want to create a certificate via the API
    But that URL already has a dataset
    And I apply a campaign "brian"
    And I request a certificate via the API
    Then there should be 1 dataset
    And there should be 1 campaign
    And that campaign should have a duplicate count of 1
