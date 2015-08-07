require 'test_helper'
require 'flow'

class FlowTest < ActiveSupport::TestCase

  include FlowchartHelper
  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @practical = Flow.new("gb", "Practical")
    @legal = Flow.new("gb", "Legal")
    # binding.pry
  end

  test 'initialise Flow Object with an absolute path as parameter' do
    xmlstub = Flow.new(nil, nil, File.join(Rails.root, 'test/fixtures/survey_stubs', "input_field_questions.xml"))
    assert_true xmlstub.present?
  end

  test 'number of questions' do

    xmlstub = Flow.new(nil, nil, File.join(Rails.root, 'test/fixtures/survey_stubs', "empty_questionairre.xml"))
    assert_equal xmlstub.questions.count, 0, "question count should be 0"

  end

  test 'number of dependencies' do
    # dependencies are <question> blocks within <if> blocks
    xmlstub = Flow.new(nil, nil, File.join(Rails.root, 'test/fixtures/survey_stubs', "empty_questionairre.xml"))
    xmlstub.dependencies.each do |d|
      puts d[:id]
    end
    assert_equal xmlstub.dependencies.count, 0, "dependency count should be 0"

  end

  test 'number of answers' do
    # answers will increase for <yesno /> [by 1] <radioset><option ... /radioset> [by n for every <option> entry]
    # <checkboxset> [by n for every <option> entry]
    @ans_count = 0
    xmlstub = Flow.new(nil, nil, File.join(Rails.root, 'test/fixtures/survey_stubs', "empty_questionairre.xml"))
    xmlstub.questions.each do |q|
      if q[:answers].present?
        puts q
        @ans_count = @ans_count + q[:answers].count
        # 3 is gathered from this loop
      end
    end
    # puts "no dependencies"
    xmlstub.dependencies.each do |d|
      if d[:answers].present?
        puts d
        @ans_count = @ans_count + d[:answers].count
      end
    end
    assert_equal @ans_count, 0, "answer count should be 0"
  end


  test 'flowchart halts' do
    # get to a point where flowchart halts and prints end block
    # In each case, there is only one question in the flowchart therefore,
    # the next output should be an end block
    # Halt in question
    question1 = {:id=>"releaseType",
                :label=>"What kind of release is this?",
                :type=>"radioset",
                :level=>nil,
                :answers=>nil
    }
    assert_equal question(question1, 0, nil, [question1]),
      "#{question1[:id]}[\"#{question1[:label]}\"] --> finalSection[\"End\"] \n"
    # Halt in answer
    question2 = {:id=>"releaseType",
                :label=>"What kind of release is this?",
                :type=>"radioset",
                :level=>nil,
                :answers=>
                  {"a one-off release of a single dataset"=>{:dependency=>"timeSensitive"},
                  "a one-off release of a set of related datasets"=>
                    {:dependency=>"timeSensitive"},
                  "ongoing release of a series of related datasets"=>
                    {:dependency=>"frequentChanges"},
                  "a service or API for accessing open data"=>{:dependency=>"serviceType"}
                  }
    }
    answer = {:dependency=>nil}
    assert_equal answer(question2, answer, 1, 0, nil, [question2]),
      "#{question2[:id]}{\"#{question2[:label]}\"} --> |\"1\"| finalSection[\"End\"] \n"
    # Halt in dependency
    dependency = { :id=>"changeFeedUrl",
                   :label=>"Where is your feed of changes?",
                   :type=>"input",
                   :level=>nil,
                   :answers=>nil,
                   :prerequisites=>["changeFeed"]}
    answer = {:dependency=>"changeFeedUrl"}
    assert_equal dependency(question1, answer, 1, 0, [dependency], [question1]),
      " #{question1[:id]}{\"#{question1[:label]}\"}\n#{question1[:id]} --> |\"1\"| #{answer[:dependency]}[\"#{dependency[:label]}\"] \n#{answer[:dependency]}[\"#{dependency[:label]}\"] --> finalSection[\"End\"] \n"
  end

  test 'text answer has dependency' do
    flow = Flow.new("gb", "Legal", File.join(Rails.root, 'test/fixtures/survey_stubs', "text_dependencies.xml"))
    expected = {
      "null" => {
        dependency: nil
      },
      "not null" => {
        dependency: "textDependency"
      }
    }
    assert_equal flow.questions.first[:answers], expected
  end

  test 'one <if> section equates to one prerequisite' do
    passing_stub_path = File.join(Rails.root, 'test/fixtures/survey_stubs', "prerequisites.xml")
    flow = Flow.new(nil,nil,passing_stub_path)
    assert flow.dependencies.first[:prerequisites].present?
  end

  test 'all dependencies should have prerequisites; file practical' do

    # iterate over a hash, count occurrences when an attribute is not nil
    @practical.dependencies.each_with_index do |hash, index|
      assert @practical.dependencies[index][:prerequisites].present?, "#{index} with #{hash[:id]} failed"
      # in this only index 34 should fail - and that is a bug
      # when putting an assert in an enumerable the first false will cause the test to fail
    end

  end

  test 'no questions hash should have prerequisites; file practical' do
    @practical.questions.each_with_index do |hash, index|
      assert @practical.questions[index][:prerequisites].nil?, "#{index} with #{hash[:id]} failed"
      # when putting an assert in an enumerable the first false will cause the test to fail
    end
  end

  test 'all dependencies should have prerequisites; file legal' do

    # iterate over a hash, count occurrences when an attribute is not nil
    @legal.dependencies.each_with_index do |hash, index|
      assert @legal.dependencies[index][:prerequisites].present?, "#{index} with #{hash[:id]} failed"
    end

  end

  test 'no questions hash should have prerequisites; file legal' do
    @legal.questions.each_with_index do |hash, index|
      assert @legal.questions[index][:prerequisites].nil?, "#{index} with #{hash[:id]} failed"
    end
  end

  test 'text answer has nil dependency when there is no dependency present' do
    flow = Flow.new("gb", "Legal", File.join(Rails.root, 'test/fixtures/survey_stubs', "input_field_questions.xml"))
    assert_equal flow.questions.first[:answers], nil
  end

end