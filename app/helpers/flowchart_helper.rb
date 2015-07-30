require 'pry'

module FlowchartHelper

  def populate_deps_array(dependency, index, k, v) # key - answer text ("No, the API isn't..."), value - dependency (dependency => "dependency")  


    if v[:dependency].nil? && @questions[index + 1] != nil
      puts "we have access to questions and `` #{dependency[:label]} `` won't invoke @deps population"

    elsif !v[:dependency].nil?
      puts "``#{v}`` has a :dependency attribute present and `` #{dependency[:label]} `` will be passed to @deps"
      @deps << render(partial: "answer.txt", locals: { question: dependency, index: index, key: k, answer: v })
      # binding.pry
      puts "*************************"
      puts @deps.length

    else
      "this would usually print The End"

    end


  end

end
