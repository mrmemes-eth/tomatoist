Feature: User renames session
  Scenario: renaming a default-named session
    Given I am on the home page
    When I fill in "http://www.example.com" with "bar"
    And I press "rename"
    Then I should be viewing the "bar" session

  Scenario: renaming a custom-named session
    Given the following session:
      | custom | foo |
    And I am viewing the "foo" session
    When I fill in "http://www.example.com" with "bar"
    And I press "rename"
    Then I should be viewing the "bar" session
