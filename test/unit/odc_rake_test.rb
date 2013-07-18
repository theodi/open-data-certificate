require 'test_helper'

class OdcRakeTest < ActiveSupport::TestCase

  test "all the surveys in surveys directory parse" do
    require 'rake'
    OpenDataCertificate::Application.load_tasks

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
  
end


