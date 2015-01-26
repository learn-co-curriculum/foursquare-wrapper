---
tags: kids, ruby, foursquare, apis
languages: ruby
level: 1
type: Intro, Documentation
---


## Foursquare Wrapper

This is a Ruby library that wraps the Foursquare API, i.e. we get to write Ruby code to get Foursquare data!

###Installation
1. If you haven't already, please create a new directory for your project - you might want to call it something like `foursquare-app`. Hint: You can create this from in terminal by typing `mkdir foursquare-app`. 

2. Inside of the `foursquare-app` direcrory, please create a file called `foursquare.rb`. Hint: You can create this file from your command line, by entering the `foursquare-app` directory and typing `touch foursquare.rb`.

3. Please copy all of the code in `foursquare.rb` from this repository and paste it into the `foursquare.rb` file that you created on your computer.

4. In terminal, from inside any directory, type `gem install httparty`


###Usage

####Setting up Client ID and Secret

Register a new app with [Foursquare](https://foursquare.com/developers/apps) and copy and then paste your client id and client secret on lines 8 and 9 after the equals sign. These need to be strings, so make sure you surround them in quotation marks. Make sure to uncomment out the lines of code too, by deleting the `#` in front of the variables.

####Classes
This library is wrapped in a Neighborhood class.

A neighborhood has the following attributes:
* location
* recommended_venues
* venue_ids
* venues_for_search
* venues_by_group

We'll be using these attributes to narrow down our search to find a group of recommended restaurant that fit certain search criteria. Here are the types of groups that we can search for:

* Reservations
* Credit Cards
* Delivery
* Outdoor Seating
* Street Parking
* Wheelchair Accessible


### Create a New Neighborhood

```ruby
  east_village = Neighborhood.new("East Village, New York, NY")
```

In this code, we are creating a new instance of the Neighborhood class by calling `Neighborhood.new`. We're storing that new instance in a variable called `east_village`. 

The `initialize` method accepts one argument, the neighborhood you want to search. In this case, we're passing in `East Village, New York, NY`. Next


### Get Recommended Venues

```ruby
east_village.get_recommended_venues
```

This method uses the Foursquare API "venues/explore" endpoint to pull a list of up to 30 recommended restaurants for the selected neighborhood and stores all of their info in the `@recommended_venues1` array.


#### Filter by Group

```ruby
east_village.filter_by_group("outdoor seating")
```

The `filter_by_group` method checks for restaurants that match the specified grouping like "Outdoor Seating". If a restaurant matches the group the restaurant name is added to a `@venues_by_group` array. This method is set up to only store the restaurant names, but it can be tweaked to grab additional info for each restaurant. 

The `filter_by_group` method relies on two other methods that are called in a cascade - `filter_by_group` calls `get_venues_for_search` which calls `get_venue_ids`. You don't necessarily need to know how these methods work to use the wrapper, but details are included below. 


#### Other Methods in the Wrapper

The `filter_by_group` method relies on a couple additional methods to narrow down the recommended restaurants to a specific group. 
We have a ton of info about each restaurant in our `@recommended_venues` list, but if we want to drill deeper and see which venues are wheelchair accessible or have outdoor seating we need EVEN more detail. The methods below are used to create API calls to pull more info on each of the venues in our `@recommended_venues` list.

### get_venue_ids

```ruby
  east_village.get_venue_ids
```

The `get_venue_ids` method takes the array of all the recommended restaurants, and iterates through them to pull the unique id associated with each. This method returns an `@venue_ids` array, with just the unique id number for each restaurant.

#### get_venues_for_search

```ruby
east_village.get_venues_for_search
```

The `get_venues_for_search` method iterates through the `@venue_ids` array, and makes a GET request to the Foursquare API to get more information for each venue. It returns a `@venues_for_search` array with all of the venue info for each restaurant.






