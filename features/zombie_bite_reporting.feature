Feature: Play as Zombie
  In order to play HVZ
  As a zombie
  I need to be able to report those I've bitten
  
  Scenario: Zombie has bitten human, Human has not reported bite
    Given I am logged in as a zombie
    And I go to the home page
    When I follow "report bite"
    Then I should see "Enter Bite Code"
    When I fill in "Enter Bite Code" with "human bite code"
    And I press "submit"
    Then the human should be a Zombie
    And I should get credit for biting the human
    And I should have a number of bite share as specified by the current game attributes