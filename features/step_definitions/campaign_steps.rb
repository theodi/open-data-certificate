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

Given(/^I have a campaign "(.*?)"$/) do |name|
  @campaign = name
end

Given(/^that campaign has (\d+) certificates?$/) do |num|
  num.to_i.times do |i|
    steps %Q{
      Given I want to create a certificate via the API with the URL "http://data.example.com/datasets/#{i}"
      And I apply a campaign "#{@campaign}"
      And I request a certificate via the API
      And the certificate is created
    }
  end
end

Then(/^the campaign should be queued to be rerun$/) do
  campaign = CertificationCampaign.find_by_name(@campaign)
  CertificationCampaign.any_instance.expects(:rerun!)
end

Then(/^the generators should be queued for rerun$/) do
  CertificateGenerator.any_instance.expects(:generate).times(5)
end

When(/^I should be redirected to the campaign page for "(.*?)"$/) do |campaign|
  campaign = CertificationCampaign.find_by_name(campaign)
  assert_equal page.current_path, campaign_path(campaign)
end
When(/^I should see (\d+) datasets?$/) do |num|
  assert_equal num.to_i + 1, page.all(:css, 'table tr').count
end
