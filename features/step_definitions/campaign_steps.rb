When(/^I visit the campaigns page$/) do
  visit campaigns_path
end

Then(/^I should see "(.*?)"$/) do |text|
  assert_match text,  page.body
end

When(/^I visit the campaign page for "(.*?)"$/) do |name|
  campaign = CertificationCampaign.find_by_name(name)
  visit campaign_path(campaign)
end

When(/^I click the "(.*?)" link$/) do |link_name|
  click_link(link_name)
end

And (/^the campaign should be owned by my user account$/) do
  assert_equal @generator.certification_campaign.user, @api_user
end

Then(/^that campaign should have the name "(.*?)"$/) do |name|
  @campaign = CertificationCampaign.find_by_name(name)
  assert_not_equal nil, @campaign
end

Then(/^that campaign should have (\d+) generators$/) do |num|
  assert_equal num.to_i, @campaign.certificate_generators.count
end

Given(/^I visit the path to create a new campaign$/) do
  visit new_campaign_path
end

Given(/^I enter the feed URL in the URL field$/) do
  fill_in "url", with: @url
end

Given(/^I enter "(.*?)" in the campaign field$/) do |name|
  fill_in "name", with: name
end

Given(/^I choose a limit of (\d+) certificates$/) do |limit|
  fill_in "limit", with: limit
end

Given(/^I click "(.*?)"$/) do |button|
  click_on button
end

Given(/^I select "(.*?)" from the juristiction field$/) do |jurisdiction|
  select(jurisdiction, :from => "Jurisdiction")
end
