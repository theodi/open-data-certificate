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
  campaign = CertificationCampaign.find_by_name(name)
  assert_not_equal nil, campaign
end
