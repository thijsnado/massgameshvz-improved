Then /^I should be a Zombie$/ do
  game_participations(:human_participation).creature.should == zombies(:normal)
end

Then /^the Zombie should get credit for biting me$/ do
  game_participations(:zombie_participation).biting_events.last.bitten_participation.should == game_participations(:human_participation)
end

Then /^the human should be a Zombie$/ do
  game_participations(:human_participation).creature.should == zombies(:normal)
end

Then /^I should get credit for biting the human$/ do
  game_participations(:zombie_participation).biting_events.last.bitten_participation.should == game_participations(:human_participation)
end

Then /^I should become a human$/ do
  game_participations(:zombie_participation).creature.should == humans(:normal)
end


Then /^I should have a number of bite share as specified by the current game attributes$/ do
  game_participations(:zombie_participation).bite_shares.count.should == games(:current_game).bite_shares_per_food
end