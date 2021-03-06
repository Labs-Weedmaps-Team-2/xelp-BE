require "image_processing/vips"

module Api
  module V1
    class SearchController < ApplicationController
      def index
        ## create api url 
        ## defined uri
        uri = URI("https://api.yelp.com/v3/businesses/search?location=#{params[:location]}&term=#{params[:term]}&categories=#{params[:categories]}&open_now=#{params[:open_now]}&price=#{params[:price]}&offset=#{params[:offset]}&limit=10&radius=#{params[:radius]}") 
        ## begin API request on uri
        res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          headers = {"Authorization" => "Bearer #{ENV["YELP_APP_SECRET"]}"}
          ## parse api response into JSON
          business_list = JSON.parse http.get(uri, headers).body
          
          latitudes = {
              max: -Float::INFINITY,
              min:  Float::INFINITY
            }
          longitudes ={
            max: -Float::INFINITY,
            min:  Float::INFINITY
            }
          i = 0
          while i < business_list['businesses'].length
            if business_list['businesses'][i]['coordinates']['latitude'] > latitudes[:max]
              latitudes[:max] = business_list['businesses'][i]['coordinates']['latitude']
            end
            if business_list['businesses'][i]['coordinates']['latitude'] < latitudes[:min]
              latitudes[:min] = business_list['businesses'][i]['coordinates']['latitude']
            end
            
            if business_list['businesses'][i]['coordinates']['longitude'] > longitudes[:max]
              longitudes[:max] = business_list['businesses'][i]['coordinates']['longitude']
            end
            if business_list['businesses'][i]['coordinates']['longitude'] < latitudes[:min]
              longitudes[:min] = business_list['businesses'][i]['coordinates']['longitude']
            end
            i+= 1
          end

         ## assign obj vals to variables 
          maxLat = latitudes[:max]
          minLat = latitudes[:min]
          maxLng = longitudes[:max]
          minLng = longitudes[:min]
         ## geo = defined scope to find avarage coordinates 
         ## checking our db table for business location within coordinates
          @business = Business.geo(minLat,maxLat,minLng,maxLng, params[:term])
          ## if business list is not empty
          if @business
            ## -> shape business obj to match the shape of api response obj
            @business.each { |business| 
              buz_obj = {
               categories: [{title: "#{business.category}"}],
               name: business.name,
               rating: 4.5,
               location: {
                 address1: business.address,
                 city: business.city,
                 zip_code: business.zipcode,
                 country: 'US',
                 state: business.state,
                 display_address: ["#{business.address}", "#{business.city}, #{business.state} #{business.zipcode}"]
               },
               coordinates: {
                 'latitude': business.latitude,
                 'longitude': business.longitude
               },
               id: business.yelp_id,
               img_url: business.img_url.attached? ? url_for(business.img_url) : nil
             }
             ## place our business data first / ensuring our data is priority
             business_list['businesses'].unshift(buz_obj)
           }        
           end
            # api response with array of businesses nearby
           render json: business_list  
        end
      end
      # invoke show to get all data of a single 
      def show
        ## attempt to find the business in our table with the yelp_id 
        ## if not found else create it the business with yelps data & presist it to our db ! 
        @business = Business.find_by(yelp_id: params[:id]) || Business.create!(yelp_id: params[:id])
        uri = URI("https://api.yelp.com/v3/businesses/#{params[:id]}")

        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          headers = {"Authorization" => "Bearer #{ENV["YELP_APP_SECRET"]}"}
          business_details = JSON.parse http.get(uri, headers).body
          # if id given is an id generated by our db
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
                review.photos.each {|photo| business_photos.push(url_for(photo.variant(resize: "200x200")))}
              end
              sum_of_rating += review.rating.to_i
            }
            rating = (sum_of_rating * 5) / sum_of_max_rating_of_user_count.to_f
          end
          ## if busniess found, does it have own any photos from out db?
          if @business.photos.attached?
            #if so push photo into array
            @business.photos.each {|photo| 
            business_photos.push(url_for(photo.variant(resize: "500x500")))
            photo_count += 1
          }
          end
          ## creating business obj
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
              rating: rating,
              image_url: url_for(@business.img_url)
            }
            ## attaching is_reviewed bool to business_obj
            # if request has a session -> attach bool to the responese 
            if session[:user_id]
              is_reviewd = Review.reviewable(@business.id, session[:user_id])
              business_obj[:is_reviewed] = !is_reviewd
            end
            return render json: business_obj
          end
          # method to update entity
          @business.update(name: business_details['name'], photo: business_details['image_url'])
          ## if add entity has photos associitated -> push them to an array
          if @business.photos.attached?
            @business.photos.map {|photo| business_details['photos'] << url_for(photo.variant(resize: "200x200"))}
          end
          ## find the businesses reviews
          @reviews = Review.where(business_id: @business.id)
          ## count of photos that yelp returns
          business_details['photo_count'] = 3
          if @reviews.length
            @reviews.each { |review|
              ## increment the count for each photo that our db has stored.
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
      ## fiind all photos from a busniess
      def biz_gallery
        ## find or create business
        @business = Business.find_by(yelp_id: params[:id]) || Business.create!(yelp_id: params[:id])
        ## find all reviews
        @reviews = Review.where(business_id: @business.id)

        uri = URI("https://api.yelp.com/v3/businesses/#{params[:id]}")
        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          headers = {"Authorization" => "Bearer #{ENV["YELP_APP_SECRET"]}"}
          business_details = JSON.parse http.get(uri, headers).body
          ## an error will be present if the param id was generated from our db
          if business_details["error"]
            business_photos = []
            if @business.photos.attached?
              @business.photos.each {|photo| business_photos.push url_for(photo.variant(resize: "200x200"))}
            end
            ## check if reviews have photos
            if @reviews.length
              @reviews.each { |review| 
              if review.photos.attached?
                review.photos.each {|photo| business_photos << url_for(photo.variant(resize: "200x200"))}
              end
            }
            end
            return render json: business_photos
          end
          if @business.photos.attached?
            @business.photos.map {|photo| business_details['photos'] << url_for(photo.variant(resize: "200x200"))}
          end
          if @reviews.length
            @reviews.each { |review| 
            if review.photos.attached?
              review.photos.each {|photo| business_details['photos'] << url_for(photo.variant(resize: "200x200"))}
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
