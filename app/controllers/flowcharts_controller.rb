require 'flow'

class FlowchartsController < ActionController::Base
  def show
    @jurisdiction = params[:jurisdiction] || "gb"
    flow = Flow.new(@jurisdiction)
    @questions = flow.questions
    @dependencies = flow.dependencies
    @deps = []
  end

end
