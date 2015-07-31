require 'pry'

module FlowchartHelper

  def dependency(question, answer, key, index, dependencies, questions)
    # question, an Object/Hash, either from @dependencies or @questions
    # index: integer, used to link question with questions
    # answer: Hash, the value portion of any given answers hash element, in format {:dependency=>String}
    # key: String, the key of any given answers hash element, usualy the ???? tag from a given XML
    # dependencies, should equal instance variable @dependencies, a hash of XML parsed elements
    # questions, should equal instance variable @questions, a hash of XML parsed elements

    output = "#{question[:id]} {\"#{question[:label]}\"}"
    # binding.pry
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

    output = "#{question[:id]} --> |\"#{key}\"| #{answer[:dependency]}[\"#{dependency[:label]}\"] \n"
    # binding.pry
    if !questions[index + 1].nil?
      output += "#{answer[:dependency]}[\"#{dependency[:label]}\"] --> #{questions[index + 1][:id]}[\"#{questions[index + 1][:label]}\"] \n"
    else
      output += "#{answer[:dependency]}[\"#{dependency[:label]}\"] --> finalSection[\"End\"] \n"
     #  if this is removed the legal pathway is distorted but the paths that do not render normally still do not render
    end
    # binding.pry
    output
  end

# `
#   <%= end_of_dependencies(question, answer, dependency, key, index, @questions) %>

#       <%= question[:id] %> --> |"<%= key %>"| <%= answer[:dependency] %>["<%= dependency[:label] %>"]
#       <% if !@questions[index + 1].nil? %>
#             <%= answer[:dependency] %>["<%= dependency[:label] %>"] --> <%= @questions[index + 1][:id] %>["<%= @questions[index + 1][:label] %>"]
#       <% else %>
#             <%= answer[:dependency] %>["<%= dependency[:label] %>"] --> finalSection["End"]
#       <% end %>
# `

end
