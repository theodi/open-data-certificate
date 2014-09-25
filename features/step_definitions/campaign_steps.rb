When(/^I visit the campaigns page$/) do
  visit '/campaigns'
end

Then(/^I should see "(.*?)"$/) do |text|
  assert_match text,  page.body
end

When(/^I visit the campaign page for "(.*?)"$/) do |campaign|
  visit '/campaigns/'+campaign
end