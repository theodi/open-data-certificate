class SurveyCalculator

  attr_reader :survey, :response_set

  def initialize(survey, response_set)
    @survey = survey
    @response_set = response_set
  end

  def requirement_level_for_question(question_id)
    @requirement_level_for_question ||= {}
    @requirement_level_for_question[question_id] ||= begin
      question = questions_by_id[question_id]

      if question.nil?
        Survey::REQUIREMENT_LEVELS[0]
      elsif question.required.present?
        Survey::REQUIREMENT_LEVELS[1]
      elsif question.is_requirement?
        question.requirement_level
      else
        levels = dependent_questions_of(question_id).map { |q| requirement_level_for_question(q.id) }
        levels = levels.map { |level| Survey::REQUIREMENT_LEVELS.index(level) }.compact
        Survey::REQUIREMENT_LEVELS[levels.min || 0]
      end
    end
  end


  private

  def questions
    @questions ||= survey.questions
  end

  def answers
    @answers ||= survey.answers
  end

  def dependencies
    @dependencies ||= questions.map(&:dependency).compact
  end

  def dependency_conditions
    @dependency_conditions ||= dependencies.flat_map(&:dependency_conditions)
  end

  def questions_by_id
    @questions_by_id ||= questions.index_by(&:id)
  end

  def dependencies_by_id
    @dependencies_by_id ||= dependencies.index_by(&:id)
  end

  def dependent_questions_of(question_id)
    dependency_ids = dependency_conditions.select { |dc| dc.question_id == question_id }.map(&:dependency_id).uniq
    dependencies = dependency_ids.map { |id| dependencies_by_id[id] }.compact
    dependencies.map { |d| questions_by_id[d.question_id] }
  end

end
