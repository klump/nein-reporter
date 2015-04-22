class Asset
  # Create empty arrays for every asset type
  @@collectors = {
    :computer => {},
    :hard_drive => {}
  }

  def Asset.add_collector type, priority, collector
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

    @name = determine_name
    @id = fetch_id
    @options=options
  end

  #
  # Run the collectors associated with the asset 
  #
  def inventory
    @report = Report.new(get_id_from_inventory(@id))
    if ( @report.asset_id.nil? )
      return nil
    end

    @@collectors[@type].keys.sort.each do |priority|
      @@collectors[@type][priority].each do |collector|
        c = collector.new
        c.run
        @report.add collector::NAME, c.to_hash
      end
    end

    # End the report and return the results
    @report.finalize
  end

  private
    #
    # Determine the name of the asset
    #
    def determine_name
      name = nil

      case @type
        when :computer
          name = `sudo dmidecode -s system-serial-number`.chomp
        when :hard_drive
          `sudo smartctl -i #{@options["device"]}`.each_line do |line|
            line =~ /^Serial\sNumber:\s+([A-Za-z0-9_-]+)$/
            name = $1
          end
      end

      # Check if the id is valid (all word characters plus dash)
      if ( name =~ /^[A-Za-z0-9_-]+$/ )
        name
      else
        return
      end
    end
    #
    # Fetch the ID from the inventory
    #
    def fetch_id
      return unless @name

      p Inventory.request["assets/#{@name}"]
    end
end
