class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_current_user
  protected # prevents method from being invoked by a route
  def set_current_user
    @current_user ||= Moviegoer.find_by_id(session[:user_id])
  end
end