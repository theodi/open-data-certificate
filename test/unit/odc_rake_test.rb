require 'test_helper'
require 'rake'
OpenDataCertificate::Application.load_tasks

class OdcRakeTest < ActiveSupport::TestCase

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
    ENV['FILE'] = File.join 'surveys', 'odc_questionnaire.UK.rb'

    assert_difference 'Survey.count', 1 do
      Rake::Task["surveyor"].reenable
      Rake::Task["surveyor"].invoke
    end
  end

  test "The US survey parses correctly" do
    ENV['FILE'] = File.join 'surveys', 'odc_questionnaire.US.rb'

    assert_difference 'Survey.count', 1 do
      Rake::Task["surveyor"].reenable
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

  test "Survey translations are valid yaml" do
    translationDir = Rails.root.join('surveys','translations')

    files = Dir.entries(translationDir).select { |file| file =~ /.*\.yml$/ }

    files.each do |file|
      contents = translationDir.join(file).read
      begin
        YAML.load(contents)
      rescue Psych::SyntaxError => e
        flunk "Syntax Error in #{file} - #{e}"
      end
    end
  end


  test "build_changed_surveys doesn't build twice" do
    ENV['DIR'] = 'test/fixtures/surveys'
  
    assert_difference 'Survey.count', 3 do
      Rake::Task["surveyor:build_changed_surveys"].invoke
    end

    assert_no_difference 'Survey.count' do
      Rake::Task["surveyor:build_changed_surveys"].invoke
    end

  end


  test "build_changed_surveys can be limited" do
    ENV['DIR'] = 'test/fixtures/surveys'
    ENV['LIMIT'] = '1'

    assert_difference 'Survey.count', 1 do
      Rake::Task["surveyor:build_changed_surveys"].invoke
    end

    assert_no_difference 'Survey.count' do
      Rake::Task["surveyor:build_changed_surveys"].invoke
    end

  end


  test "build changed survey for single file" do
    ENV['FILE'] = 'test/fixtures/surveys/one.rb'

    assert_difference 'Survey.count', 1 do
      Rake::Task["surveyor:build_changed_survey"].invoke
    end

    assert_no_difference 'Survey.count' do
      Rake::Task["surveyor:build_changed_survey"].invoke
    end

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

  test "enqueue_surveys" do
    ENV['DIR'] = 'test/fixtures/surveys'

    assert_difference 'Delayed::Job.count', 3 do
      assert_difference 'Delayed::Job.where(priority:1).count', 1,  'The default survey is prioritised' do
        assert_difference 'Delayed::Job.where(priority:2).count', 1,  'The alpha survey is prioritised' do
          Rake::Task["surveyor:enqueue_surveys"].invoke
        end
      end
    end

    assert_difference 'Survey.count', 3, "surveys were generated" do
      Delayed::Worker.new({exit_on_complete: true}).start
    end

    assert_equal Delayed::Job.count, 0, "all jobs were processed"

  end

  def teardown
    SurveyParsing.destroy_all
    ::Rake::Task.tasks.each { |t| t.reenable }
    ENV['DIR'] = nil
    ENV['FILE'] = nil
    ENV['LIMIT'] = nil
  end

end
