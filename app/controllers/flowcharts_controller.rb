require 'flow'

class FlowchartsController < ApplicationController

  def show
    @jurisdiction = params[:jurisdiction] || "gb"
    flow = Flow.new(@jurisdiction)
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
