@api @vcr
Feature: Generate certificates from campaigns via a rake task

  Scenario: Generate single dataset
    Given I have a a dataset at the URL "http://data.gov.uk/dataset/defence-infrastructure-organisation-disposals-database-house-of-commons-report"
    And I create a single certificate
    Then there should be 1 certificate

  Scenario: Don't duplicate datasets
    Given a dataset already exists for the URL "http://data.gov.uk/dataset/defence-infrastructure-organisation-disposals-database-house-of-commons-report"
    And I have a a dataset at the URL "http://data.gov.uk/dataset/defence-infrastructure-organisation-disposals-database-house-of-commons-report"
    And I create a single certificate
    Then there should be 1 dataset

  Scenario: Generate multiple datasets from a CKAN url
    Given I have a CKAN atom feed with 20 datasets
    And I run a campaign called "brian" to create certificates
    Then there should be 20 certificates
    And there should be 1 campaign
    And that campaign should have the name "brian"

  Scenario: Multi page Atom feeds
    Given I have a CKAN atom feed with 30 datasets over 3 pages
    And I run a campaign called "brian" to create certificates
    Then there should be 30 certificates

  Scenario: Specify a limit
    Given I have a CKAN atom feed with 20 datasets
    And I only want 5 datasets
    And I run a campaign called "brian" to create certificates
    Then there should be 5 certificates

  @sidekiq_fake
  Scenario: Campaign shows as pending when running
    Given I have a CKAN atom feed with 10 datasets
    And I am signed in as the API user
    And I run a campaign called "brian" to create certificates
    And the campaign is created
    When I visit the campaign page for "brian"
    Then I should see "Campaign currently in progress"
    And I should see "10 certificates pending"
    When the certificates are created
    When I visit the campaign page for "brian"
    Then I should not see "Campaign currently in progress"
    And I should see "0 certificates pending"

