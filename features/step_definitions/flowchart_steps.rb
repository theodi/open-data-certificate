# encoding: utf-8
require 'pry'

legal_markdown = File.read(File.join Rails.root, 'fixtures', 'legal_markdown.txt')
practical_markdown = File.read(File.join Rails.root, 'fixtures', 'practical_markdown.txt')

When(/^I navigate to "(.*?)"$/) do |url|
  visit "#{url}"
end

When(/^I select "(.*?)" from the "(.*?)" dropdown$/) do |text, field|
  page.select text, :from => field
end

When(/^I press "(.*?)"$/) do |name|
  click_button name
end

Then(/^the page should contain legal markdown$/) do
  assert_equal page.find('.mermaid').text.gsub(/\s+/, ""), legal_markdown.gsub(/\s+/, "")
end

Then(/^the page should contain practical markdown$/) do
  assert_equal page.find('.mermaid').text.gsub(/\s+/, ""), practical_markdown.gsub(/\s+/, "")
end
