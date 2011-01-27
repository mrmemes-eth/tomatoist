Feature: User starts a timer
  Background:
    Given I am on the home page

  Scenario Outline: starting a timer
    When I press "<timer>"
    Then I should see "<timer>" in the "Timer History" section
    And I should see "less than a minute ago" in the "Timer History" section

    Examples:
      | timer       |
      | Pomodoro    |
      | Short Break |
      | Long Break  |

  Scenario: multiple timers
    When I press "Pomodoro"
    And I wait
    And I press "Short Break"
    And I wait
    And I press "Long Break"
    Then I should see the following list in the "Timer History" section:
      | Long Break  |
      | Short Break |
      | Pomodoro    |
