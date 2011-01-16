Feature: Navigate Index Page
	In order to play HVZ
	As a player
	I need an index page which will bring me to all the links I need
	
	Scenario: Logged Out Player
		Given I am logged out
		When I go to the index page
		Then I should see a login link
		
	Scenario: Logged In Player
		Given I am logged in
		When I go to the index page
		Then I should see a logout link