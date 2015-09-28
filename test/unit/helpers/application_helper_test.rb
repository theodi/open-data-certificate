# encoding: utf-8
require_relative '../../test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'scopes the locale' do
    I18n.locale = :en
    called = false

    scope_locale :fr do
      assert_equal :fr, I18n.locale
      called = true
    end

    assert_equal :en, I18n.locale
    assert called
  end

  test 'converts markdown' do

    source = '**hello** world'
    result = markdown(source)
    expected = "<p><strong>hello</strong> world</p>\n"

    assert_equal expected, result

    assert result.html_safe?

  end

  test "kitten_field with data present" do
    kd = KittenData.new
    kd.data[:release_date] = "a value"

    output = kitten_field(kd, :release_date)
    assert_match /<dt>Release Date<\/dt>/, output
    assert_match /<dd>a value<\/dd>/, output
  end

  test "blank kitten_field" do
    kd = KittenData.new
    assert_equal nil, kitten_field(kd, :field)
  end

  test "kitten_value for unknown object" do
    obj = mock("a thing", :to_s => "correct")
    assert_equal "correct", kitten_value(obj)
  end

  test "kitten_value for string" do
    assert_equal "a string", kitten_value("a string")
  end

  test "kitten_value for hash uses title value" do
    assert_equal "a title", kitten_value({value: "hi", title: "a title"})
  end

  test "kitten_value for array calls kitten_value on each element" do
    a = mock("a", :to_s => "one")
    b = mock("b", :to_s => "two")

    assert_equal "one, two", kitten_value([a, b])
  end

  test "kitten_value for an agent creates email link" do
    name = DataKitten::Agent.new(name: "Chell")
    contact = DataKitten::Agent.new(name: "GladOS", mbox: "glados@apeturelabs.com")

    assert_equal "Chell", kitten_value(name)
    assert_match /GladOS/, kitten_value(contact)
    assert_match /mailto:glados@apeturelabs.com/, kitten_value(contact)
  end

  test "kitten_value for Date formats well" do
    assert_equal "27 April 2014", kitten_value(Date.new(2014, 4, 27))
  end

  test "kitten_value for temporal field" do
    open = DataKitten::Temporal.new(start: Date.new(2014, 4, 27))
    closed = DataKitten::Temporal.new(end: Date.new(2014, 4, 27))
    complete = DataKitten::Temporal.new(start: Date.new(2014, 4, 1), end: Date.new(2014, 4, 27))

    assert_equal "27 April 2014", kitten_value(open)
    assert_equal "27 April 2014", kitten_value(closed)
    assert_equal "1 April 2014 — 27 April 2014", kitten_value(complete)
  end

  test "kitten_value for license field" do
    license = DataKitten::License.new(name: "CC", uri: "http://example.com/cc")

    assert_equal '<a href="http://example.com/cc">CC</a>', kitten_value(license)
  end

  test "kitten_value for rights" do
    rights = DataKitten::Rights.new(uri: "http://example.com/rights")

    assert_equal '<a href="http://example.com/rights">Rights statement</a>', kitten_value(rights)
  end

  test "kitten_value for blank rights object" do
    blank_rights = DataKitten::Rights.new(uri: nil)
    assert_equal nil, kitten_value(blank_rights)
  end

  test "example dataset" do
    FactoryGirl.create_list(:published_basic_certificate_with_dataset, 3)
    pilot = FactoryGirl.create(:published_pilot_certificate_with_dataset)

    expected_link = link_to('See an example certificate', dataset_latest_certificate_path(:en, pilot.dataset), :class => ['btn', 'btn-large'])

    assert_equal expected_link, example_certificate_link
  end
end
