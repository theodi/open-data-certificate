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
    questions.where(Question.arel_table[:reference_identifier].not_in %w(documentationUrl pilot_1 basic_1))
  end

  def heading(locale=I18n.locale)
    translation(locale)[:text] || title
  end

  def subheading(locale=I18n.locale)
    if t = translation(locale)
      t[:help_text] || t[:description] || description
    else
      description
    end
  end

  def questions_by_group
    initial = [nil, []]
    survey_questions.eager_load(:question_group).inject([initial]) do |groups, question|
      group, questions = groups.last
      if group == question.question_group
        questions << question
      else
        groups << [question.question_group, [question]]
      end
      groups
    end
  end
end
