require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'user_export'

describe UserExport do

  before(:each) do
    @users = []
    5.times { |i| @users << FactoryGirl.create(:engaged_user, name: "User #{i}", email: "user#{i}@example.com") }

    @csv = "Name,Email\nUser 0,user0@example.com\nUser 1,user1@example.com\nUser 2,user2@example.com\nUser 3,user3@example.com\nUser 4,user4@example.com\n"
  end

  it "returns list of users" do
    expect(UserExport.users).to eq(@users)
  end

  it "returns a CSV of users" do
    expect(UserExport.csv).to eq(@csv)
  end

  it "writes to a Tempfile" do
    buffer = StringIO.new()
    allow(Tempfile).to receive(:new).and_return( buffer )

    tmp = UserExport.write_file

    expect(tmp.string).to eq(@csv)
  end

  it "uploads a file" do
    expect(Rackspace).to receive(:upload).with('users.csv', instance_of(File), {
      content_type: 'text/csv',
      content_disposition: 'attachment',
      public: true
    })

    UserExport.upload
  end

  it "Uploads and returns a URL" do
    upload = double(Fog::Storage::Rackspace::File, public_url: "http://www.example.com/example.csv")
    expect(Rackspace).to receive(:upload) { upload }

    expect(UserExport.perform).to eq('http://www.example.com/example.csv')
  end

end
