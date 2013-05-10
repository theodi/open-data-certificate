class Survey < ActiveRecord::Base
  include Surveyor::Models::SurveyMethods

  REQUIREMENT_LEVELS = %w(basic pilot standard exemplar)

  def questions
    sections.map(&:questions).flatten
  end

  def requirements
    questions.select(&:is_a_requirement?)
  end

  def mandatory_questions
    sections.map{|s| s.questions.where(:is_mandatory => true)}.flatten
  end

  def valid?(context = nil)
    super(context)
    unless errors.empty?

      sections.each do |section|
        unless section.errors.empty?
          puts "section '#{section.title}' errors: #{section.errors.full_messages}"

          questions.each do |question|
            unless question.errors.empty?
              puts "question '#{question.text}' errors: #{question.errors.full_messages}"

              question.answers.each do |answer|
                puts "answer '#{answer.text}' errors: #{answer.errors.full_messages}" unless answer.errors.empty?
              end

            end
          end

        end
      end

    end

    return errors.empty?
  end


end
