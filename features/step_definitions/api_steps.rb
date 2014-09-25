Given(/^I want to create a certificate via the API$/) do
  @documentationURL = 'http://example.com/dataset'

  stub_request(:any, /http:\/\/.*example.com\/.*/).
        to_return(:status => 200, :body => "", :headers => {})

  @body = {
    jurisdiction: 'cert-generator',
    dataset: {
      dataTitle: 'Example Dataset',
      releaseType: 'oneoff',
      documentationUrl: @documentationURL,
      publisherUrl: 'http://www.example.com',
      publisherRights: 'yes',
      publisherOrigin: 'true',
      linkedTo: 'true',
      chooseAny: ['one', 'two']
    }
  }
end

Given(/^I apply a campaign "(.*?)"$/) do |tag|
  @body[:campaign] = tag
end

Given(/^I request (\d+) certifcates with the campaign "(.*?)"$/) do |num, tag|
  num.to_i.times do |i|
    steps %Q{
      Given I want to create a certificate via the API
      And I apply a campaign "#{tag}"
      And I request a certificate via the API
    }
  end
end

Given(/^I create a certificate via the API$/) do
  steps %Q{
    When I request a certificate via the API
    And the certificate is created
    And I request the results via the API
    Then the API response should return sucessfully
  }
end

Given(/^I request that the API creates a user$/) do
  @body[:create_user] = "true"
end

Given(/^my dataset contains contact details$/) do
  @email = "newuser@example.com"
  ResponseSet.any_instance.stubs(:kitten_data).returns({data: {
      publishers: [
        {
          mbox: @email
        }
      ]
    }})
end

Given(/^my dataset does not contain contact details$/) do
  ResponseSet.any_instance.stubs(:kitten_data).returns({data: {
      publishers: []
    }})
  @email = @api_user.email
end

Given(/^I provide the API with a URL that autocompletes$/) do
  ResponseSet.any_instance.stubs(:autocomplete)
end

When(/^I request a certificate via the API$/) do
  authorize @api_user.email, @api_user.authentication_token

  @response = post '/datasets', @body
end

When(/^the certificate is created$/) do
  CertificateGenerator.first.generate(!@body[:create_user].blank?)
end

When(/^I request the results via the API$/) do
  @response = get "/datasets/#{Dataset.last.id}.json"
end

Given(/^that email address is used for an existing user$/) do
  User.create(email: @email, password: "12345678")
end

Then(/^a new user should be created$/) do
  user = User.find_by_email(@email)

  assert_equal Dataset.all.first.user, user
end

Then(/^that certificate should be linked to the ODI Administrator account$/) do
  user = User.find(ENV['ODC_ADMIN_IDS'].split(",").first)

  assert_equal Dataset.all.first.user, user
end

Then(/^the certificate should use the existing user account$/) do
  user = User.find_by_email(@email)

  assert_equal Dataset.all.first.user, user
end

When(/^the certificate should use the account that made the API request$/) do
  user = User.find_by_email("api@example.com")

  assert_equal Dataset.all.first.user, user
end

Then(/^the API response should contain the user's email$/) do
  json = JSON.parse(@response.body)

  assert_equal @email, json['owner_email']
end

Then(/^the API response should return sucessfully$/) do
  assert_match /\"success\":true/,  @response.body
end

Then(/^the API response should return pending$/) do
  assert_match /\"success\":\"pending\"/,  @response.body
end


Then(/^my certificate should be published$/) do
  assert Dataset.first.certificate.published
end

Given(/^that URL already has a dataset$/) do
  FactoryGirl.create(:dataset, documentation_url: @documentationURL)
end

Then(/^the API response should return unsucessfully$/) do
  assert_match /\"success\":false/,  @response.body
end

Then(/^there should only be one dataset$/) do
  assert_equal Dataset.count, 1
end

Then(/^I should get the certificate URL$/) do
  assert_match /\"certificate_url\":\"http:\/\/test\.dev\/datasets\/[0-9]+\/certificates\/[0-9]+\"/,  @response.body
end

Then(/^my certificate should be linked to a campaign$/) do
  @generator = CertificateGenerator.last
  refute @generator.certification_campaign.nil?
end

Then(/^my certificate should not be linked to a campaign$/) do
  @generator = CertificateGenerator.last
  assert @generator.certification_campaign.nil?
end

Then(/^that campaign should be called "(.*?)"$/) do |campaign|
  assert_equal @generator.certification_campaign.name, campaign
end

Then(/^there should be (\d+) campaigns?$/) do |count|
  assert_equal count.to_i, CertificationCampaign.count
end

Then(/^that campaign should have (\d+) certificate generators$/) do |num|
  campaign = CertificationCampaign.first
  assert_equal num.to_i, campaign.certificate_generators.count
end

Then(/^there should be (\d+) datasets?$/) do |count|
  assert_equal count.to_i, Dataset.count
end

Then(/^that campaign should have a duplicate count of (\d+)$/) do |num|
  campaign = CertificationCampaign.first
  assert_equal num.to_i, campaign.duplicate_count
end

Then(/^I should get a CSV file$/) do
  assert_equal page.response_headers["Content-Type"], 'text/csv; header=present; charset=utf-8'
  @csv = CSV.parse page.body, headers: true
end

Then(/^CSV row (\d+) column "(.*?)" should be "(.*?)"$/) do |row, col, value|
  assert_equal value, @csv[row.to_i][col]
end