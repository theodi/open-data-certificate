Feature: claiming an already imported dataset

  Background:
    Given there exists a dataset called "The Data"
    And that is owned by "owner@data.org"
    And has a published certificate

  Scenario: Show the embed instructions to dataset owners
    When I am signed in as "owner@data.org"
    And I visit the certificate page
    Then I should see the embed button

  Scenario: Show the claim instructons to other users
    When I am signed in as "person@elsewhere.net"
    And I visit the certificate page
    Then I should see the claim button

  Scenario: Show the claim insructions to anonymous users
    When I visit the certificate page
    Then I should see the claim button
