class PropertiesController < ApplicationController
  API_KEY = "a4nrkypa2nu9pynvucpn9eq4"
  respond_to :json

  def index
    @response = property_list()
    respond_with(@response)
  end

  def show
    @response = property()
    respond_with(@response)
  end
  
  private
  def property
    property_id = params[:id]
    response = HTTParty.get("http://services.homefinder.com/listingServices/details?id=#{property_id}&apikey=#{API_KEY}")
    response.body
  end
  
  def property_list
    zip  = params[:zip]
    min  = params[:min]
    max  = params[:max]
    page = params[:page]
    response = HTTParty.get("http://services.homefinder.com/listingServices/search?area=#{zip}&price=#{min}%20TO%20#{max}&page=#{page}&apikey=#{API_KEY}")
    response.body
  end
end