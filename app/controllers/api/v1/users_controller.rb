require "image_processing/vips"

module Api
  module V1
    class UsersController < ApplicationController
      include ImageProcessing::Vips

      before_action :set_user, only: [:show, :update, :destroy]

      rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

      def handle_record_not_found
        render json: {status: "No current session"}
      end


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
        render json: format_user(@current_user)
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
          render json: format_user(@user), status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def destroy
        if session[:user_id] == @user.id
          @user.destroy
            return render json: {"status": "success"}
        else
          return render json: {"status": "forbidden"}
        end
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_user
          @user = User.find(params[:id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def user_params
          params.require(:user).permit(:username, :email, :photo, :avatar, :city, :state)
        end

        def format_user(user)
          if user.avatar.attached?
            {
              id: user.id,
              email: user.email,
              photo: user.photo,
              username: user.username,
              avatar: url_for(user.avatar.variant(resize: "200x200")),
              city: user.city,
              state: user.state
            }
          else
            {
              id: user.id,
              email: user.email,
              photo: user.photo,
              username: user.username,
              city: user.city,
              state: user.state
            }
          end
        end
    end
  end
end
