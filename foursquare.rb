require 'httparty'

class Neighborhood

  attr_accessor :location, :recommended_venues, :venue_ids, :venues_to_filter, :venues_by_group, :venues_by_tag, :api_response

  ##!!!NEEDS TO BE FILLED OUT WITH CLIENT ID AND SECRET PROVIDED BY FOURSQUARE
  # CLIENT_ID = ""
  # CLIENT_SECRET = ""

  def initialize(location)
    @location = location
    @recommended_venues = []
    @venue_ids = []
    @venues_to_filter = []
    @venues_by_group = []
    @venues_by_tag = []
  end

  # This user the Foursquare explore endpoint to pull recommended food venues for a location
  def get_recommended_venues
    uri = "https://api.foursquare.com/v2/venues/explore?near=#{@location}&client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&v=#{Time.now.strftime("%Y%m%d")}&categoryId=4d4b7105d754a06374d81259&limit=10"
    encoded = URI.parse(URI.encode(uri)) # to handle spaces in the location
    @api_response = HTTParty.get(encoded)
    @api_response['response']['groups'][0]["items"].each do |item|
      @recommended_venues << item["venue"]
    end
    @recommended_venues
    # puts encoded # uncomment to see the uri that is being used in the HTTP get request
  end

  # Example groups to search by include ["outdoor seating","credit cards","price","reservations","dining options","street parking","wheelchair accessible" ]
  def filter_by_group(group)
    get_venues_for_filtering
    @venues_to_filter.each do |venue|
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

  # Example tags ["trendy","zagat-rated","david chang","pork","steamed buns"]
  def filter_by_tag(tag)
    get_venues_for_filtering
    @venues_to_filter.each do |venue|
      venue["tags"].each do |venue_tag|
        if venue_tag.downcase == tag.downcase
          @venues_by_tag << venue["name"]
        end
      end
    end
  end

  # Our recommended venue list doesn't have all the necessary info to pull out info like "outdoor seating". To get that info we need to get venue ids and make an API call for more info on each venue.
  def get_venue_ids
    @recommended_venues.each do |venue|
      @venue_ids << venue["id"]
    end
    @venue_ids
  end

  def get_venues_for_filtering
    get_venue_ids
    @venue_ids.each do |id|
      uri = "https://api.foursquare.com/v2/venues/#{id}?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&v=#{Time.now.strftime("%Y%m%d")}&m=foursquare"
      api_response = HTTParty.get(uri)
      puts uri # So we can see the uri that is being used in the HTTP GET request
      @venues_to_filter << api_response['response']['venue']
    end
    @venues_to_filter
  end

end
