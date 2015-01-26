class Restaurant
  attr_accessor :name, :phone, :address, :website

  def initialize(name, phone, address, website)
    @name = name
    @phone = phone
    @address = address
    @website = website
  end

end