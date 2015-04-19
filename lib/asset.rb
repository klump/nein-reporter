class Asset
  # Create empty arrays for every asset type
  @@collectors = {
    :computer => [],
    :hard_drive => []
  }

  def Asset.add_collector type, priority, collector
    @@collectors[type] = {} if @@collectors[type].nil?
    @@collectors[type][priority] = [] if @@collectors[type][priority].nil?
    @@collectors[type][priority] << collector
  end

  #
  # Create a new instance of an asset. The type has to match
  # the one of the keys in the collectors hash.
  # Then try to get the ID ofthe asset. 
  #
  def initialize type, options={}
    if ( @@collectors.keys.include?(type) )
      @type = type
    else
      raise TypeError
    end

    @id = determine_id
    @options=options
  end

  #
  # Run the collectors associated with the asset 
  #
  def inventory
    @report = Report.new determine_id
    if ( @report.asset_id.nil? )
      return nil
    end

    @@collectors[@type].sort do |priority|
      @@collectors[@type][priority].each do |collector|
        c = collector.new
        c.run
        @report.add collector::NAME, c.report
      end
    end

    # End the report and return the results
    @report.finalize
  end

  private
    #
    # Attepmt to identify the ID of the asset
    #
    def determine_id
      id = nil

      case @type
      when :computer
        id = `sudo dmidecode -s system-serial-number`.chomp

        # Check if the id is valid (all word characters plus dash)
        return nil unless ( id =~ /^[A-Za-z0-9_-]+$/ )
      when :hard_drive
        `sudo smartctl -i #{@options["device"]}`.each_line do |line|
          line =~ /^Serial\sNumber:\s+([A-Za-z0-9_-]+)$/
        end
      end

      id
    end
end
