class SurveySection < ActiveRecord::Base
  unloadable
  include Surveyor::Models::SurveySectionMethods

  attr_accessible :display_header

  #override to include :survey_section so that the relations aren't lost again
  scope :with_includes, { :include => {:questions => [:answers, :question_group, :survey_section, {:dependency => :dependency_conditions}]}}

  def questions_for_certificate(response_set)

    # preload if questions have been triggered
    dep_map = response_set.depends

    questions.includes(:dependency).where(:display_on_certificate => true).
             select {|q| q.dependency.nil? || dep_map[q.dependency.id] }
  end

  def survey_questions
    questions.select{|q| !['documentationUrl', 'pilot_1', 'basic_1'].include?(q.reference_identifier) }
  end

end
