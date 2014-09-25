@api
Feature: Display information about campaigns in UI

  Background: 
    Given I want to create a certificate via the API
    And I apply a campaign "brian"
    And I request a certificate via the API
    And the certificate is created
    And I request a certificate via the API
    
  Scenario: list campaigns
    When I visit the campaigns page
    Then I should see "brian"
    
  Scenario: view single campaign
    When I visit the campaign page for "brian"
    Then I should see "2 datasets inspected"
    And I should see "1 dataset added"
    And I should see "1 certificate published"
    And I should see "1 dataset already existed"
    
  Scenario: view single campaign as CSV
    When I visit the campaign page for "brian.csv"
    Then I should get a CSV file
    And CSV row 0 column "Success?" should be "true"
    And CSV row 0 column "Published?" should be "true"
    And CSV row 0 column "Documentation URL" should be "http://example.com/dataset"
    And CSV row 0 column "Certificate URL" should be "http://www.example.com/datasets/1/certificates/1"
    And CSV row 0 column "User" should be "api@example.com"