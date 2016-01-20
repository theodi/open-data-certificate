class AdminController < ApplicationController

  before_filter :set_cache_buster

  def index
    authorize! :manage, :all
    @title = "Admin"
  end

  def users
    @user = User.find(params[:user_id])
    authorize! :manage, @user
    @datasets = @user.datasets.page(params[:page])
  end

  def typeahead
    authorize! :manage, :all
    users = User.search(
      m: 'or',
      email_cont: params[:q],
      name_cont: params[:q],
      short_name_cont: params[:q]
    )
    response = users.result.limit(5).map do |user|
      {
        user: user.to_s,
        value: user.email,
        path: admin_users_path(user)
      }
    end
    render json: response
  end

  private

    def set_cache_buster
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end

end
