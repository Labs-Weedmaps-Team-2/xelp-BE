<<<<<<< HEAD
class ApplicationController < ActionController::Base
  private
  
  def current_user
    @current_user ||= User.find(session[:session_id]) if session[:session_id]
  end
=======
class ApplicationController < ActionController::API
>>>>>>> 8deb66e2ff635aef80b9996c2837544fb5510e18
end
