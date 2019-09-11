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
      end

      def create
        @business = Business.find_by(yelp_id: params[:id]) || self.create_bus(params[:id])
        # @review = Review.new(review: "tessttttting")
        # Review.create_from_review(@review)
        # render json: @review

        # current 
        @review = Review.new(text: params[:value], business_id: @business.id, user_id: session[:user_id])
        if @review.save
          render json: format_review_json(@review), status: :created
        @business = Business.find_by(yelp_id: params[:id]) || Business.create!(yelp_id: params[:id])
        if Review.reviewable(@business.id, session[:user_id])
          @review = Review.new(text: params[:review][:text], rating: params[:review][:rating], user_id: session[:user_id], business_id: @business.id)
          if @review.save
            render json: format_review_json(@review), status: :created
          else
            render json: @review.errors, status: :unprocessable_entity 
          end
        else
          @review = Review.find_by(user_id: session[:user_id], business_id: @business.id)
          render json: format_review_json(@review)
        end
      end

      def update 
        if session[:user_id]
          @business = Business.find_by(yelp_id: params[:id])
          @review = Review.update(review_params)

          render json: format_review_json(@review), status: :updated
        # else
        #   render json: {status: 'must sign in'}
        end
      end

      # this needs to be refactored out of controller and into review model
      def create_bus(yelp_id)
        #  @business= Review.create_business!(name: 'BUSINESS NAME 3', yelp_id: yelp_id)
        @review = Review.new(text: "this review will never post", user_id: 1)
        @business = Review.create_from_review(@review, yelp_id)
        @business
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
            rating: review.rating,
            business: review.business,
          }
        end
      end

      def review_params
        params.require(:review).permit(:text, :rating)
      end

      def set_review
        @review = Review.find(params[:id])
      end

    end # end of class
  end
end
