Feature: Navigate Index Page
  In order to play HVZ
  As a user
  I need a home page which will bring me to all the links I need
  
  Scenario: Logged Out Player
    Given I am logged out
    When I go to the home page
    Then I should see a "login" link
    And I should see a "register" link
    
  Scenario: Logged In Player
    Given I am logged in
    When I go to the home page
    Then I should see a "logout" link
    And I should see a "status" link
    And I should see a "profile" link
    
  Scenario: Logged In Admin
    Given I am logged in as an admin
    When I go to the home page
    Then I should see an "admin" link
    
  Scenario: Logged In as Not An Admin
    Given I am logged in as not an admin
    When I go to the home page
    Then I should not see an "admin" link
    
  Scenario: Logged In as Human
    Given I am logged in as a human
    When I go to the home page
    Then I should see a "self bite" link
    And I should see a "report being bitten" link  
    
  Scenario: Logged In as Zombie
    Given I am logged in as a zombie
    When I go to the home page
    Then I should see a "report bite" link
    And I should see a "vaccinate" link
    
  Scenario: Logged in as Original Zombie
    Given I am logged in as an original zombie
    When I go to the home page
    Then I should see a "report bite" link
    Then I should not see a "vaccinate" link