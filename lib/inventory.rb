require 'rest-client'

class Inventory
  @@site = nil

  def Inventory.connect
    # Load configuration and build the corresponding resources
    config = JSON.parse File.read(File.dirname(__FILE__) + '/../etc/inventory.json'), { symbolize_names: true }

    @@site = RestClient::Resource.new config[:api], config[:options]
  end

  def Inventory.api
    @@site
  end
end
