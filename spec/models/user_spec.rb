require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do

  it "gets a list of engaged users" do
    5.times { FactoryGirl.create :user }
    5.times { FactoryGirl.create :confirmed_user }
    5.times { FactoryGirl.create :engaged_user }

    engaged_users = User.engaged_users

    expect(engaged_users.count).to eq(5)

    engaged_users.each do |e|
      expect(e.has_engaged?).to eq(true)
    end
  end

  it "should let us know if a user is engaged or not" do
    user = FactoryGirl.create :engaged_user

    expect(user.has_engaged?).to eq(true)
  end

end
