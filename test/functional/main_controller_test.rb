require_relative '../test_helper'

class MainControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "homepage" do
    get :home, locale: 'en'
    assert_response 200
  end

  test "status shows correct stats" do
    all = FactoryGirl.create(:all_stat,
                              all: 10,
                              expired: 5,
                              publishers: 5,
                              this_month: 2,
                              level_none: 6,
                              level_basic: 5,
                              level_pilot: 4,
                              level_standard: 3,
                              level_exemplar: 2
                            )

    published = FactoryGirl.create(:published_stat,
                                    all: 20,
                                    expired: 10,
                                    publishers: 10,
                                    this_month: 4,
                                    level_none: 12,
                                    level_basic: 11,
                                    level_pilot: 10,
                                    level_standard: 9,
                                    level_exemplar: 8
                                  )

    get :status
    assert_response 200

    html = Nokogiri::HTML response.body
    heading_indexes = Hash[html.css('table tr:first-child th').each_with_index.map {|n, i| [n.text.downcase, i+1]}]
    published_row = ->(index) { html.css("table tr:nth-child(3) td:nth-child(#{index})").text }
    all_row = ->(index) { html.css("table tr:nth-child(5) td:nth-child(#{index})").text }
    # the rowspan of the levels heading offets the count by one for levels
    published_level = ->(index) { published_row.call(index-1) }
    all_level = ->(index) { all_row.call(index-1) }

    assert_equal all.all.to_s, all_row.call(heading_indexes['all'])
    assert_equal all.expired.to_s, all_row.call(heading_indexes['expired'])
    assert_equal all.publishers.to_s, all_row.call(heading_indexes['publishers'])
    assert_equal all.this_month.to_s, all_row.call(heading_indexes['this month'])
    assert_equal all.level_none.to_s, all_level.call(heading_indexes['none'])
    assert_equal all.level_basic.to_s, all_level.call(heading_indexes['basic'])
    assert_equal all.level_pilot.to_s, all_level.call(heading_indexes['pilot'])
    assert_equal all.level_standard.to_s, all_level.call(heading_indexes['standard'])
    assert_equal all.level_exemplar.to_s, all_level.call(heading_indexes['exemplar'])

    assert_equal published.all.to_s, published_row.call(heading_indexes['all'])
    assert_equal published.expired.to_s, published_row.call(heading_indexes['expired'])
    assert_equal published.publishers.to_s, published_row.call(heading_indexes['publishers'])
    assert_equal published.this_month.to_s, published_row.call(heading_indexes['this month'])
    assert_equal published.level_none.to_s, published_level.call(heading_indexes['none'])
    assert_equal published.level_basic.to_s, published_level.call(heading_indexes['basic'])
    assert_equal published.level_pilot.to_s, published_level.call(heading_indexes['pilot'])
    assert_equal published.level_standard.to_s, published_level.call(heading_indexes['standard'])
    assert_equal published.level_exemplar.to_s, published_level.call(heading_indexes['exemplar'])
  end

  test "status shows correct number of embedded certificates" do
    FactoryGirl.create(:all_stat)
    FactoryGirl.create(:published_stat)

    5.times do |i|
      dataset = FactoryGirl.create :dataset
      dataset.register_embed("http://example#{i}.com")
    end

    get :status
    assert_response 200

    html = Nokogiri::HTML response.body

    assert_match /5 certificates\nembedded/, html.css('.embedded').first.text
  end

  test "status csv shows correct stats" do
    5.times do
      FactoryGirl.create(:all_stat)
    end

    2.times do
      FactoryGirl.create(:published_stat)
    end

    get :status, format: "csv", type: "all"

    assert_equal "text/csv; header=present; charset=utf-8", response.headers["Content-Type"]
    assert_match "attachment; filename=\"all.csv\"", response.headers["Content-Disposition"]
    assert_equal 6, CSV.parse(response.body).count

    get :status, format: "csv", type: "published"

    assert_equal 3, CSV.parse(response.body).count
  end

  test "has_js" do
    get :has_js
    assert_response 200
    assert_equal session[:surveyor_javascript], 'enabled'
  end

  # survey creating has been moved into the application controller

  def setup
    @survey_other        = FactoryGirl.create :survey, access_code: 'other'
    @survey_user_default = FactoryGirl.create :survey, access_code: 'user_default'
    @survey_app_default  = FactoryGirl.create :survey, access_code: 'gb'
  end

  test "start_questionnaire with app default jurisdiction" do

    post :start_questionnaire, locale: 'en'
    assert assigns(:response_set).survey == @survey_app_default

  end

  test "start_questionnaire with user default_jurisdiction set" do

    sign_in FactoryGirl.create(:user, default_jurisdiction: 'user_default')
    post :start_questionnaire, locale: 'en'
    assert assigns(:response_set).survey == @survey_user_default

  end

  test "start_questionnaire with custom param" do

    post :start_questionnaire, locale: 'en', survey_access_code: 'other'
    assert assigns(:response_set).survey == @survey_other

  end

  test "start_questionnaire entities belongs to user" do
    sign_in @user = FactoryGirl.create(:user)

    post :start_questionnaire, locale: 'en'
    assert_equal assigns(:response_set).user_id, @user.id, "response set belongs to user"
    assert_equal assigns(:dataset).user_id, @user.id, "dataset belongs to user"
  end

  test "ping page returns ok" do
    get :ping
    assert_response 200
  end

  test "ping page checks status of database" do
    ActiveRecord::Base.connection.stubs(:active?).returns(false)
    get :ping
    assert_response 503
  end

  test "ping is available on status/ping" do
    assert_routing '/status/ping', controller: 'main', action: 'ping'
  end

end
