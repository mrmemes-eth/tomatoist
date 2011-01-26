Feature: User starts timers
  Background:
    Given I am on the home page

  Scenario: starting a pomodoro
    When I press "Pomodoro"
    Then I should see "Pomodoro" in the "Timer History" section
    And I should see "less than a minute ago" in the "Timer History" section

  Scenario: starting a long break
    When I press "Long Break"
    Then I should see "Long Break" in the "Timer History" section
    And I should see "less than a minute ago" in the "Timer History" section

  Scenario: starting a short break
    When I press "Short Break"
    Then I should see "Short Break" in the "Timer History" section
    And I should see "less than a minute ago" in the "Timer History" section

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
