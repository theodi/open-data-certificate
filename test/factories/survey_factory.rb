FactoryGirl.define do

  factory :survey do |s|
    meta_hash = {
        dataset_title: 'testDataTitle', 
        dataset_curator: 'testPublisher',
        dataset_documentation_url: 'testDocumentationUrl'
      }
    
    s.title "Simple survey"
    s.description "A simple survey for testing"
    s.access_code { FactoryGirl.generate :unique_survey_access_code }
    s.survey_version 0
    s.meta_map meta_hash
  
    after(:create) do |survey, evaluator|
      FactoryGirl.create_list(:survey_section, 3, survey: survey)
    end

    factory :survey_with_2_questions do |survey|
      survey.sections { [FactoryGirl.create(:survey_section_with_one_question_and_one_mandatory_question)] }
    end
  end

  sequence :unique_survey_access_code do |n|
    "simple_survey_#{UUIDTools::UUID.random_create.to_s}"
  end


  factory :survey_translation do |t|
    t.locale "es"
    t.translation %(title: "Un idioma nunca es suficiente"
      survey_sections:
        one:
          title: "Uno"
      questions:
        hello:)
  end


end