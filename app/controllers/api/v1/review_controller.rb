require "net/http"

module Api
  module V1
    class ReviewController < ApplicationController
      before_action :set_review, only: [:update, :destroy]

      def index
        uri = URI("https://api.yelp.com/v3/businesses/#{params[:id]}/reviews")

        @business = Business.find_by(yelp_id: params[:id]) || nil
        if (@business)
          @reviews = Review.where(:business_id => @business.id).includes(:user)
        else
          @reviews = []
        end
        puts @reviews
        @reviews = @reviews.map {|review| format_review_json(review)}

        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          headers = {"Authorization" => "Bearer #{ENV["YELP_APP_SECRET"]}"}
          yelp_reviews = JSON.parse http.get(uri, headers).body
          results = yelp_reviews       
          render json:  @reviews.reverse! + results['reviews']
      end

      def create
        @business = Business.find_by(yelp_id: params[:id]) || Business.create!(yelp_id: params[:id])

        @review = Review.new(text: params[:review][:text], rating: params[:review][:rating], user_id: session[:user_id], business_id: @business.id, photos: params[:review][:photos])
        if @review.save
          
          render json: format_review_json(@review), status: :created
        else
          render json: @review.errors, status: :unprocessable_entity 
        end
      end
    end

      def update 
        if session[:user_id]
          @business = Business.find_by(yelp_id: params[:id])
          @review = Review.update(review_params)

          render json: format_review_json(@review), status: :updated
        end
      end

      private

      def format_review_json(review)
        if review.photos.attached?
        photos_arr = review.photos.map {|photo| url_for(photo)} 
        end
        if review.user.avatar.attached?
          {
          id: review.id,
          text: review.text,
          rating: review.rating,
          user: review.user,
          avatar: url_for(review.user.avatar),
          business: review.business,
          photos: []
          }
        else
          {
            id: review.id,
            text: review.text,
            user: review.user,
            rating: review.rating,
            business: review.business,
            photos: review.photos.attached? ? photos_arr : []
          }
        end
      end

      def review_params
        params.require(:review).permit(:text, :rating, photos: [])
      end

      def set_review
        @review = Review.find(params[:id])
      end
    
    end # end of class
  end
end
