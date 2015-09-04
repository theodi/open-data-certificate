When(/^I visit the campaigns page$/) do
  visit campaigns_path
end

Then(/^I should see "(.*?)"$/) do |text|
  assert_match text,  page.body
end

Then(/^I should not see "(.*?)"$/) do |text|
  assert_not_match /#{text}/, page.body
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

Given(/^I have a campaign "(.*?)"$/) do |name|
  @campaign = name
  @certification_campaign = CertificationCampaign.where(user_id: @api_user.id).find_or_create_by_name(name) do |campaign|
    campaign.jurisdiction = 'cert-generator'
  end
end

Given(/^that campaign has (\d+) certificates?$/) do |num|
  @num = num.to_i
  @num.times do |i|
    steps %Q{
      Given I want to create a certificate via the API with the URL "http://data.example.com/datasets/#{i}"
      And I apply a campaign "#{@campaign}"
      And I request a certificate via the API
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

Then(/^a rerun should be scheduled for tomorrow$/) do
  CertificationCampaignWorker.expects(:perform_in).with(1.day, @certification_campaign.id)
end

When(/^I should be redirected to the campaign page for "(.*?)"$/) do |campaign|
  campaign = CertificationCampaign.find_by_name(campaign)
  assert_equal page.current_path, campaign_path(campaign)
end

Then(/^my campaigns should be shown as pending$/) do
  assert_match "Processing",  page.body
end

When(/^I should see (\d+) datasets?$/) do |num|
  assert_equal num.to_i, page.all(:css, 'table tbody tr').count
end

Then(/^I should see the correct generators$/) do
  @num.times do |i|
    assert_match "http://data.example.com/datasets/#{i}", page.body
  end
end

Given(/^I visit the path to create a new campaign$/) do
  visit new_campaign_path
end

Given(/^I enter the feed URL in the URL field$/) do
  fill_in "CKAN URL", with: @url
end

Given(/^I enter "(.*?)" in the campaign field$/) do |name|
  fill_in "Campaign name", with: name
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
