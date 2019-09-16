require "net/http"

module Api
  module V1
    class SearchController < ApplicationController
      def index
        
        uri = URI("https://api.yelp.com/v3/businesses/search?location=#{params[:location]}&term=#{params[:term]}&categories=#{params[:categories]}&open_now=#{params[:open_now]}&price=#{params[:price]}&offset=#{params[:offset]}") 

        res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          headers = {"Authorization" => "Bearer #{ENV["YELP_APP_SECRET"]}"}
          render json:  http.get(uri, headers).body
        end
      end

      def show
        @business = Business.find_by(yelp_id: params[:id]) || Business.create!(yelp_id: params[:id])
        uri = URI("https://api.yelp.com/v3/businesses/#{params[:id]}")

        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          headers = {"Authorization" => "Bearer #{ENV["YELP_APP_SECRET"]}"}
          business_details = JSON.parse http.get(uri, headers).body
          if business_details["error"] 
            photo_count = 0
            business_photos = []
            @reviews = Review.where(business_id: @business.id)
            sum_of_rating = 0
            rating = 0
            if @reviews.length
              sum_of_max_rating_of_user_count = @reviews.length * 5
              @reviews.each { |review|
              if review.photos.attached?
                review.photos.each {|photo| photo_count += 1}
                review.photos.each {|photo| business_photos.push(url_for(photo))}
              end
              sum_of_rating += review.rating.to_i
            }
            rating = (sum_of_rating * 5) / sum_of_max_rating_of_user_count.to_f
          end
          if @business.photos.attached?
            @business.photos.each {|photo| 
            business_photos.push(url_for(photo))
            photo_count += 1
          }
          end
            business_obj = {
              name: @business.name,
              categories: [{title: "#{@business.category}"}],
              coordinates: {
                'latitude': @business.latitude,
                'longitude': @business.longitude
              },
              display_phone: @business.phone,
              location: {
                address1: @business.address,
                city: @business.city,
                country: 'US',
                state: @business.state,
                zip_code: @business.zipcode,
                display_address: ["#{@business.address}", "#{@business.city}, #{@business.state} #{@business.zipcode}"]
              },
              price: '$',
              photos: business_photos, 
              reviews: [],
              photo_count: photo_count,
              rating: rating
            }
            if session[:user_id]
              is_reviewd = Review.reviewable(@business.id, session[:user_id])
              business_obj[:is_reviewed] = !is_reviewd
            end
            return render json: business_obj
          end
          if @business.photos.attached?
            @business.photos.map {|photo| business_details['photos'] << url_for(photo)}
          end
          @reviews = Review.where(business_id: @business.id)
          business_details['photo_count'] = 3
          if @reviews.length
            @reviews.each { |review|
            if review.photos.attached?
              review.photos.each {|photo| business_details['photo_count'] += 1}
            end
          }
          end
          if session[:user_id]
            is_reviewd = Review.reviewable(@business.id, session[:user_id])
            business_details[:is_reviewed] = !is_reviewd
            render json:  business_details
          else
           render json:  business_details
          end
        end      
      end
      
      def biz_gallery
        @business = Business.find_by(yelp_id: params[:id]) || Business.create!(yelp_id: params[:id])
        @reviews = Review.where(business_id: @business.id)

        uri = URI("https://api.yelp.com/v3/businesses/#{params[:id]}")
        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          headers = {"Authorization" => "Bearer #{ENV["YELP_APP_SECRET"]}"}
          business_details = JSON.parse http.get(uri, headers).body
          if business_details["error"]
            business_photos = []
            if @business.photos.attached?
              @business.photos.each {|photo| business_photos.push url_for(photo)}
            end
            if @reviews.length
              @reviews.each { |review| 
              if review.photos.attached?
                review.photos.each {|photo| business_photos << url_for(photo)}
              end
            }
            end
            return render json: business_photos
          end
          if @business.photos.attached?
            @business.photos.map {|photo| business_details['photos'] << url_for(photo)}
          end
          if @reviews.length
            @reviews.each { |review| 
            if review.photos.attached?
              review.photos.each {|photo| business_details['photos'] << url_for(photo)}
            end
          }
          end
          
          render json: business_details['photos']
        end 
      end

      def autocomplete
        uri = URI("https://api.yelp.com/v3/autocomplete?text=#{params[:text]}&latitude=#{params[:latitude]}&longitude=#{params[:longitude]}") 

        res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          headers = {"Authorization" => "Bearer #{ENV["YELP_APP_SECRET"]}"}
          render json:  http.get(uri, headers).body
        end
      end
    end   # end of class
  end
end
