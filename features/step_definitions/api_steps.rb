Given(/^I request that the API creates a user$/) do
  @body ||= {}
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
end

Given(/^I provide a CKAN URL$/) do
  @body ||= {}
  @body["dataset"] = {
      "documentationUrl" => "http://example.com/dataset"
    }

  ResponseSet.any_instance.stubs(:autocomplete)
end

When(/^I create a certificate via the API$/) do
  @api_user = User.create(email: "api@example.com", password: "password", authentication_token: "")
  @body["jurisdiction"] = "GB"

  authorize @api_user.email, @api_user.authentication_token

  post '/datasets', @body
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

Given(/^that the contact for a given dataset has no person name$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^a new user should be created for that certificate$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^the user account should have no name$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^that no contact details are available for a given dataset$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^a user account should not be created for that certificate$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^a new user should not be created for that certificate$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^that the contact for the dataset has no person name$/) do
  pending # express the regexp above with the code you wish you had
end
