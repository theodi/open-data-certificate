class SurveySection < ActiveRecord::Base
  unloadable
  include Surveyor::Models::SurveySectionMethods

  attr_accessible :display_header

  def questions_for_certificate(response_set)

    # preload if questions have been triggered
    dep_map = response_set.depends

    questions.includes(:dependency).where(:display_on_certificate => true).
             select {|q| q.dependency.nil? || dep_map[q.dependency.id] }
  end

end