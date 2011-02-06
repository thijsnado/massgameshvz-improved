#put all steps that effect more than one page

Given /^I am logged in(?: as an* (.*))?$/ do |logged|
  case logged
  when nil 
    then username = 'normal_human'
  when 'human'
    then username = 'normal_human'
  when 'admin'
    then username = 'admin'
  when 'zombie'
    then username = 'normal_zombie'
  end
  
  visit path_to "the login page"
  fill_in "user_session_username", :with => username
  fill_in "user_session_password", :with => 'password'
  click_button 'login'
end

Given /^I am logged in as not an admin$/ do
  visit path_to "the login page"
  fill_in "user_session_username", :with => 'normal_human'
  fill_in "user_session_password", :with => 'password'
  click_button 'login'
end

Given /^I am logged out$/ do
  #Should be logged out by default
end

Given /^the game has started$/ do
  Timecop.freeze(games(:current_game).start_at + 1.second)
end

Then /^I should see an* '(.*)' link$/ do |link_text|
  page.should have_link(link_text)
end

Then /^I should not see an* '(.*)' link$/ do |link_text|
  page.should_not have_link(link_text)
end