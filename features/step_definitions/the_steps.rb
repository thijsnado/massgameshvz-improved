
When /^I go to the admin page$/ do
  visit admin_path
end

Then /^I should see an? "([^"]*)" link$/ do |link_text|
  page.should have_link(link_text)
end

When /^I go to the home page$/ do
  visit root_path
end

Then /^I should not see an? "(.*?)" link$/ do |link_text|
  page.should_not have_link(link_text)
end

