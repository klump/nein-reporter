require 'rest-client'

class Inventory
  @@site = nil

  #
  # Create the resource
  #
  def Inventory.configure
    # Load configuration and build the corresponding resources
    config = JSON.parse File.read(File.dirname(__FILE__) + '/../etc/inventory.json'), { symbolize_names: true }

    @@site = RestClient::Resource.new config[:api], config[:options]
  end

  #
  # Return the resource object
  #
  def Inventory.request
    @@site
  end
end
