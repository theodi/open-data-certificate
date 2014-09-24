class AdminController < ApplicationController

  def index
    authorize! :manage, :all
    @title = "Admin"

  end

end
