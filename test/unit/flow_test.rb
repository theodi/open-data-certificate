require 'test_helper'

class FlowTest < ActiveSupport::TestCase

  include FlowchartHelper
  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @practical_flowchart = Flow.new("gb", "Practical")
    # @practical = Flow.new("gb", "Practical")
    # @prac_questions = @practical.questions
    # @legal = Flow.new("gb", "Legal")
    # @legal_questions = @legal.questions
  end

  # need a stub or fake NOKOgiri XML element
  #
  # create some data structures that test _question > answer > dependency single flow
  # create some data structures that test _question > _answer > _dependency and iteration between _answer & _dependency

  test 'initialise Flow Object with an absolute path as parameter' do
    xmlstub = Flow.new(nil, nil, File.join(Rails.root, 'test/fixtures/survey_stubs', "input_field_questions.xml"))
    assert_true xmlstub.present?
  end

  test 'number of questions' do

    xmlstub = Flow.new(nil, nil, File.join(Rails.root, 'test/fixtures/survey_stubs', "test2.legal.xml"))
    assert_equal xmlstub.questions.count, 0, "question count should be 0"
    # assert_equal (xmlstub.questions.count + xmlstub.dependencies.count), 3, "question count should be 3 with 0 dependencies"
    #puts "questions only"
    #assert_true (xmlstub.questions.count.eql?(3) && xmlstub.dependencies.count.eql?(0)), "question count should be 3 with 0 dependencies"
  end

  test 'number of dependencies' do
    # dependencies are <question> blocks within <if> blocks
    xmlstub = Flow.new(nil, nil, File.join(Rails.root, 'test/fixtures/survey_stubs', "test2.legal.xml"))
    xmlstub.dependencies.each do |d|
      puts d[:id]
    end
    assert_equal xmlstub.dependencies.count, 0, "dependency count should be 0"
    #assert_true (xmlstub.questions.count.eql?(3) && xmlstub.dependencies.count.eql?(1)), "question count should be 3 with 1 dependencies"
  end

  test 'number of answers' do
    # answers will increase for <yesno /> [by 1] <radioset><option ... /radioset> [by n for every <option> entry]
    # <checkboxset> [by n for every <option> entry]
    @ans_count = 0
    xmlstub = Flow.new(nil, nil, File.join(Rails.root, 'test/fixtures/survey_stubs', "test2.legal.xml"))
    # xmlstub = Flow.new(nil, nil, File.join(Rails.root, 'test/fixtures/survey_stubs', "test.legal.xml"))
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

  test 'all dependencies should have prerequisites' do
    passing_stub_path = File.join(Rails.root, 'test/fixtures/survey_stubs', "prerequisites.xml")
    passing_stub = Nokogiri::XML(File.open(passing_stub_path))
    # passing_stub.xpath("//question").map
    flow = Flow.new(nil,nil,passing_stub_path)
    # binding.pry
    # assert flow.dependencies.first[:prerequisites].present?
    # to make the above more robust it would be nice to have
    # iterate over a hash, count occurrences when an attribute is not nil
    @practical_flowchart.dependencies.each_with_index do |hash, index|
      assert @practical_flowchart.dependencies[index][:prerequisites].present?, "#{index} failed"
      # when putting an assert in an enumerable the first false will cause the test to fail
    end
    # xmlstub = Flow.new(nil, nil, File.join(Rails.root, 'test/fixtures/survey_stubs', "prerequisites.xml"))
    # assert_equal xmlstub.prerequisites.count, 0, "prerequisite count should be 0"

  end

  test 'text answer has nil dependency when there is no dependency present' do
    flow = Flow.new("gb", "Legal", File.join(Rails.root, 'test/fixtures/survey_stubs', "input_field_questions.xml"))
    assert_equal flow.questions.first[:answers], nil
  end

end
  # test 'practical: check that no prerequisites created in questions' do
  #   @practical_flowchart.questions.each do |q|
  #     assert_true q[:prerequisites].eql?(nil), "no prerequisites created in questions"
  #   end
  # end
  #
  # test 'check that prerequisites created in dependencies' do
  #   @practical_flowchart.dependencies.each do |d|
  #     assert_true d[:prerequisites].present?, "prerequisites created in dependencies"
  #   end
  # end
  #
  # test 'check that all dependencies have only one prerequisite' do
  #   @practical_flowchart.dependencies.each do |d|
  #     assert_true d[:prerequisites].count <= 1, "the hash of id #{d[:id]} has many prerequisites #{d[:prerequisites]}"
  #     # edge case == the hash of id `timeSensitive` has many prerequisites ["releaseType", "releaseType", "releaseType", "serviceType"]
  #     # edge case == the hash of id publisherOrigin has many prerequisites ["publisherRights", "publisherRights"].
  #   end
  # end
  #
  # test 'check that all questions have a Hash of Hash answers' do
  #   assert_true @practical_flowchart.dependencies.count == @dependencies.count {|q| q[:answers].present? }, "dependencies all have a hash of answers"
  #   # @dependencies.find_all {|q| q[:answers].nil? }.each do |q| puts q[:id] end;
  #   # ^~> this one liner will return all dependencies with 0 answer hashes
  #   # @dependencies.find_all {|q| q[:answers].present? }.each do |q| puts q[:id] end;
  #   # ^~> this one liner will return all dependencies where there are hashes of answer hashes
  # end
  #
  # test 'check that all dependencies have a Hash of Hash answers' do
  #   @practical_flowchart.questions.each do |q|
  #     assert_true q[:answers].present?, "all answers hashes are populated except #{q[:id]}"
  #   end
  # end
  #
  # test "that the deps array count = sum of answers[:dependencies].present in @questions and @dependencies" do
  #
  # end

  # test 'better check for quanitiy of answers with a value of nil' do
  #   q_and_a =  @legal_flowchart.questions.collect {|q| q[:answers].present?}

  # @questions.find_all {|q| q[:answers].present? } = doesn't collect nil values - but raises question of in what case a nil can be assigned
  # @questions.find_all {|q| q[:answers].present? }.collect {|q| q[:answers] }.each {|e| puts e.values }.count
  # ^~> answer to above = "[{:id=>\"copyrightURL\", :label=>\"Where have you published the rights statement for this dataset?\", :type=>\"input\", :level=>\"pilot\", :answers=>nil, :prerequisites=>nil}]"

  # end


