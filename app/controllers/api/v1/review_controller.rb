require "net/http"

module Api
  module V1
    class ReviewController < ApplicationController
      def index
        puts params[:id], 'HAHAH'
        uri = URI("https://api.yelp.com/v3/businesses/#{params[:id]}/reviews")

        @business = Business.find_by(yelp_id: params[:id]) || nil
        if (@business)
          @reviews = Review.where(:business_id => @business.id).includes(:user)
        else
          @reviews = []
        end
        puts @reviews
        # lose user.username scope here
        @reviews.each do |review|
          puts review.user.username, "username here"
        end

        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          headers = {"Authorization" => "Bearer #{ENV["YELP_APP_SECRET"]}"}
          yelp_reviews = JSON.parse http.get(uri, headers).body
          results = yelp_reviews          
          render json: results['reviews'] + @reviews
        end
      end

      def create
        @business = Business.find_by(yelp_id: params[:id]) || self.create_bus(params[:id])
        
        # @review = Review.new(review: "tessttttting")
        # Review.create_from_review(@review)
        # render json: @review

        # current 
        @review = Review.new(text: "WE GENERATED THIS", business_id: @business.id, user_id: 3)
        if @review.save
          render json: @review, status: :created
        else
          render json: @review.errors, status: :unprocessable_entity 
        end
      end

      def create_bus(yelp_id)
      #  @business= Review.create_business!(name: 'BUSINESS NAME 3', yelp_id: yelp_id)
      @review = Review.new(text: "this review will never post", user_id: 1)
      @business = Review.create_from_review(@review, yelp_id)
        @business
      end


    end # end of class
  end
end
