require "net/http"

module Api
  module V1
    class ReviewController < ApplicationController
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
          render json: results['reviews'] + @reviews
        end
      end

      def create
        # @review = Review.new(review: "tessttttting")
        # Review.create_from_review(@review)
        # render json: @review
        if session[:user_id]
          @business = Business.find_by(yelp_id: params[:id]) || self.create_bus(params[:id])
          @review = Review.new(text: params[:review][:text], business_id: @business.id, user_id: session[:user_id], rating: params[:review][:rating])
          if @review.save
            render json: format_review_json(@review), status: :created
          else
            render json: @review.errors, status: :unprocessable_entity 
        end
      else 
        render json: {status: "must signed in"}
      end
      end

      def create_bus(yelp_id)
      #  @business= Review.create_business!(name: 'BUSINESS NAME 3', yelp_id: yelp_id)
      @review = Review.new(text: "this review will never post", user_id: 1)
      @business = Review.create_from_review(@review, yelp_id)
        @business
      end
      private

      def format_review_json(review)
        if review.user.avatar.attached?
          {
          id: review.id,
          text: review.text,
          rating: review.rating,
          user: review.user,
          avatar: url_for(review.user.avatar),
          business: review.business,
          }
        else
          {
            id: review.id,
            text: review.text,
            user: review.user,
            business: review.business,
          }
        end
      end

    end # end of class
  end
end
