require 'flow'
require 'pry'

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

    (@questions + @dependencies).each do |q|
      # **this method is getting nil when it should be getting raw**
      #This puts both @questions and @dependencies in one array
      @levels[q[:level]] ||= []
      @levels[q[:level]] << q[:id]

    end
  end

end
