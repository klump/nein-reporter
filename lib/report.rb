require 'json'

class Report
  #
  # Create a new report
  # The attributes map to the ones of the report in the inventory
  #

  def initialize
    @id = nil
    @asset_id = determine_asset_id
    @data = {}
    @starttime = Time.now
    @endtime = nil
    @status = :started
  end

  #
  # Create the report to the inventory to tell that we have started
  #
  def create
    summarize
  end

  #
  # Collect information
  #
  def collect
    Collector.subclasses.each do |collector|
      collector_instance = collector.new
      collector_instance.run
      @data[collector::NAME] = collector_instance.report
    end

    @status = :success
    @endtime = Time.now
  end

  #
  # Update the final report to the inventory
  #
  def update
    summarize
  end

  private
    #
    # Attepmt to identify the ID of the asset
    #
    def determine_asset_id
      `sudo dmidecode -s system-serial-number`.chomp
    end

    def summarize
      {
        id: @id,
        asset_id: @asset_id,
        data: @data,
        starttime: @starttime,
        endtime: @endtime,
        status: @status,
      }
    end
end
