# require 'test_helper'
# require File.join(Rails.root, 'lib/extra/certificate_dump')
# require File.join(Rails.root, 'lib/extra/stats_dump')
# 
# class DataDumpTest < ActionDispatch::IntegrationTest
#   
#   def service
#     Fog::Storage.new({
#       :provider            => 'Rackspace',
#       :rackspace_username  => ENV['RACKSPACE_USERNAME'],
#       :rackspace_api_key   => ENV['RACKSPACE_API_KEY'],
#       :rackspace_auth_url  => Fog::Rackspace::UK_AUTH_ENDPOINT,
#       :rackspace_region    => :lon
#     })
#   end
#   
#   def dir
#     service.directories.get ENV['RACKSPACE_CERTIFICATE_DUMP_CONTAINER']
#   end
#   
#   def teardown
#     dir.files.all.each { |file| file.destroy }
#   end
# 
#   test "JSON dump gets dumped with the correct data to Rackspace" do        
#     10.times do
#       FactoryGirl.create(:published_certificate_with_dataset)
#     end
#     
#     CertificateDump.current
#     file = dir.files.get "certificates.json"
#     json = JSON.parse(file.body)
#     
#     assert_not_nil file
#     assert_equal "application/json", file.content_type
#     assert_equal 10, json["certificates"].length
#   end
#   
#   test "JSON dump gets updated with updated data when the update task is run" do    
#     10.times do
#       FactoryGirl.create(:published_certificate_with_dataset)
#     end
#     
#     CertificateDump.current
#     
#     updated = Certificate.where(:published => true).first
#     updated.attained_level = "standard"
#     updated.save
#     
#     new = FactoryGirl.create(:published_certificate_with_dataset)
#     
#     CertificateDump.latest
#         
#     file = dir.files.get "certificates.json"
#     json = JSON.parse(file.body)
#         
#     assert_equal 11, json["certificates"].length
#     assert_equal "Standard", json["certificates"][dataset_certificate_url(updated.dataset, updated)]["level"]
#   end
#   
#   test "Certificate delayed job runs the current task when a file does not exist" do
#     CertificateDump.expects(:current).once
#     CertificateDump.perform
#   end
#   
#   test "Certificate delayed job runs the latest task when a file exists" do  
#     10.times do
#       FactoryGirl.create(:published_certificate_with_dataset)
#     end
#     CertificateDump.current
#     
#     CertificateDump.expects(:latest).once
#     CertificateDump.perform
#   end
#   
#   test "Statistics dump gets dumped with the correct data to Rackspace" do
#     levels = {
#       :basic    => 7,
#       :pilot    => 6,
#       :standard => 5,
#       :expert   => 4
#       }
#     
#     levels[:basic].times do
#       FactoryGirl.create(:published_certificate_with_dataset)
#     end
#     
#     levels[:pilot].times do
#       FactoryGirl.create(:published_pilot_certificate_with_dataset)
#     end
#   
#     levels[:standard].times do
#       FactoryGirl.create(:published_standard_certificate_with_dataset)
#     end
#   
#     levels[:expert].times do
#       FactoryGirl.create(:published_expert_certificate_with_dataset)
#     end
#     
#     StatsDump.setup
#   
#     file = dir.files.get "statistics.csv"
#     csv = CSV.parse(file.body)
#         
#     assert_not_nil file
#     assert_equal "text/csv", file.content_type
#     assert_equal levels.values.sum.to_s, csv[1][3]
#     assert_equal levels[:basic].to_s, csv[1][6]
#     assert_equal levels[:pilot].to_s, csv[1][7]
#     assert_equal levels[:standard].to_s, csv[1][8]
#     assert_equal levels[:expert].to_s, csv[1][9]
#   end
#   
#   test "Statistics dump appends data to statistics CSV" do
#     10.times do
#       FactoryGirl.create(:published_certificate_with_dataset)
#     end
#     
#     StatsDump.setup
#     
#     10.times do
#       FactoryGirl.create(:published_certificate_with_dataset)
#     end
#     
#     StatsDump.latest
#     
#     file = dir.files.get "statistics.csv"
#     csv = CSV.parse(file.body)
#       
#     assert_not_nil file
#     assert_equal 3, csv.count
#   end
#   
#   test "Statistics delayed job runs the setup task when a file does not exist" do
#     StatsDump.expects(:setup).once
#     StatsDump.perform
#   end
#   
#   test "Statistics delayed job runs the latest task when a file exists" do  
#     10.times do
#       FactoryGirl.create(:published_certificate_with_dataset)
#     end
#     StatsDump.setup
#     
#     StatsDump.expects(:latest).once
#     StatsDump.perform
#   end
# 
# end