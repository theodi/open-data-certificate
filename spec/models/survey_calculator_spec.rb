require_relative '../spec_helper'

describe SurveyCalculator do

  before(:all) do
    Surveyor::Parser.parse_file(File.join(Rails.root, 'fixtures/survey_calculator_survey.rb'))
  end

  let(:survey) { Survey.last }
  let(:response_set) { FactoryGirl.create(:response_set) }

  let(:calculator) { SurveyCalculator.new(survey, response_set) }

  describe '#requirement_level_for_question' do
    let(:level) { calculator.requirement_level_for_question(question.id) }

    context 'where question is a requirement' do
      let(:question) { Question.find_by_reference_identifier('pilot_1') }

      it "returns it's own level" do
        expect(level).to eql('pilot')
      end
    end

    context 'where question has dependent requirements' do
      let(:question) { Question.find_by_reference_identifier('documentationUrl') }

      it "returns the lowest requirement level" do
        expect(level).to eql('basic')
      end
    end

    context "where question is set as 'required'" do
      let(:question) { Question.find_by_reference_identifier('dataTitle') }

      it "returns 'basic'" do
        expect(level).to eql('basic')
      end
    end

    context "where question has no requirement" do
      let(:question) { Question.find_by_reference_identifier('optionalQuestion') }

      it "returns 'none'" do
        expect(level).to eql('none')
      end
    end
  end

end
