module Api
  module V1
    class BusinessController < ApplicationController
      before_action :set_business, only: [:show, :destroy]

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
        @business["status"] = "pending"
        if @business.save!
          render json: formatted_businesses(@business), status: :created
        else
          render json: @user.errors, status: :unprocessable_entity 
        end
      end

      def show
          @business = Business.find(params[:id])

          render json: @business
      end

      def update
        @business = Business.find_by(yelp_id: params[:id]) || Business.new(yelp_id: params[:id])
        if @business.update(business_params)
          render json: format_business(@business), status: :ok
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
          params.require(:business).permit(:id, :name, :address, :city, :state, :zipcode, :photo, :phone, :hours, :category, photos: [])
      end

      def format_business(business)
        if business.photos.attached?
          {
          id: business.id,
          name: business.name,
          address: business.address,
          city: business.city,
          state: business.state,
          zipcode: business.zipcode,
          latitude: business.latitude,
          longitude: business.longitude,
          photo: business.photo,
          phone: business.phone,
          yelp_id: business.yelp_id,
          rating: business.rating,
          price: business.price,
          category: business.category,
          photos: business.photos
          } 
        else 
          {
          id: business.id,
          name: business.name,
          address: business.address,
          city: business.city,
          state: business.state,
          zipcode: business.zipcode,
          latitude: business.latitude,
          longitude: business.longitude,
          photo: business.photo,
          phone: business.phone,
          yelp_id: business.yelp_id,
          rating: business.rating,
          price: business.price,
          category: business.category
          }
        end
      end
    end
  end
end
