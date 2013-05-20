class SurveySection < ActiveRecord::Base
  unloadable
  include Surveyor::Models::SurveySectionMethods

  # the reponses for this section that should be displayed in the certificate
  def responses_for_certificate response_set
    questions
      .map { |q|
        question_response_for_certificate q, response_set
      }
      .select {|x| x} # remove any nils
  end
  
  # the response for a question to be displayed on the certificate (or, nil if it shouldn't be displayed)
  def question_response_for_certificate question, response_set
    question.display_on_certificate && 
    question.triggered?(response_set) &&
    question.response(response_set)
  end

end
