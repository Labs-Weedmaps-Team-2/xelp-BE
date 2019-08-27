module Api
  module V1
    class UsersController < ApplicationController
     def index
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
       params.require(:user).permit(:email, :username, :email, :photo)
     end
     
    end
  end
end
