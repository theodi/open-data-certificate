require 'test_helper'
require File.join(Rails.root, 'lib/tasks/data_dump')

class DataDumpTest < ActionDispatch::IntegrationTest

  test "JSON dump gets dumped with the correct data to Rackspace" do      
    service = Fog::Storage.new({
        :provider            => 'Rackspace',
        :rackspace_username  => ENV['RACKSPACE_USERNAME'],
        :rackspace_api_key   => ENV['RACKSPACE_API_KEY'],
        :rackspace_auth_url  => Fog::Rackspace::UK_AUTH_ENDPOINT,
        :rackspace_region    => :lon
    })
    
    dir = service.directories.get ENV['RACKSPACE_CERTIFICATE_DUMP_CONTAINER']
    dir.files.all.each { |file| file.destroy }
    
    10.times do
      FactoryGirl.create(:published_certificate_with_dataset)
    end
    
    DataDump.current
    file = dir.files.get "certificates.json"
    json = JSON.parse(file.body)
    
    assert_not_nil file
    assert_equal "application/json", file.content_type
    assert_equal 10, json["certificates"].length
  end
  
  test "JSON dump gets updated with updated data when the update task is run" do
    service = Fog::Storage.new({
        :provider            => 'Rackspace',
        :rackspace_username  => ENV['RACKSPACE_USERNAME'],
        :rackspace_api_key   => ENV['RACKSPACE_API_KEY'],
        :rackspace_auth_url  => Fog::Rackspace::UK_AUTH_ENDPOINT,
        :rackspace_region    => :lon
    })
    
    dir = service.directories.get ENV['RACKSPACE_CERTIFICATE_DUMP_CONTAINER']
    dir.files.all.each { |file| file.destroy }
    
    10.times do
      FactoryGirl.create(:published_certificate_with_dataset)
    end
    
    DataDump.current
    
    updated = Certificate.where(:published => true).first
    updated.attained_level = "standard"
    updated.save
    
    new = FactoryGirl.create(:published_certificate_with_dataset)
    
    DataDump.latest
        
    file = dir.files.get "certificates.json"
    json = JSON.parse(file.body)
        
    assert_equal 11, json["certificates"].length
    assert_equal "Standard", json["certificates"][dataset_certificate_url(updated.dataset, updated)]["level"]
  end

end