require 'pry'

module FlowchartHelper

  def dependency(question, answer, key, index, dependencies, questions)
    output = "#{question[:id]} \{\"#{question[:label]}\"\}"
    dependency = dependencies.find { |d| d[:id] == answer[:dependency] }
    # returns the first entire hash where any element in entire dependencies array matches the String extracted from answer key val hash passed to this function
    # @dependencies is an array of strings with no repetitions
    if dependency[:answers].nil?
      output += end_of_dependencies(question, answer, dependency, key, index, questions)
    else
      output += "#{question[:id]}  --> | \"#{key}\" | #{answer[:dependency]} { \"#{dependency[:label]}\" } \n"
      populate_dependencies(dependency, index)
    end
    output
  end

  def populate_dependencies(dependency, index)
     if dependency[:prerequisites].count <= 1 || (["timeSensitive","privacyImpactAssessmentExists"].include?(dependency[:id]) && dependency[:prerequisites].count == 2)
         populate_deps_array(dependency, index)
     else
       dependency[:prerequisites].shift
     end
  end

  def populate_deps_array(dependency, index) # key - answer text ("No, the API isn't..."), value - dependency (dependency => "dependency")ß
    dependency[:answers].each do |k,v|
        @deps << render(partial: "answer.txt", locals: { question: dependency, index: index, key: k, answer: v })
    end
  end

  def end_of_dependencies(question, answer, dependency, key, index, questions)
    output = "#{question[:id]}  --> | \"#{key}\" | #{answer[:dependency]} [ \"#{dependency[:label]}\" ] \n"
    if !questions[index + 1].nil?
      output += "#{answer[:dependency]} [ \"#{dependency[:label]}\" ] --> #{questions[index + 1][:id]} [ \"#{questions[index + 1][:label]}\" ] \n"
    else
      output += "#{answer[:dependency]} [ \"#{dependency[:label]}\" ] --> finalSection[\"End\"] \n"
     #  if this is removed the legal pathway is distorted but the paths that do not render normally still do not render
    end
    output
  end

end
