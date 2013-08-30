require 'test_helper'

class DatasetsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "index shows all published datasets" do
    5.times do
      FactoryGirl.create(:published_certificate_with_dataset)
    end
    5.times do
      FactoryGirl.create(:certificate_with_dataset)
    end

    get :index

    assert_response :success
    assert_equal 5, assigns(:datasets).size
    assert assigns(:datasets).first.response_set.published?
  end

  test "index filters by jurisdiction" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    FactoryGirl.create(:published_certificate_with_dataset)
    FactoryGirl.create(:certificate_with_dataset)

    cert.response_set.survey.update_attribute(:title, 'UK')

    get :index, jurisdiction: 'UK'

    assert_response :success
    assert_equal [cert.dataset], assigns(:datasets)
  end

  test "index filters by publisher" do
    cert = FactoryGirl.create(:published_certificate_with_dataset)
    FactoryGirl.create(:published_certificate_with_dataset)
    FactoryGirl.create(:certificate_with_dataset)

    cert.update_attribute(:curator, 'theodi')

    get :index, publisher: 'theodi'

    assert_response :success
    assert_equal [cert.dataset], assigns(:datasets)
  end


  test "index (non logged in)" do
    get :dashboard
    assert_response :redirect
  end

  test "index no response sets" do
    sign_in FactoryGirl.create(:user)
    get :dashboard
    assert_response 200
  end

  test "index response sets" do
    sign_in FactoryGirl.create(:user_with_responses)
    get :dashboard
    assert_response 200
    assert assigns(:datasets).size > 0
  end

  test "typeahead for datasets" do
    @first  = FactoryGirl.create(:dataset, title:'my first dataset')
    @second = FactoryGirl.create(:dataset, title:'my second dataset')

    FactoryGirl.create(:published_response_set, dataset: @first)
    FactoryGirl.create(:published_response_set, dataset: @second)

    get :typeahead, mode: 'dataset', q: 'second'
    assert_response 200
    
    assert_equal [
      {
        "attained_index" => nil,
        "value" =>'my second dataset',
        "path" => "/datasets/#{@second.id}"
      }
    ], assigns(:response)

  end

  test "typeahead for publisher" do
    @first  = FactoryGirl.create(:published_certificate_with_dataset, curator: 'curator one')
    @second = FactoryGirl.create(:published_certificate_with_dataset, curator: 'curator two')

    # FactoryGirl.create(:published_response_set, certificate: @first)
    # FactoryGirl.create(:published_response_set, certificate: @second)

    get :typeahead, mode: 'publisher', q: 'one'
    assert_response 200

    assert_equal [
      {
        "value" =>'curator one',
        "path" => "/datasets?publisher=curator+one"
      }
    ], assigns(:response)

  end

  test "typeahead for country" do
    FactoryGirl.create(:survey, full_title:'UnitedKingdam', title:'GB', survey_version: 1)
    @gb = FactoryGirl.create(:survey, full_title:'United Kingdom', title:'GB', survey_version: 2)
    FactoryGirl.create(:survey, full_title:'United States', title:'US')
    FactoryGirl.create(:survey, full_title:'Andorra', title: 'AD')

    # only shows countries with published response sets
    FactoryGirl.create(:response_set, survey: @gb).publish!

    get :typeahead, mode: 'country', q: 'united'
    assert_response 200

    assert_equal [
      {
        "value" =>'United Kingdom',
        "path" => "/datasets?jurisdiction=GB"
      }
    ], assigns(:response)

  end
  
end
