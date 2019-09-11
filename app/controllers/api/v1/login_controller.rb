module API
  module V1
    class LoginController < ApplicationController
      def show
        if @login = Login.find_by(session[:user_id])
          render json @login
        else
          render json @login.error("need to login")
      end
    end
  end
end