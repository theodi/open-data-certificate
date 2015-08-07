require 'pry'

module FlowchartHelper

  # def render_graph(dependencies, questions)
  #   output = ""
  #   questions.each_with_index do |q, index|
  #     output += question(q, index, dependencies, questions)
  #   end
  #
  #   @deps.reverse.join("\r\n").gsub("’", "'")
  #   @levels.each do |k, l|
  #     unless k.nil?
  #       class  l.join(",")
  #       k
  #     end
  #   end
  # end
  #
  # def all_questions(dependencies,questions)
  #   output = ""
  #   questions.each_with_index do |q, index|
  #     output += question(q, index, dependencies, questions)
  #   end
  #   output
  # end

  def question(question, index, dependencies, questions)
    output = ""
    if question[:answers].nil? && questions[index + 1] != nil
      #all : attributes in this partial are established in the flow class def question
      output = "#{question[:id]}[\"#{question[:label]}\"] --> #{questions[index + 1][:id]}[\"#{questions[index + 1][:label]}\"] \n"
    elsif !question[:answers].nil?
      question[:answers].each do |k,v|
        output += answer(question, v, k, index, dependencies, questions)
      end
    else
      output = "#{question[:id]}[\"#{question[:label]}\"] --> finalSection[\"End\"] \n"
    end
    output.to_s.html_safe
  end

  def answer(question, answer, key, index, dependencies, questions)
    # question, an Object/Hash, either from @dependencies or @questions
    # index: integer, used to link question with questions
    # answer: Hash, the value portion of any given answers hash element, in format {:dependency=>String}
    # key: String, the key of any given answers hash element, usualy the ???? tag from a given XML
    # dependencies, should equal instance variable @dependencies, a hash of XML parsed elements
    # questions, should equal instance variable @questions, a hash of XML parsed elements
    # binding.pry
    output = ""
    if answer[:dependency].nil? && questions[index + 1] != nil
     # the above will execute for any question hashes that have a nil value
     output = "#{question[:id]}{\"#{question[:label]}\"} --> |\"#{key}\"| #{questions[index + 1][:id]}[\"#{questions[index + 1][:label]}\"] \n"
    elsif !answer[:dependency].nil?
      output = dependency(question, answer, key, index, dependencies, questions)
    else
      output = "#{question[:id]}{\"#{question[:label]}\"} --> |\"#{key}\"| finalSection[\"End\"] \n"
    end
    output
  end

  def dependency(question, answer, key, index, dependencies, questions)
    # question, an Object/Hash, either from @dependencies or @questions
    # index: integer, used to link question with questions
    # answer: Hash, the value portion of any given answers hash element, in format {:dependency=>String}
    # key: String, the key of any given answers hash element, usualy the ???? tag from a given XML
    # dependencies, should equal instance variable @dependencies, a hash of XML parsed elements
    # questions, should equal instance variable @questions, a hash of XML parsed elements

    output = " #{question[:id]}{\"#{question[:label]}\"}\n"
    # binding.pry
    dependency = dependencies.find { |d| d[:id] == answer[:dependency] }
    # returns the first entire hash where any element in entire dependencies array matches the String extracted from answer key val hash passed to this function
    # @dependencies is an array of strings with no repetitions
    if dependency[:answers].nil?
      output += end_of_dependencies(question, answer, dependency, key, index, questions)
    else
      output += "#{question[:id]} --> |\"#{key}\"| #{answer[:dependency]}{\"#{dependency[:label]}\"} \n"
      populate_dependencies(dependency, index, dependencies, questions)
    end
    output
  end

  def populate_dependencies(dependency, index, dependencies, questions)
     if dependency[:prerequisites].count <= 1 || (["timeSensitive","privacyImpactAssessmentExists"].include?(dependency[:id]) && dependency[:prerequisites].count == 2)
         populate_deps_array(dependency, index, dependencies, questions)
     else
       dependency[:prerequisites].shift
     end
  end

  def populate_deps_array(dependency, index, dependencies, questions) # key - answer text ("No, the API isn't..."), value - dependency (dependency => "dependency")ß
    dependency[:answers].each do |k,v|
        @deps << answer(dependency, v, k, index, dependencies, questions)
        # @deps << render(partial: "answer.txt", locals: { question: dependency, index: index, key: k, answer: v })
    end
  end

  def end_of_dependencies(question, answer, dependency, key, index, questions)

    output = "#{question[:id]} --> |\"#{key}\"| #{answer[:dependency]}[\"#{dependency[:label]}\"] \n"
    # binding.pry
    if !questions[index + 1].nil?
      output += "#{answer[:dependency]}[\"#{dependency[:label]}\"] --> #{questions[index + 1][:id]}[\"#{questions[index + 1][:label]}\"] \n"
    else
      output += "#{answer[:dependency]}[\"#{dependency[:label]}\"] --> finalSection[\"End\"] \n"
     #  if this is removed the legal pathway is distorted but the paths that do not render normally still do not render
    end
    output
  end

  # wonky render
  # Rendered flowcharts/_answer.txt.erb (0.9ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.1ms)
  # Rendered flowcharts/_answer.txt.erb (1.1ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (2.1ms)
  # Rendered flowcharts/_answer.txt.erb (3.4ms)
  # Rendered flowcharts/_answer.txt.erb (0.1ms)
  # Rendered flowcharts/_question.txt.erb (8.4ms)
  # Rendered flowcharts/_question.txt.erb (0.1ms)
  # Rendered flowcharts/_answer.txt.erb (0.1ms)
  # Rendered flowcharts/_answer.txt.erb (0.1ms)
  # Rendered flowcharts/_answer.txt.erb (0.1ms)
  # Rendered flowcharts/_answer.txt.erb (0.1ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.1ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (1.3ms)
  # Rendered flowcharts/_answer.txt.erb (3.1ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_question.txt.erb (10.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.9ms)
  # Rendered flowcharts/_answer.txt.erb (0.1ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.1ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (1.1ms)
  # Rendered flowcharts/_answer.txt.erb (2.7ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (7.1ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_question.txt.erb (9.5ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.9ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.9ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.9ms)
  # Rendered flowcharts/_answer.txt.erb (2.6ms)
  # Rendered flowcharts/_question.txt.erb (4.9ms)

  # non wonky render
  # Rendered flowcharts/_dependency.txt.erb (0.1ms)
  # Rendered flowcharts/_answer.txt.erb (4.1ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_dependency.txt.erb (1.3ms)
  # Rendered flowcharts/_answer.txt.erb (1.9ms)
  # Rendered flowcharts/_answer.txt.erb (0.1ms)
  # Rendered flowcharts/_dependency.txt.erb (3.5ms)
  # Rendered flowcharts/_answer.txt.erb (4.1ms)
  # Rendered flowcharts/_dependency.txt.erb (5.3ms)
  # Rendered flowcharts/_answer.txt.erb (5.9ms)
  # Rendered flowcharts/_dependency.txt.erb (0.1ms)
  # Rendered flowcharts/_answer.txt.erb (1.3ms)
  # Rendered flowcharts/_question.txt.erb (14.9ms)
  # Rendered flowcharts/_question.txt.erb (0.1ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_dependency.txt.erb (0.1ms)
  # Rendered flowcharts/_answer.txt.erb (0.8ms)
  # Rendered flowcharts/_dependency.txt.erb (3.1ms)
  # Rendered flowcharts/_answer.txt.erb (3.9ms)
  # Rendered flowcharts/_dependency.txt.erb (6.1ms)
  # Rendered flowcharts/_answer.txt.erb (6.6ms)
  # Rendered flowcharts/_dependency.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.6ms)
  # Rendered flowcharts/_question.txt.erb (12.6ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_dependency.txt.erb (1.5ms)
  # Rendered flowcharts/_answer.txt.erb (2.1ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.1ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_dependency.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.6ms)
  # Rendered flowcharts/_dependency.txt.erb (1.5ms)
  # Rendered flowcharts/_answer.txt.erb (2.0ms)
  # Rendered flowcharts/_dependency.txt.erb (3.3ms)
  # Rendered flowcharts/_answer.txt.erb (3.8ms)
  # Rendered flowcharts/_dependency.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.6ms)
  # Rendered flowcharts/_dependency.txt.erb (8.1ms)
  # Rendered flowcharts/_answer.txt.erb (8.6ms)
  # Rendered flowcharts/_dependency.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.5ms)
  # Rendered flowcharts/_question.txt.erb (13.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_dependency.txt.erb (1.4ms)
  # Rendered flowcharts/_answer.txt.erb (2.8ms)
  # Rendered flowcharts/_dependency.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.6ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_dependency.txt.erb (1.6ms)
  # Rendered flowcharts/_answer.txt.erb (2.2ms)
  # Rendered flowcharts/_dependency.txt.erb (0.0ms)
  # Rendered flowcharts/_answer.txt.erb (0.6ms)
  # Rendered flowcharts/_answer.txt.erb (0.0ms)
  # Rendered flowcharts/_dependency.txt.erb (1.7ms)
  # Rendered flowcharts/_answer.txt.erb (2.2ms)
  # Rendered flowcharts/_dependency.txt.erb (5.9ms)
  # Rendered flowcharts/_answer.txt.erb (7.0ms)
  # Rendered flowcharts/_question.txt.erb (11.8ms)

# `
#    end_of_dependencies(question, answer, dependency, key, index, @questions)

#        question[:id]  --> |" key "|  answer[:dependency] [" dependency[:label] "]
#        if !@questions[index + 1].nil?
#              answer[:dependency] [" dependency[:label] "] -->  @questions[index + 1][:id] [" @questions[index + 1][:label] "]
#        else
#              answer[:dependency] [" dependency[:label] "] --> finalSection["End"]
#        end
# `

end
