def login_as(user)
  visit login_path
  fill_in 'Username', :with => user.username
  fill_in 'Password', :with => user.password
  click_button 'login'
end

Given /^I am logged in as an admin$/ do
  user = FactoryGirl.build(:user, :username => 'admin', :password => 'admin')
  user.is_admin = true
  user.confirmed = true
  user.save :validate => false
  login_as(user)
end

Given /^I am logged out$/ do
  if page.has_link? 'logout'
    click_link 'logout'
  end
end

Given /^I am logged in$/ do
  user = FactoryGirl.build(:user)
  user.confirmed = true
  user.save :validate => false
  login_as(user)
end

Given /^I am logged in as not an admin$/ do
  Given "I am logged in"
end

Given /^I am logged in as a human$/ do
  user = UserCreator.create_user_as_type(:normal_human)
end
