Given(/^I have a a dataset at the URL "(.*?)"$/) do |url|
  @url = url
end

Given(/^I run the rake task to create a single certificate$/) do
  require "rake"
  ENV['URL'] = @url
  ENV['USER_ID'] = @api_user.id.to_s
  @rake = Rake::Application.new
  Rake.application = @rake
  Rake.application.rake_require "tasks/certificate_factory"
  Rake::Task.define_task(:environment)
  @rake['certificate'].invoke
end

Given(/^the background jobs have all completed$/) do
  Delayed::Job.all.each { |j| j.invoke_job }
end

Then(/^there should be (\d+) certificate$/) do |count|
  assert_equal count.to_i, Certificate.count
end


end
