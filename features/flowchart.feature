@survey

Feature: ensuring flowchart renders as expected

  Background:
#    Given the legal file is accessible at
#    Given the practical file is accessible at
#    Given the expected legal mermaid output is accessible at
#    Given the expected practical mermaid output is accessible at


  Scenario: I want to ensure the legal flowchart markdown continues to render as expected
    When I navigate to "/flowchart"
    And I select "United Kingdom" from the "jurisdiction" dropdown
    And I select "Legal" from the "type" dropdown
    And I click "Submit"
    Then the page should contain legal markdown


  Scenario: I want to ensure the practical flowchart markdown continues to render as expected
    When I navigate to "/flowchart"
    And I select "United Kingdom" from the "jurisdiction" dropdown
    And I select "Practical" from the "type" dropdown
    And I click "Submit"
    Then the page should contain practical markdown