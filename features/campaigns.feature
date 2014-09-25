@api
Feature: Display information about campaigns in UI

  Background: 
    Given I want to create a certificate via the API
    But that URL already has a dataset
    And I apply a campaign "brian"
    And I request a certificate via the API
    
  Scenario: list campaigns
    When I visit the campaigns page
    Then I should see "brian"
    
  Scenario: view single campaign
    When I visit the campaign page for "brian"
    Then I should see "0 datasets loaded"
    And I should see "0 certificates published"
    And I should see "1 dataset already existed"