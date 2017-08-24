@api @vcr
Feature: Generate certificates from campaigns via the UI

  Background:
    Given I am signed in as the API user
    And I have a CKAN atom feed with 20 datasets

  Scenario: Create new campaign
    When I visit the path to create a new campaign
    And I enter the feed URL in the URL field
    And I enter "brian" in the campaign field
    And I select "cert-generator" from the juristiction field
    And I click "Start campaign"
    Then there should be 1 campaign
    And that campaign should have the name "brian"
    And that campaign should have 20 generators
    And there should be 20 certificates

  Scenario: Create campaign with limit
    When I visit the path to create a new campaign
    And I enter the feed URL in the URL field
    And I enter "brian" in the campaign field
    And I select "cert-generator" from the juristiction field
    And I choose a limit of 5 certificates
    And I click "Start campaign"
    Then there should be 1 campaign
    And that campaign should have the name "brian"
    And that campaign should have 5 generators
    And there should be 5 certificates

  Scenario: Rerunning campaigns created from atom feeds
    When I visit the path to create a new campaign
    And I enter the feed URL in the URL field
    And I enter "brian" in the campaign field
    And I select "cert-generator" from the juristiction field
    And I click "Start campaign"
    And I visit the campaign page for "brian"
    And there should be 20 certificates
    Then I have a CKAN atom feed with 25 datasets
    And I click "Rerun campaign"
    And I should see 25 datasets
