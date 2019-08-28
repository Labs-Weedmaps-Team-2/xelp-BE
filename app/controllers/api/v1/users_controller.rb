module Api
  module V1
    class UsersController < ApplicationController
     def index
        @users = User.all
        @formatted_users = @users.map { |user| format_user(user) }

        render json: @formatted_users
     end

     def show
      @user ||= User.find(session[:session_id] ||= params[:id])
      render json: @user
    end

     def create
     end
     
     def update
     end
     
     def destroy
     end

     private
     # Use callbacks to share common setup or constraints between actions.
     def set_user
       @user = User.find(params[:id])
     end
 
     # Never trust parameters from the scary internet, only allow the white list through.
     def user_params
       params.require(:user).permit(:id, :username, :email, :photo)
     end

     def format_user(user)
      {
        id: user.id,
        email: user.email,
        photo: user.photo,
        username: user.username
      }
    end
     
    end
  end
end
