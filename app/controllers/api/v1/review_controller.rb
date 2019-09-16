require "net/http"
require "image_processing/vips"

module Api
  module V1
    class ReviewController < ApplicationController
      before_action :set_review, only: [:update, :destroy]

      def index
        uri = URI("https://api.yelp.com/v3/businesses/#{params[:id]}/reviews")
        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          headers = {"Authorization" => "Bearer #{ENV["YELP_APP_SECRET"]}"}
          yelp_reviews = JSON.parse http.get(uri, headers).body
          if yelp_reviews["error"]
            # FETCH FOR LOCAL REVIEWS
            @business = Business.find_by(yelp_id: params[:id]) || nil
            if (@business)
              @reviews = Review.where(:business_id => @business.id).includes(:user)
            else
              @reviews = []
            end
            @reviews = @reviews.map {|review| format_review_json(review)}
            return render json: @reviews.reverse
          end
          @business = Business.find_by(yelp_id: params[:id]) || nil
          if (@business)
            @reviews = Review.where(:business_id => @business.id).includes(:user)
          else
            @reviews = []
          end
          @reviews = @reviews.map {|review| format_review_json(review)}
          results = yelp_reviews       
          render json:  @reviews.reverse! + results['reviews']
        end
      end

      def create
        @business = Business.find_by(yelp_id: params[:id])

        @review = Review.new(review_params)
        @review['business_id'] = @business.id
        @review['user_id'] = session[:user_id]
        if @review.save
          
          render json: format_review_json(@review), status: :created
        else
          render json: @review.errors, status: :unprocessable_entity 
        end
      end

      def update 
        if session[:user_id]
          @business = Business.find_by(yelp_id: params[:id])
          @review = Review.update(review_params)

          render json: format_review_json(@review), status: :updated
        end
      end

      def destroy
        temp = @review
        if session[:user_id] == @review.user_id
            @review.destroy
            render json: temp
        else
          render json: {msg: "not allowed", status: 404}
        end
      end

      private

      def format_review_json(review)
        if review.photos.attached?
        photos_arr = review.photos.map {|photo| url_for(photo.variant(resize: "200x200"))} 
        end
        if review.user.avatar.attached?
          {
          id: review.id,
          text: review.text,
          rating: review.rating,
          user: review.user,
          avatar: url_for(review.user.avatar.variant(resize: "200x200")),
          business: review.business,
          photos: photos_arr || []
          }
        else
          {
            id: review.id,
            text: review.text,
            user: review.user,
            rating: review.rating,
            business: review.business,
            photos: photos_arr || []
          }
        end
      end

      def review_params
        params.require(:review).permit(:text, :rating, :user_id, :business_id,  photos: [])
      end

      def set_review
        @review = Review.find(params[:id])
      end
    
    end # end of class
  end
end
