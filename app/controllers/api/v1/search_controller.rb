require "net/http"

# module Net
#   class HTTP
#     def HTTP.get_with_headers(uri, headers=nil)
#       uri = URI.parse(uri) if uri.respond_to? :to_str
#       start(uri.host, uri.port) do |http|
#         return http.get(uri.path, headers)
#       end
#     end
#   end
# end

module Api
  module V1
    class SearchController < ApplicationController
      def index
        
        uri = URI("https://api.yelp.com/v3/businesses/search?location=#{params[:location]}&term=#{params[:term]}&offset=#{params[:offset]}") 

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
          if session[:user_id]
            business_details = JSON.parse http.get(uri, headers).body
            is_reviewd = Review.reviewable(@business.id, session[:user_id])
            business_details[:is_reviewed] = !is_reviewd
            render json:  business_details 
          else
           render json:  http.get(uri, headers).body
          end
        end
        
      end
    end   # end of class

  end

end