# * for the legal survey these are the labels that have no dependencies with no answer hashes
# * - they trigger the first if in _dependency.txt.erb
# Where do you detail the risks people might encounter if they use this data?
# Where is the Contributor Licence Agreement (CLA)?
# Where do you describe sources of this data?
# Where is the waiver for the rights in the data?
# What is the name of the licence?
# Where is the licence?
# Where is the waiver for the copyright?
# What's the name of the licence?
# Where is the licence?
# Where are the rights and licensing of the content explained?
# Where do you document your right to publish data about individuals?
# Where is your Privacy Impact Assessment published?
# Where is the privacy notice for individuals affected by your data?
#
# **The below dependencies do have answer hashes **
#
# Was the data originally created or generated by you?
# Was some of this data extracted or calculated from other data?
# Are all sources of this data already published as open data?
# Was some of this data crowdsourced?
# Did contributors to this data use their judgement?
# Have all contributors agreed to the Contributor Licence Agreement (CLA)?
# Is documentation about the sources of this data also in machine-readable format?
# Why doesn't a licence apply to this data?
# Which waiver do you use to waive rights in the data?
# Is the licence an open licence?
# Is the content of the data marked as public domain?
# Under which licence can others reuse content?
# Why doesn't a licence apply to the content of the data?
# Which waiver do you use to waive copyright?
# Is the licence an open licence?
# Does your rights statement include machine-readable versions of
# Has your anonymisation process been independently audited?
# Have you attempted to reduce or remove the possibility of individuals being identified?
# Are you required or permitted by law to publish this data about individuals?
# Have you carried out a Privacy Impact Assessment?
# Has your Privacy Impact Assessment been independently audited?
# Is there someone in your organisation who is responsible for data protection?
# Have you involved them in the Privacy Impact Assessment process?
# Has your anonymisation approach been independently audited?
#
#
# for the legal survey the below questions have no answer hashes
#
# Where have you published the rights statement for this dataset?
#
# ** for the legal survey  The Below Questions have answers and will trigger the recursive partial triggering
# ``@questions.find_all {|q| q[:answers].present? }.each do |q| puts q[:label] end;``
# Do you have the right to make this data open?
# Under which licence can people reuse this data?
# Is there any copyright in the content of this data?
# Can individuals be identified from this data?
#
# Where have you published the rights statement for this dataset?


# retrieving the occurrences of nil values for answer dependences
# @questions.find_all {|q| q[:answers].present? }.collect {|q| q[:answers] }.each {|e| puts e.values }
#     {:dependency=>"publisherOrigin"}
#     {:dependency=>nil}
#     {:dependency=>"publisherOrigin"}
#     {:dependency=>"rightsRiskAssessment"}
#     {:dependency=>nil}
#     {:dependency=>nil}
#     {:dependency=>nil}
#     {:dependency=>nil}
#     {:dependency=>nil}
#     {:dependency=>nil}
#     {:dependency=>nil}
#     {:dependency=>"dataNotApplicable"}
#     {:dependency=>"otherDataLicenceName"}
#     {:dependency=>"explicitWaiver"}
#     {:dependency=>"contentLicence"}
#     {:dependency=>"contentRightsURL"}
#     {:dependency=>nil}
#     {:dependency=>"statisticalAnonAudited"}
#     {:dependency=>"appliedAnon"}
# same as for dependencies :: @dependencies.find_all {|q| q[:answers].present? }.collect {|q| q[:answers] }.each {|e| puts e.values }

# @questions.find_all {|q| q[:answers].present? }.collect {|q| q[:answers] }.each {|e| puts e.values.count }
#       4
#       9
#       3
#       3

# @questions.find_all {|q| q[:answers].present? }.collect {|q| q[:answers] }.each {|e| puts e.values.class }
#     Array
#     Array
#     Array
#     Array
#^~> this is the correct version of above @questions.find_all {|q| q[:answers].present? }.collect {|q| q[:answers] }.each {|e| puts e.class }.count

# ..
