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

Given(/^I want to create a certificate via the API with the URL "(.*?)"$/) do |url|
  steps %Q{
    Given I want to create a certificate via the API
  }

  @documentationURL = url
  @body[:dataset][:documentationUrl] = @documentationURL
end

Given(/^I miss the field "(.*?)"$/) do |field|
  @body[:dataset].delete(field.to_sym)
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
  @body[:create_user] = true
end

Given(/^my dataset contains contact details$/) do
  @email = "newuser@example.com"
  ResponseSet.any_instance.stubs(:kitten_data).returns(stub(
    :contacts_with_email => [DataKitten::Agent.new(mbox: @email)]
  ))
end

Given(/^my dataset does not contain contact details$/) do
  ResponseSet.any_instance.stubs(:kitten_data).returns(stub(
    :contacts_with_email => []
  ))
  @email = @api_user.email
end

Given(/^my dataset contains invalid contact details$/) do
  ResponseSet.any_instance.stubs(:kitten_data).returns(stub(
    :contacts_with_email => [DataKitten::Agent.new(mbox: "bad email@example.org")]
  ))
  @email = @api_user.email
end

Given(/^I provide the API with a URL that autocompletes$/) do
  ResponseSet.any_instance.stubs(:autocomplete)
end

When(/^I request a certificate via the API$/) do
  authorize @api_user.email, @api_user.authentication_token

  @response = post '/datasets', @body
  @status_url = JSON.parse(@response.body)['dataset_url']
end

When(/^the certificate is created$/) do
  generator = CertificateGenerator.all.select { |g| g.request["documentationUrl"] == @documentationURL }.first
  generator.generate(@body[:jurisdiction], @body[:create_user])
end

When(/^I request the status via the API$/) do
  @response = get @status_url
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

Given(/^that URL already has a published certificate$/) do
  certificate = FactoryGirl.create(:published_certificate_with_dataset)
  certificate.dataset.update_attribute(:documentation_url, @documentationURL)
end

Then(/^the API response should return unsucessfully$/) do
  assert_match /\"success\":false/,  @response.body
end

Then(/^there should only be one dataset$/) do
  assert_equal Dataset.count, 1
end

Then(/^I should get the certificate URL$/) do
  assert_match /\"certificate_url\":\"http:\/\/test\.host\/datasets\/[0-9]+\/certificate.json\"/,  @response.body
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

Given(/^I am signed in as the API user$/) do
  visit '/users/sign_in'
  first('#main #user_email').set("api@example.com")
  first('#main #user_password').set("password")
  first('#main .btn').click
end

Given(/^I have signed out$/) do
  first('a[href="/users/sign_out"]').click
end

Then(/^I should be told I need to sign in$/) do
  assert_match /You need to sign in or sign up before continuing/, page.body
end
