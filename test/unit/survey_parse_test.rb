require 'test_helper'
require 'rake'

class SurveyParseTest < ActiveSupport::TestCase

  # We are no longer testing all surveys (as there are ~250 now), instead we test (below) if:
  #   * the UK parses correctly
  #   * all files are all syntactically correct ruby
  #
  # test "all the surveys in surveys directory parse" do
  #   require 'rake'
  #   OpenDataCertificate::Application.load_tasks
  #
  #   files = Dir.entries(File.join(Rails.root, 'surveys')).select { |file| file =~ /.*\.rb$/ }
  #
  #   @result = {}
  #   files.each do |file|
  #     @e=nil
  #
  #     ENV['FILE'] = File.join('surveys', file)
  #     puts "testing #{ENV['FILE']}"
  #
  #     begin
  #       Rake::Task["surveyor"].invoke
  #     rescue Exception => e
  #       @e = e
  #       next
  #     ensure
  #       ::Rake::Task.tasks.each { |t| t.reenable } # re-enabling *all* Rake tasks... is there a better way of re-enabling dependencies?
  #       @result[file] = @e
  #     end
  #   end
  #
  #   # ensure the hash of exceptions caught from parsing the survey files has no values. If it does, join all the execptions
  #   # together with their filename to aid bugfixing
  #   assert @result.values.none?, @result.delete_if{|k,v|v.blank?}.map {|k,v| ["survey: #{k}", "#{v}\n"] }.unshift("\n").join("\n")
  # end

  test "The default survey parses correctly" do
    OpenDataCertificate::Application.load_tasks
    ENV['FILE'] = File.join 'surveys', 'odc_questionnaire.UK.rb'

    assert_difference 'Survey.count', 1 do
      Rake::Task["surveyor"].invoke
    end
  end

  test "Surveys have valid ruby syntax" do

    surveyDir = Rails.root.join('surveys')

    files = Dir.entries(surveyDir).select { |file| file =~ /.*\.rb$/ }

    files.each do |file|

      # a stub for evaluating the file within
      parse_stub = stub(:survey)

      contents = surveyDir.join(file).read
      parse_stub.instance_eval(contents)
    end
    
    # consider things cool if we got here without breaking
  end


end


