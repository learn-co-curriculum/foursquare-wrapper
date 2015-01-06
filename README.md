## Foursquare Wrapper

This is a Ruby libray that wraps the Foursquare API, aka we get to write Ruby code to get Foursquare data!

###Installation
1. If you haven't already, please create a new directory on your Desktop called `foursquare`. You can create this by typing `mkdir foursquare`. 

2. Inside of the `foursquare` direcrory, please create a file called `foursquare_code.rb`. You can create this file in terminal, by entering within the `foursquare` directory, `touch foursquare_code.rb`.

3. Please copy all of the code in `foursquare.rb` from this repository and paste it into the `foursquare_code.rb` file that you created on your computer.

4. In terminal, from inside any directory, type `gem install httparty`


###Usage

####Setting up Client ID and Secret

Please copy and paste the client id and client secret provided to you on lines 8 and 9 after the equals sign. You will want to put the id and secret in your code as a string, so make sure you surround them in quotation marks. You also want to uncomment out the lines of code, so please delete the `#` in front of the variables.

####Classes
This library is wrapped in a Neighborhood class.

A neighborhood has the following attributes:
* group
* location
* correct_venues

### Create a New Neighborhood

```ruby
  east_village = Neighborhood.new("East Village, New York, NY", "Outdoor Seating")
```

In this code, we are creating a new instance of the Neighborhood class by calling `Neighborhood.new`. We're storing that new instance in a variable called `east_village`. 

The `initialize` method accepts two arguments, the neighborhood you want to search and what restaurant groupings  you want. In this case, we're passing in `East Village, New York, NY` and `Outdoor Seating`

Other groups include:
* Reservations
* Credit Card
* Lunch
* Dinner
* Dessert
* Breakfast
* Outdoor Seating

#### search

```ruby
east_village.search
```

The `search` method makes a GET request to Foursquare and returns an array of all of the restaurants in a given neighborhood. That array is stored in the `@venues` attribute. This array contains a lot of information about all the restaurants, but does not include the specific information we want about restaurant groupings. 

#### get_venue_ids

```ruby
  east_village.get_venue_ids
```

The `get_venue_ids` method takes the array of all the restaurants, and sorts through them to just pull the unique id associated with each restaurant. This method returns the @venues array, but this time the array contains just the unqiue id number for each restaurant.

####check_group

```ruby
east_village.check_group
```

The `check_group` method iterates through the @venues array, and makes a GET request to the Foursquare API for each restaurant to check specific information to see if it matches the grouping we specified. In this case, this method checks to see if the restaurant has the `Outdoor Seating` grouping. 

This method returns the `@correct_venues` attribute, which contains an array of all the restaurant names that match both the neighborhood and group. 






