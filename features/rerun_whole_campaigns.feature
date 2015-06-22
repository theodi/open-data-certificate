@api @data_kitten
Feature: Rerun campaigns

  Background:
    Given I am signed in as the API user

  Scenario: Rerun campaign button queues correctly
    Given I have a campaign "brian"
    And that campaign has 5 certificates
    And I visit the campaign page for "brian"
    Then the campaign should be queued to be rerun
    When I click "Rerun campaign"
    And I should be redirected to the campaign page for "brian"
    And I should see "Campaign queued for rerun"

  Scenario: Rerunnning campaigns when new data is present
    Given I want to create a certificate via the API
    And I apply a campaign "brian"
    And the field "publisherUrl" is missing from my metadata
    And my URL autocompletes via DataKitten
    When I request a certificate via the API
    And the certificate is created
    And I visit the campaign page for "brian"
    When I add the field "publisherUrl" with the value "http://example.com" to my metadata
    And my URL autocompletes via DataKitten
    And I click "Rerun campaign"
    Then I should see "1 certificate published"
