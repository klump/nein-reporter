require 'json'
require 'socket'

class Report
  attr_accessor :status, :data

  #
  # Create a new report
  # The attributes map to the ones of the report in the inventory
  #
  def initialize asset
    @asset = asset
    @starttime = Time.now
    @endtime = nil
    @status = :running

    ipaddress = nil
    Socket.ip_address_list.each do |ipaddr|
      ipaddress = ipaddr if ipaddr.ipv4? && !ipaddr.ipv4_lookback?
      break
    end

    @data = { 
      reporter: {
        type: asset.type,
        ipaddress:  ipaddress,
      },
    }

    return self
  end

  #
  # Add information to the report
  #
  def add more_data
    more_data.each do |collector,new_data|
      case @data[collector]
      when nil
        @data[collector] = new_data
      when Hash
        @data[collector].merge new_data
      end
    end
  end

  #
  # Consider the report as successful finished
  # Set endtime and submit all information to the inventory server
  #
  def finalize
    @status = :pass
    @endtime = Time.now
  end

  #
  # Generate a JSON object as expected by the NEIN API
  #
  def to_json
    ({
      report: {
        id: @id,
        status: @status,
        starttime: @starttime,
        endtime: @endtime,
        data: @data,
        asset_id: @asset_id
      }
    }).to_json
  end
  
  #
  # Create the report in the inventory and set the report ID (assigned by the server)
  # 
  def create
    begin
      # Submit the half-finished object via a post request
      response = Inventory.request['reports'].post self.to_json, :content_type => :json, :accept => :json
      report = JSON.parse(response)

      @id = report['id']
    rescue => exception
      puts exception.message
      puts exception.response
      exit 1
    end
  end

  #
  # Update the report in the inventory
  #
  def update
    @endtime = Time.now
    begin
      # Submit the half-finished object via a post request
      response = Inventory.request["reports/#{@id}"].put self.to_json, :content_type => :json, :accept => :json
      report = JSON.parse(response)
    rescue => exception
      puts exception.message
      puts exception.response
      exit 1
    end
  end
end
