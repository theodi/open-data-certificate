require 'flow'

class FlowchartsController < ApplicationController

  def show
    @jurisdiction = params[:jurisdiction] || "gb"
    @type = params[:type] || "Practical"
    flow = Flow.new(@jurisdiction, @type)
    @questions = flow.questions
    @dependencies = flow.dependencies
    @deps = []
    @levels = {}
    (@questions + @dependencies).each do |q|
      @levels[q[:level]] ||= []
      @levels[q[:level]] << q[:id]
    end
  end

end
