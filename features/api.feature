@api
Feature: Open Data Certificate API

  Scenario: API call with autocompleting data
    Given I provide the API with a URL that autocompletes
    When I create a certificate via the API
    Then the API response should return sucessfully
    And my certificate should be published

  Scenario: API call when documentation URL already exists
    Given I provide the API with a URL that autocompletes
    And that URL already has a dataset
    When I create a certificate via the API
    Then the API response should return unsucessfully
    And there should only be one dataset
