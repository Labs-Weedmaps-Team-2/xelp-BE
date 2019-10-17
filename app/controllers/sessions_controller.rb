class SessionsController < ApplicationController
  def create
    # raise request.env["omniauth.auth"].to_yaml
    auth = request.env["omniauth.auth"]

    user = User.find_by_provider_and_uid(auth["provider"], 
    auth["uid"]) || User.create_with_omniauth(auth)

    session[:user_id] = user.id
    if ENV['RAILS_ENV'] == "development"
      redirect_to "http://localhost:4000"
    else
      redirect_to "https://night-lyfe.netlify.com"
    end
  end

  def destroy
    session[:user_id] = nil
    if ENV['RAILS_ENV'] == "development"
      redirect_to "http://localhost:4000"
    else
      redirect_to "https://night-lyfe.netlify.com"
    end
  end

end
