require 'test_helper'
require 'rake'
OpenDataCertificate::Application.load_tasks

class OdcRakeTest < ActiveSupport::TestCase

  test "all the surveys in surveys directory parse" do

    files = Dir.entries(File.join(Rails.root, 'surveys')).select { |file| file =~ /.*\.rb/ }

    @result = {}
    files.each do |file|
      @e=nil

      ENV['FILE'] = File.join('surveys', file)
      puts "testing #{ENV['FILE']}"

      begin
        Rake::Task["surveyor"].invoke
      rescue Exception => e
        @e = e
        next
      ensure
        ::Rake::Task.tasks.each { |t| t.reenable } # re-enabling *all* Rake tasks... is there a better way of re-enabling dependencies?
        @result[file] = @e
      end
    end

    # ensure the hash of exceptions caught from parsing the survey files has no values. If it does, join all the execptions
    # together with their filename to aid bugfixing
    assert @result.values.none?, @result.delete_if{|k,v|v.blank?}.map {|k,v| ["survey: #{k}", "#{v}\n"] }.unshift("\n").join("\n")
  end


  test "purge_questionnaires gets rid of unanswered questionnaires" do

    yesterday =  Time.now - 24.hours

    @a = FactoryGirl.create :response_set, user: nil
    @b = FactoryGirl.create :response_set, updated_at: yesterday, user: nil
    @c = FactoryGirl.create :response_set, updated_at: yesterday, user: FactoryGirl.create(:user)

    assert_difference 'ResponseSet.count', -1 do
      Rake::Task["odc:purge_questionnaires"].invoke
    end

    assert ResponseSet.exists? @a
    assert_false ResponseSet.exists? @b
    assert ResponseSet.exists? @c

  end
  
end


