require 'httparty'

class Neighborhood
  
  attr_accessor :location, :venues, :correct_venues, :client_id, :client_secret, :group
  #maybe rewrite so id and secret not in initialize?
  def initialize(location, secret, id, group)
    @client_secret = secret
    @client_id = id
    @location = location
    @correct_venues = []
    @group = group
  end

  # returns an array (@venues) of all restaurants in a given neighborhood
  def search
    uri = "https://api.foursquare.com/v2/venues/explore?near=#{@location}&client_id=#{@client_id}&client_secret=#{@client_secret}&v=#{Time.now.strftime("%Y%m%d")}&categoryId=4d4b7105d754a06374d81259"
    # binding.pry
    encoded = URI.parse(URI.encode(uri)) #to handle spaces in the location
    @venues = HTTParty.get(encoded)['response']['groups'][0]["items"]
  end

  #rewrites @values to contain an array of the restaurant IDs
  def venue_ids
    ids = []
    @venues.each do |venue|
      ids << venue["venue"]["id"]
    end
    @venues = []
    ids.each do |i|
      @venues << HTTParty.get("https://api.foursquare.com/v2/venues/#{i}?client_id=#{@client_id}&client_secret=#{@client_secret}&v=#{Time.now.strftime("%Y%m%d")}&m=foursquare")
    end
  end

  # Checks for any of the Foursquare groupings:
  #Reservations, Credit Card, Lunch, Dinner, Dessert, Breakfast, Outdoor Seating
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
          #handles things like dinner, lunch, dessert
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

c = Neighborhood.new("East Village, New York, NY", "VYJTGNTSNT1OHG0AURLNS0DVXPS5GKBMSW0QBKFFAFK3NMAU", "KXSEM1VPP4MXSEWX1UZCLMHONDUF5CLAHH2G4CFZUOBL1NUD", "Dinner")
c.search
c.venue_ids
puts c.check_group