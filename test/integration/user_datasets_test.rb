require 'test_helper'

class UserDatasetsTest < ActionDispatch::IntegrationTest

  def setup
    @user = FactoryGirl.create(:user)
    @dataset = FactoryGirl.create(:dataset)
  end


  test "user logs in and create dataset" do

    # sign_in user
    post '/users/sign_in', :user => {:email => @user.email, :password => @user.password, :remember_me => 0}

    # dataset is linked to the user
    assert_difference lambda { @user.datasets.count } do
      post '/datasets', :dataset => {title: 'my dataset' }
    end

  end

  # Not sure if this is the correct behaviour
  test "user logs in and visits unclaimed dataset" do

    post '/users/sign_in', :user => {:email => @user.email, :password => @user.password, :remember_me => 0}

    assert_difference lambda { @user.datasets.count } do
      get "/datasets/#{@dataset.id}"
    end

  end

  def teardown
    @user.destroy
    @dataset.destroy
  end
  
end
