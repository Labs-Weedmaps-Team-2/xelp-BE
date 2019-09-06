module Api
  module V1
    class BusinessesController < ApplicationController
      skip_before_action :verify_authenticity_token

      before_action :set_business, only: [:show, :update, :destroy]

      def index
        @businesses = Business.all 
        @formatted_businesses = @businesses.map { |business| format_business(business) }

        render json: @formatted_businesses
      end

      def show
        render json: @business
      end
      
      def create
        @business = Business.new(business_params)
        if @business.save!
          render json: @business
        else
          render json: @user.errors, status: :unprocessable_entity 
        end
      end


      def update
        if @business.update(business_params)
          render json: format_business(@business), status: :created
        else
          render json: @business.errors, status: :unprocessable_entity
        end
      end

      def destroy
          @business.destroy
          head :no_content
      end

      private 
      # Use callbacks to share common setup or constraints between actions.
      def set_business
          @business = Business.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def business_params
          params.require(:business).permit(:id, :name, :address, :yelp_id, photos: [])
      end

      def format_business(business)
        if business.photos.attached?
          {
          id: business.id,
          name: business.name,
          address: business.address,
          photo: business.photo,
          yelp_id: business.yelp_id,
          photos: []
        } 
        else 
        {
          id: business.id,
          name: business.name,
          address: business.address,
          photo: business.photo,
          yelp_id: business.yelp_id,
        }
        end
      end

    end
  end
end
