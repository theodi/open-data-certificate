@api @data_kitten
Feature: Rerun campaigns

  Background:
    Given I am signed in as the API user

  Scenario: Rerun campaign button queues each individual generator
    Given I have a campaign "brian"
    And that campaign has 5 certificates
    And I visit the campaign page for "brian"
    Then the generators should be queued for rerun
    When I click "Rerun campaign"
    And I should be redirected to the campaign page for "brian"

  Scenario: Rerunnning campaigns when new data is present
    Given I want to create a certificate via the API
    And I apply a campaign "brian"
    And the field "publisherUrl" is missing from my metadata
    And my URL autocompletes via DataKitten
    When I request a certificate via the API
    And I visit the campaign page for "brian"
    When I add the field "publisherUrl" with the value "http://example.com" to my metadata
    And my URL autocompletes via DataKitten
    And I click "Rerun campaign"
    Then I should see 1 dataset
    And I should see "1 certificate published"

  Scenario: Correct generators are rerun
    Given I have a campaign "brian"
    And that campaign has 5 certificates
    And I visit the campaign page for "brian"
    When I click "Rerun campaign"
    Then I should be redirected to the campaign page for "brian"
    And I should see the correct generators

  Scenario: Schedule a daily rerun
    Given I have a campaign "brian"
    And that campaign has 5 certificates
    And I visit the campaign page for "brian"
    Then a rerun should be scheduled for tomorrow
    When I click "Schedule campaign"

  Scenario: Rerun campaign button shows correct numbers
    Given I have a campaign "brian"
    And that campaign has 5 certificates
    And I visit the campaign page for "brian"
    When I click "Rerun campaign"
    Then I should be redirected to the campaign page for "brian"
    And I should see "Campaign queued for rerun"
    And I should see "5 datasets inspected"
    And I should see 5 datasets

  @sidekiq_fake
  Scenario: Campaigns show as pending after rerun
    Given I have a campaign "brian"
    And that campaign has 5 certificates
    And I visit the campaign page for "brian"
    And I click "Rerun campaign"
    Then I should be redirected to the campaign page for "brian"
    And my campaigns should be shown as pending
    And I should see 5 datasets
