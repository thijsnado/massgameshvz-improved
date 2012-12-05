Given /^I am logged in as an admin$/ do
  user = FactoryGirl.build(:user, :username => 'admin', :password => 'admin')
  user.is_admin = true
  user.confirmed = true
  user.save :validate => false
  visit login_path
  fill_in 'Username', :with => 'admin'
  fill_in 'Password', :with => 'admin'
  click_button 'login'
end

When /^I go to the admin page$/ do
  visit admin_path
end

Then /^I should see an? "([^"]*)" link$/ do |link_text|
  page.should have_link(link_text)
end
