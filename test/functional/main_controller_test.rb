require 'test_helper'

class MainControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "homepage" do
    get :home
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

    assert_match /#{all.all}/, html.css('.all-all').first.text
    assert_match /#{all.expired}/, html.css('.all-expired').first.text
    assert_match /#{all.publishers}/, html.css('.all-publishers').first.text
    assert_match /#{all.this_month}/, html.css('.all-this_month').first.text
    assert_match /#{all.level_none}/, html.css('.all-none').first.text
    assert_match /#{all.level_basic}/, html.css('.all-basic').first.text
    assert_match /#{all.level_pilot}/, html.css('.all-pilot').first.text
    assert_match /#{all.level_standard}/, html.css('.all-standard').first.text
    assert_match /#{all.level_exemplar}/, html.css('.all-exemplar').first.text

    assert_match /#{published.all}/, html.css('.published-all').first.text
    assert_match /#{published.expired}/, html.css('.published-expired').first.text
    assert_match /#{published.publishers}/, html.css('.published-publishers').first.text
    assert_match /#{published.this_month}/, html.css('.published-this_month').first.text
    assert_match /#{published.level_none}/, html.css('.published-none').first.text
    assert_match /#{published.level_basic}/, html.css('.published-basic').first.text
    assert_match /#{published.level_pilot}/, html.css('.published-pilot').first.text
    assert_match /#{published.level_standard}/, html.css('.published-standard').first.text
    assert_match /#{published.level_exemplar}/, html.css('.published-exemplar').first.text
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

    post :start_questionnaire
    assert assigns(:response_set).survey == @survey_app_default

  end

  test "start_questionnaire with user default_jurisdiction set" do

    sign_in FactoryGirl.create(:user, default_jurisdiction: 'user_default')
    post :start_questionnaire
    assert assigns(:response_set).survey == @survey_user_default

  end

  test "start_questionnaire with custom param" do

    post :start_questionnaire, survey_access_code: 'other'
    assert assigns(:response_set).survey == @survey_other

  end

  test "start_questionnaire entities belongs to user" do
    sign_in @user = FactoryGirl.create(:user)

    post :start_questionnaire
    assert_equal assigns(:response_set).user_id, @user.id, "response set belongs to user"
    assert_equal assigns(:dataset).user_id, @user.id, "dataset belongs to user"
  end

end
