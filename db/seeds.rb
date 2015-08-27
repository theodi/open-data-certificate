# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

admin = User.where(admin: true).create!(
  email: "test@example.com",
  password: "testtest"
)
admin.confirm!

builder = SurveyBuilder.new('surveys', 'odc_questionnaire.GB.rb')
builder.perform
