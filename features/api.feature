@api
Feature: Open Data Certificate API

  Background:
    Given I want to create a certificate via the API

  Scenario: API call returns pending initially
    When I request a certificate via the API
    And I request the results via the API
    Then the API response should return pending
    When the certificate is created
    And I request the results via the API
    Then the API response should return sucessfully

  Scenario: API call with autocompleting data
    Given I provide the API with a URL that autocompletes
    When I request a certificate via the API
    And the certificate is created
    And I request the results via the API
    Then the API response should return sucessfully
    And my certificate should be published
    And I should get the certificate URL

  Scenario: API call when documentation URL already exists
    Given I provide the API with a URL that autocompletes
    And that URL already has a dataset
    When I request a certificate via the API
    Then the API response should return unsucessfully
    And there should only be one dataset
