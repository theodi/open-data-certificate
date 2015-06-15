@api
Feature: Generate certificates from campaigns via a rake task

  Scenario: Generate single dataset
    Given I have a a dataset at the URL "http://data.gov.uk/dataset/defence-infrastructure-organisation-disposals-database-house-of-commons-report"
    And I run the rake task to create a single certificate
    And the background jobs have all completed
    Then there should be 1 certificate
