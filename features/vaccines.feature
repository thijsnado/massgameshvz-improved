Feature: Get Vaccine
  In order to regain my self awareness
  As a zombie
  I need to be able to receive vaccines
  
  Scenario: Zombie reports vaccine
    Given I am logged in as a zombie
    And I go to the home page
    When I follow "vaccinate"
    Then I should see "Enter Vaccine Code"
    When I fill in "Enter Vaccine Code" with "vaccine_code1"
    And I press "submit"
    Then I should become a human