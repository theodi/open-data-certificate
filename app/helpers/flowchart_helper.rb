require 'pry'

module FlowchartHelper

  def populate_deps_array(dependency, index, k, v)
    @deps << render(partial: "answer.txt", locals: { question: dependency, index: index, key: k, answer: v })
    binding.pry
  end

end