Given(/^I visit the edit account page$/) do
  visit edit_user_registration_path(@user)
end

When(/^I enter an organization of "(.*?)"$/) do |organization|
  @organization = organization
  first('#user_organization').set(organization)
end

When(/^I agree to the terms$/) do
  first('#user_agreed_to_terms').set(true)
end

When(/^I do not agree to the terms$/) do
  first('#user_agreed_to_terms').set(false)
end

When(/^I enter my password$/) do
  first('#user_current_password').set('password')
end

When(/^I click save$/) do
  click_on 'Update my profile'
end

Then(/^there is an error message about agreeing to terms$/) do
  assert_text('Errors occurred')
end

Then(/^there is no error message$/) do
  assert_no_text('Errors occurred')
end

Then(/^my changes are saved$/) do
  assert_equal @organization, @user.reload.organization
end

Then(/^my changes are not saved$/) do
  refute_equal @organization, @user.reload.organization
end
