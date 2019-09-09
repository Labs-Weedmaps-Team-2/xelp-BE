module Api
  module V1
    class BusinessController < ApplicationController
      def index
          @businesses = Business.all 
          @formatted_businesses = @businesses.map { |business| format_business(business) }

          render json: @formatted_businesses
      end

      def show
          @business = Business.find(params[:id])

          render json: @business
      end
      
      def create
          @business = Business.new(business_params)
          @business.save!

          render json: @business, status: :created
      end

      def update
          @business = Business.update(business_params)

          render json @business
      end

      def destroy
          @business.destroy
      end

      private 
      # Use callbacks to share common setup or constraints between actions.
      def set_business
          @business = Business.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def business_params
          params.permit(:id, :name, :address, :photo, :phone, :coords)
      end

      def format_business(business) {
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
          coords: business.coords
      }
      end
    end
  end
end
