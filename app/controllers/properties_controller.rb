class PropertiesController < ApplicationController
  API_KEY = "a4nrkypa2nu9pynvucpn9eq4"
  respond_to :json

  def index
    respond_with(do_api_call)
  end

  def show
  end
  
  private
  def do_api_call
    zip = params[:zip]
    min = params[:min]
    max = params[:max]
    HTTParty.get("http://services.homefinder.com/listingServices/search?area=#{zip}&price=#{min}%20TO%20#{max}&apikey=#{API_KEY}")
    
  end
end
