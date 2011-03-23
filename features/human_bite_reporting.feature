Feature: Play as Human
  In order to play HVZ
  As a human
  I need to be able to report if I've been bitten
  
  Scenario: Human has been bitten, Zombie has not reported bite
    Given I am logged in as a human
    And I go to the home page
    When I follow "report being bitten"
    Then I should see "Enter Bite Code"
    When I fill in "Enter Bite Code" with "ZOMBIE BITE CODE"
    And I press "submit"  
    Then I should be a Zombie
    And the Zombie should get credit for biting me