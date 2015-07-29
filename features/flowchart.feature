Feature: ensuring flowchart renders as expected

  Background:
#    Given the legal file is accessible at
#    Given the practical file is accessible at
#    Given the expected legal mermaid output is accessible at
#    Given the expected practical mermaid output is accessible at


  Scenario: I want to ensure the legal flowchart markdown continues to render as expected
    When I navigate to "/flowchart"
    And I select "Legal" from the "type" dropdown
    And I click "submit"
#    Then the page should contain "#{legal_markdown}"
    Then the page should contain legal markdown

#  Scenario: I want to ensure the practical flowchart markdown continues to render as expected
#    When I navigate to localhost/flowchart
#    And I select "Practical" from the flowchart dropdown menu
#    And I click "submit"
#    Then the page should contain `legal_markdown`

#    heredoc

#    heredoc below
