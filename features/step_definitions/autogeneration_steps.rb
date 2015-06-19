Given(/^my URL autocompletes via DataKitten$/) do
  KittenData.any_instance.stubs(:fields).returns(@body[:dataset])

  @body[:dataset] = {
    documentationUrl: @documentationURL
  }
end

Given(/^the field "(.*?)" is missing from my metadata$/) do |field|
  @body[:dataset][field.to_sym] = nil
end

When(/^I add the field "(.*?)" with the value "(.*?)" to my metadata$/) do |field, value|
  @body[:dataset][field.to_sym] = value
end

When(/^I change the underlying dataset$/) do
  steps %Q{
    Given I want to create a certificate via the API
    And my URL autocompletes via DataKitten
  }
end

When(/^I click "(.*?)"$/) do |arg1|
  click_on("regenerate")
end

Given(/^my metadata has the email "(.*?)" associated$/) do |email|
  KittenData.any_instance.stubs(:contacts_with_email).returns([DataKitten::Agent.new(mbox: email)])
end
