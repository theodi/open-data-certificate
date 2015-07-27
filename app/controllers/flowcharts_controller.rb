require 'flow'
require 'pry'

class FlowchartsController < ApplicationController

  def show

    # :@jurisdiction, String
    # :@type, String
    # :@questions, Array
    # :@dependencies, Array
    # :@deps, Array
    # :@levels, Hash

    # this all runs before the view renders? check
    @jurisdiction = params[:jurisdiction] || "gb"
    @type = params[:type] || "Practical"
    flow = Flow.new(@jurisdiction, @type)
    @questions = flow.questions # returns an array of hashes
    @dependencies = flow.dependencies
    @deps = []
    @levels = {}
    (@questions + @dependencies).each do |q| #what operation is this '+'
      @levels[q[:level]] ||= []
      @levels[q[:level]] << q[:id]
    end

  end

end
