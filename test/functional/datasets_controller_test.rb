require 'test_helper'

class DatasetsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "index shows all published certificates" do
    5.times do
      FactoryGirl.create(:published_certificate_with_dataset)
    end
    5.times do
      FactoryGirl.create(:certificate_with_dataset)
    end

    get :index

    assert_response :success
    assert_equal 5, assigns(:certificates).size
    assert assigns(:certificates).first.published
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

    get :typeahead, mode: 'dataset', q: 'second'
    assert_response 200

    assert_equal [
      {
        "value" =>'my second dataset',
        "path" => "/datasets/#{@second.id}"
      }
    ], assigns(:response)

  end

  test "typeahead for publisher" do
    @first  = FactoryGirl.create(:certificate, curator: 'curator one')
    @second = FactoryGirl.create(:certificate, curator: 'curator two')

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
    @first  = FactoryGirl.create(:survey, full_title:'United Kingdom', title:'GB')
    @second = FactoryGirl.create(:survey, full_title:'Andorra', title: 'AD')

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
