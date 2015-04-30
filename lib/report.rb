require 'json'

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

    @data = { 
      reporter: { type: asset.type },
    }

    return self
  end

  #
  # Add information to the report
  #
  def add more_data
    more_data.each do |collector,data|
      @data[collector].merge data
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
    # Submit the half-finished object via a post request
    response = Inventory.request['reports'].post self.to_json, :content_type => :json, :accept => :json
    report = JSON.parse(response)

    @id = report['id']
  end

  #
  # Update the report in the inventory
  #
  def update
    # Submit the half-finished object via a post request
    response = Inventory.request["reports/#{@id}"].put self.to_json, :content_type => :json, :accept => :json
    report = JSON.parse(response)
  end
end
