module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:show :update :destroy]

      def index
        @users = User.all
        @formatted_users = @users.map { |user| format_user(user) }

        render json: @formatted_users
      end


      def show
        render json: format_user(@user)
      end

      def current_user
        @current_user = User.find(session[:user_id])
        render json: @current_user
      end

      def create
        @user = User.new(user_params)

        if @user.save
          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity 
        end
      end

      def update
        if @user.update(user_params)
          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @user.destroy
        head :no_content
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_user
          @user = User.find(params[:id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def user_params
          params.require(:user).permit(:username, :email, :photo, :avatar)
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
