require 'httparty'

class Neighborhood
  
  attr_accessor :location, :recommended_venues, :venue_ids, :venues_to_search, :venues_by_group, :venues_by_tag
  
  ##!!!NEEDS TO BE FILLED OUT WITH CLIENT ID AND SECRET PROVIDED BY FOURSQUARE
  # CLIENT_ID = ""
  # CLIENT_SECRET = ""

  def initialize(location)
    @location = location
    @recommended_venues = get_recommended_venues
    @venue_ids = []
    @venues_to_search = []
    @venues_by_group = []
    @venues_by_tag = []
  end

  # This user the Foursquare explore endpoint to pull recommended food venues for a location
  def get_recommended_venues
    uri = "https://api.foursquare.com/v2/venues/explore?near=#{@location}&client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&v=#{Time.now.strftime("%Y%m%d")}&categoryId=4d4b7105d754a06374d81259"
    encoded = URI.parse(URI.encode(uri)) # to handle spaces in the location
    api_response = HTTParty.get(encoded)
    @recommended_venues = api_response['response']['groups'][0]["items"]
  end
  # Example uri https://api.foursquare.com/v2/venues/explore?near=East%20Village,%20New%20York,%20NY&client_id=JUUFHYCI1ZWKTMHF5GEG1ZODCTREEO0TJRCC02UPOYCYJIGB&client_secret=GYUAW432FZ1UJ4PX4TM3IGSYNO2QAHMNAV4OR2DUKCHMJULJ&v=20150120&categoryId=4d4b7105d754a06374d81259

  # Recommended venue list doesn't have necessary info to search by group or tag - we need to get venue ids and make an API call to pull all the info for each venue. 
  def get_venue_ids
    @recommended_venues.each do |venue| 
      @venue_ids << venue["venue"]["id"] 
    end
    @venue_ids
  end

  def get_venues_to_search
    @venue_ids.each do |id|
      api_response = HTTParty.get("https://api.foursquare.com/v2/venues/#{id}?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&v=#{Time.now.strftime("%Y%m%d")}&m=foursquare")
      # puts api_response['response']['venue']
      @venues_to_search << api_response['response']['venue']
    end
    @venues_to_search
  end
  # Example uri: https://api.foursquare.com/v2/venues/4acca438f964a5201dc920e3?client_id=JUUFHYCI1ZWKTMHF5GEG1ZODCTREEO0TJRCC02UPOYCYJIGB&client_secret=GYUAW432FZ1UJ4PX4TM3IGSYNO2QAHMNAV4OR2DUKCHMJULJ&v=20150120&m=foursquare

  # Example groups to search by include ["outdoor seating","payments","price","reservations","music","drinks","dining options","parking","wheelchair accessible" ]
  def search_by_group(group="Outdoor Seating")
    @venues_to_search.each do |venue|
      venue['attributes']['groups'].each do |groups|
        if groups["name"].downcase == group.downcase
          groups["items"].each do |item|
            if item["displayValue"].split(" ").first != "No"
              @venues_by_group << venue["name"]
            end
          end
        end
      end  
    end
    @venues_by_group
  end

  # Example tags that you can search for (from Momofuku Ssam Bar): ["david chang","pork","pork buns","spicy rice cakes","steamed buns","trendy","zagat-rated"]
  def search_by_tag(tag="trendy")
    @venues_to_search.each do |venue|
      venue["tags"].each do |venue_tag|
        if venue_tag.downcase == tag.downcase
          @venues_by_tag << venue["name"]
        end
      end  
    end
  end

end