@api
Feature: Generate certificates from campaigns via a rake task

  Scenario: Generate single dataset
    Given I have a a dataset at the URL "http://data.gov.uk/dataset/defence-infrastructure-organisation-disposals-database-house-of-commons-report"
    And I run the rake task to create a single certificate
    And the background jobs have all completed
    Then there should be 1 certificate

  Scenario: Generate multiple datasets from a CKAN url
    Given I have a CKAN atom feed with 20 datasets
    And I run the rake task to create certificates from the feed
    And the background jobs have all completed
    Then there should be 20 certificates

  Scenario: Multi page Atom feeds
    Given I have a CKAN atom feed with 30 datasets over 3 pages
    And I run the rake task to create certificates from the feed
    And the background jobs have all completed
    Then there should be 30 certificates

  Scenario: Specify a campaign
    Given I have a CKAN atom feed with 10 datasets
    And I apply a campaign "brian"
    And I run the rake task to create certificates from the feed
    And the background jobs have all completed
    Then there should be 10 certificates
    And there should be 1 campaign
    And that campaign should have the name "brian"

  Scenario: Specify a limit
    Given I have a CKAN atom feed with 20 datasets
    And I only want 5 datasets
    And I run the rake task to create certificates from the feed
    And the background jobs have all completed
    Then there should be 5 certificates

  Scenario: Generate multiple datasets from a CSV
    Given I have a CSV with 20 datasets
    And I run the rake task to create certificates from the CSV
    And the background jobs have all completed
    Then there should be 20 certificates
