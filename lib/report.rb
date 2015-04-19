require 'json'

class Report
  attr_accessor :asset_id, :status

  #
  # Create a new report
  # The attributes map to the ones of the report in the inventory
  #
  def initialize asset_id=nil
    @id = nil
    @data = {}
    @starttime = Time.now
    @endtime = nil
    @status = :unknown

    # Set the asset ID
    if ( asset_id.nil? )
      # If no asset ID was found, fail the report and add an error message
      @status = :critical
      add "report", { "error" => "Could not find a valid ID for the asset" }
    else
      @asset_id = asset_id
    end

    create

    return self
  end

  #
  # Add information to the data field
  #
  def add collector, data
    @data[collector] = data
  end

  #
  # Consider the report as finished
  # Set endtime and submit all information to the inventory server
  #
  def finalize
    @endtime = Time.now

    update
  end

  private
    #
    # Create the report in the inventory and set the report ID (assigned by the server)
    # 
    def create
      puts "POST /reports"
      puts summarize

      # Submit the half-finished object via a post request
      Inventory.request['reports'].post summarize.to_json, :content_type => :json, :accept => :json

      @id = (rand*100).floor
    end

    #
    # Update the report in the inventory
    #
    def update
      puts "PUT /reports/#{@id}"
      puts summarize

      # Submit the half-finished object via a post request
      Inventory.request["reports/#{@id}"].put summarize.to_json, :content_type => :json, :accept => :json
    end

    #
    # Generate a hash as expected by the inventory database
    #
    def summarize
      {
        id: @id,
        asset_id: @asset_id,
        data: @data,
        starttime: @starttime,
        endtime: @endtime,
        status: @status
      }
    end
end
