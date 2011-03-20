Feature: Navigate Admin Page
	In order to adminstrate HVZ
	As an administrator
	I need a page that can change game settings
	
	Scenario: Logged In Admin
		Given I am logged in as an admin
		When I go to the admin page
		Then I should see a "users" link
		And I should see a "zombies" link
		And I should see a "humans" link
		And I should see a "sarcastic comments" link
		And I should see a "living areas" link
		And I should see a "original zombies" link
		And I should see a "squads" link
		And I should see a "vaccines" link
		And I should see a "pseudo bites" link
		And I should see a "games" link
		And I should see an "events" link
		And I should see a "mass mailer" link
		And I should see a "email domains" link
		And I should see a "misc tasks" link