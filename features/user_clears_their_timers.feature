Feature: user clears their timers
  Background:
    Given I have the following session:
      | custom | quuz |
    And that session has a pomodoro
    And that session has a short break
    And I am viewing the "quuz" session

  Scenario: viewing timers
    Then I should see "Pomodoro" in the "Timer History" section
    And I should see "Short Break" in the "Timer History" section

  Scenario: clearing timers
    When I press "Clear Timers"
    Then I should not see "Pomodoro" in the "Timer History" section
    And I should not see "Short Break" in the "Timer History" section
