def get_user(email)
  User.find_or_create_by_email(email) do |u|
    u.password = "password"
  end
end

When(/^I am signed in as "(.*?)"$/) do |email|
  get_user(email)
  visit '/users/sign_in'
  first('#main #user_email').set(email)
  first('#main #user_password').set("password")
  first('#main .btn').click
end

Given(/^there exists a dataset called "(.*?)"$/) do |name|
  @survey = Survey.create!(title: 'GB')
  @dataset = Dataset.create!(title: name)
  @response_set = ResponseSet.create!(dataset_id: @dataset.id, survey: @survey)
end

Given(/^that is owned by "(.*?)"$/) do |email|
  @response_set.assign_to_user!(get_user(email))
end

Given(/^has a published certificate$/) do
  @certificate = @response_set.certificate
  @response_set.publish!
end

When(/I visit the certificate page$/) do
  visit dataset_certificate_path(@dataset, @certificate)
end

Then(/I should see the claim button/) do
  page.find(:css, '.certificate li a.btn[href^="#claim"]')
end

Then(/I should see the embed button/) do
  page.find(:css, '.certificate li a.btn[href^="#embed"]')
end
