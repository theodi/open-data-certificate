@api @vcr
Feature: Generate certificates from campaigns via the UI

  Background:
    Given I am signed in as the API user

  Scenario: Create new campaign
    Given I have a CKAN atom feed with 20 datasets
    And I visit the path to create a new campaign
    And I enter the feed URL in the URL field
    And I enter "brian" in the campaign field
    And I select "cert-generator" from the juristiction field
    And I click "Submit"
    Then there should be 1 campaign
    And that campaign should have the name "brian"
    And that campaign should have 20 generators
    And there should be 20 certificates

  Scenario: Create campaign with limit
    Given I have a CKAN atom feed with 20 datasets
    And I visit the path to create a new campaign
    And I enter the feed URL in the URL field
    And I enter "brian" in the campaign field
    And I select "cert-generator" from the juristiction field
    And I choose a limit of 5 certificates
    And I click "Submit"
    Then there should be 1 campaign
    And that campaign should have the name "brian"
    And that campaign should have 5 generators
    And there should be 5 certificates
