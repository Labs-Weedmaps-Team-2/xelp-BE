class ApplicationController < ActionController::Base
  private
  
  def current_user
    @current_user ||= User.find(session[:session_id]) if session[:session_id]
  end
end
