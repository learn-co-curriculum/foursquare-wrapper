require 'httparty'

class Neighborhood
  
  attr_accessor :location, :venues, :correct_venues, :group
  
  ##!!!NEEDS TO BE FILLED OUT WITH CLIENT ID AND SECRET PROVIDED BY FOURSQUARE
  # CLIENT_SECRET = 
  # CLIENT_ID = 
  def initialize(location, group)
    @location = location
    @correct_venues = []
    @venues = []
    @group = group
  end

  def search
    uri = "https://api.foursquare.com/v2/venues/explore?near=#{@location}&client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&v=#{Time.now.strftime("%Y%m%d")}&categoryId=4d4b7105d754a06374d81259"
    encoded = URI.parse(URI.encode(uri)) #to handle spaces in the location
    @venues = HTTParty.get(encoded)['response']['groups'][0]["items"]
  end

  def get_venue_ids
    ids = []
    @venues.each do |venue|
      ids << venue["venue"]["id"]
    end
    @venues = []
    ids.each do |i|
      @venues << HTTParty.get("https://api.foursquare.com/v2/venues/#{i}?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&v=#{Time.now.strftime("%Y%m%d")}&m=foursquare")
    end
  end

  def check_group
    @correct_venues = []
    @venues.each do |venue|
      venue['response']['venue']['attributes']['groups'].each do |v|
        v.each do |info, value|
          if info == "items" && value.first["displayName"] == @group
            if info == "items" && value.first["displayValue"].split(" ").first == "Yes" 
              @correct_venues << venue['response']['venue']['name']
            elsif value.first["displayName"] == value.first["displayValue"]
              @correct_venues << venue['response']['venue']['name']
            end
           elsif info == "items" && value.length > 1
              value.each do |v|
                if v["displayName"] == v["displayValue"] && v["displayValue"] == @group
                  @correct_venues << venue['response']['venue']['name']
                end
              end
          end
        end
      end
    end
    @correct_venues.uniq!
    @correct_venues
  end

end
