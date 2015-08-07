class FlowchartsController < ApplicationController

  def show

    # :@jurisdiction, String
    # :@type, String
    # :@questions, Array
    # :@dependencies, Array
    # :@deps, Array
    # :@levels, Hash of Arrays, the arrays contain the XML descriptive

    # this all runs before the view renders? check
    @jurisdiction = params[:jurisdiction] || "gb"
    @type = params[:type] || "Practical"
    flow = Flow.new(@jurisdiction, @type)
    @questions = flow.questions # returns an array of hashes with dependency always nil
    @dependencies = flow.dependencies
    @deps = []
    # array of string containing a rendered partial
    @levels = {}

    (@questions + @dependencies).each do |q| #what operation is this '+'
      @levels[q[:level]] ||= []
      @levels[q[:level]] << q[:id]

    end
  end

end

# potential tests
# given a particular $?$.en.xml file there should be X no of questions and Y amount of dependencies
# given @type = caseInsensitiveParse("practical")
# @questions.count should eql? 28
# @dependencies.count should eql? 43
# (both above examples are the ideal case scenario, but then testing this is rendered will be total headfuck)

# is there any scenario where @questions[element][:prerequisites] is nil?

# catching malformed termination
# and page should contain `finalSection["End"]`
