# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Surveyor::Parser do
  let(:parser){ Surveyor::Parser.new }
  it "should translate shortcuts into full model names" do
    parser.send(:full, "section").should == "survey_section"
    parser.send(:full, "g").should == "question_group"
    parser.send(:full, "repeater").should == "question_group"
    parser.send(:full, "label").should == "question"
    parser.send(:full, "vc").should == "validation_condition"
    parser.send(:full, "vcondition").should == "validation_condition"
  end
  it "should translate 'condition' based on context" do
    parser.send(:full, "condition").should == "dependency_condition"
    parser.send(:full, "c").should == "dependency_condition"
    parser.context[:validation] = Validation.new
    parser.send(:full, "condition").should == "validation_condition"
    parser.send(:full, "c").should == "validation_condition"
    parser.context[:validation] = nil
    parser.send(:full, "condition").should == "dependency_condition"
    parser.send(:full, "c").should == "dependency_condition"
  end
  it "should not translate bad shortcuts" do
    parser.send(:full, "quack").should == "quack"
    parser.send(:full, "grizzly").should == "grizzly"
  end
  it "should identify models that take blocks" do
    parser.send(:block_models).should == %w(survey survey_section question_group)
  end
  it "should return a survey object" do
    Surveyor::Parser.new.parse("survey 'hi' do\n end").is_a?(Survey).should be_true
  end
  describe 'reference checking' do
    it 'accepts Answer#reference_identifier via underscore or hash syntax' do
      survey_text = <<END
  survey "Numbers" do
    section_one "One" do
      q_1 "Select a number", :pick => :one
      a "One", {:reference_identifier => "1"}
      a_2 "Two"
      a_3 "Three"

      label_2 "One is the loneliest number..."
      dependency :rule => "A"
      condition_A :q_1, "==", {:answer_reference => "1"}

      label_3 "Two can be as bad as one..."
      dependency :rule => "A"
      condition_A :q_1, "==", {:answer_reference => "2"}

      label_4 "that you'll ever do"
      dependency :rule => "A"
      condition_A :q_1, "==", :a_1

      label_5 "it's the loneliest number since the number one"
      dependency :rule => "A"
      condition_A :q_1, "==", :a_2
    end
  end
END
      survey = Surveyor::Parser.new.parse(survey_text)
      survey.is_a?(Survey).should == true
    end

  end
end
